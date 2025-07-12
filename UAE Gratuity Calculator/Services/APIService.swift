import Foundation

class APIService: ObservableObject {
    static let shared = APIService()
    
    private let baseURL = "https://uae-gratuity-calculator-backend.vercel.app"
    private let session = URLSession.shared
    
    private init() {}
    
    // MARK: - Configuration API
    func fetchConfiguration() async throws -> ConfigurationData {
        let url = URL(string: "\(baseURL)/api/eosb/config")!
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        let apiResponse = try JSONDecoder().decode(ApiResponse<ConfigurationData>.self, from: data)
        
        guard apiResponse.success, let configData = apiResponse.data else {
            throw APIError.apiError(apiResponse.error ?? "Unknown error")
        }
        
        return configData
    }
    
    // MARK: - EOSB Calculation API
    func calculateEOSB(employeeData: EmployeeData) async throws -> EOSBCalculationResult {
        let url = URL(string: "\(baseURL)/api/eosb/calculate")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(employeeData)
        } catch {
            throw APIError.encodingError
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            if httpResponse.statusCode == 400 {
                // Parse validation error
                if let errorResponse = try? JSONDecoder().decode(ApiResponse<String>.self, from: data) {
                    throw APIError.validationError(errorResponse.error ?? "Validation failed")
                }
            }
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        let apiResponse = try JSONDecoder().decode(ApiResponse<EOSBCalculationResult>.self, from: data)
        
        guard apiResponse.success, let result = apiResponse.data else {
            throw APIError.apiError(apiResponse.error ?? "Calculation failed")
        }
        
        return result
    }
    
    // MARK: - Health Check
    func checkHealth() async throws -> Bool {
        let url = URL(string: "\(baseURL)/api/eosb/health")!
        
        do {
            let (_, response) = try await session.data(from: url)
            return (response as? HTTPURLResponse)?.statusCode == 200
        } catch {
            return false
        }
    }
}

// MARK: - API Errors
enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case encodingError
    case decodingError
    case serverError(Int)
    case apiError(String)
    case validationError(String)
    case networkError
    case timeout
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .encodingError:
            return "Failed to encode request data"
        case .decodingError:
            return "Failed to decode response data"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .apiError(let message):
            return message
        case .validationError(let message):
            return "Validation error: \(message)"
        case .networkError:
            return "Network connection failed. Please check your internet connection."
        case .timeout:
            return "Request timed out. Please try again."
        }
    }
}

// MARK: - Date Formatter Extension
extension DateFormatter {
    static let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}

// MARK: - EmployeeData Extension
extension EmployeeData {
    init(from formData: CalculatorFormData) throws {
        guard let basicSalaryValue = Double(formData.basicSalary),
              basicSalaryValue > 0 else {
            throw ValidationError.invalidBasicSalary
        }
        
        guard let terminationType = formData.selectedTerminationType?.value else {
            throw ValidationError.missingTerminationType
        }
        
        guard let contractType = formData.selectedContractType?.value else {
            throw ValidationError.missingContractType
        }
        
        guard formData.joiningDate <= formData.lastWorkingDay else {
            throw ValidationError.invalidDateRange
        }
        
        self.basicSalary = basicSalaryValue
        self.terminationType = terminationType
        self.isUnlimitedContract = contractType
        self.joiningDate = DateFormatter.apiDateFormatter.string(from: formData.joiningDate)
        self.lastWorkingDay = DateFormatter.apiDateFormatter.string(from: formData.lastWorkingDay)
    }
}

// MARK: - Validation Errors
enum ValidationError: LocalizedError {
    case invalidBasicSalary
    case missingTerminationType
    case missingContractType
    case invalidDateRange
    
    var errorDescription: String? {
        switch self {
        case .invalidBasicSalary:
            return "Please enter a valid basic salary amount"
        case .missingTerminationType:
            return "Please select a termination type"
        case .missingContractType:
            return "Please select a contract type"
        case .invalidDateRange:
            return "Last working day must be after joining date"
        }
    }
}
