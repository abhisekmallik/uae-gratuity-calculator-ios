import Foundation
import Network
import UIKit
import SwiftUI

// MARK: - API Models
struct EmployeeData: Codable {
    let basicSalary: Double
    let terminationType: String
    let isUnlimitedContract: Bool
    let joiningDate: String
    let lastWorkingDay: String
}

struct EOSBCalculationResult: Codable {
    let totalServiceYears: Double
    let totalServiceMonths: Double
    let totalServiceDays: Double
    let basicSalaryAmount: Double
    let totalSalary: Double
    let eligibleYears: Double
    let gratuityAmount: Double
    let breakdown: CalculationBreakdown
    let isEligible: Bool
    let reason: String?
}

struct CalculationBreakdown: Codable {
    let firstFiveYears: ServicePeriod
    let additionalYears: ServicePeriod
}

struct ServicePeriod: Codable {
    let years: Double
    let rate: Double
    let amount: Double
}

struct ConfigurationData: Codable {
    let terminationTypes: [DropdownOption]
    let contractTypes: [ContractOption]
    let calculationRules: CalculationRules
}

struct DropdownOption: Codable, Identifiable {
    let id = UUID()
    let value: String
    let label: String
    let labelAr: String
    
    private enum CodingKeys: String, CodingKey {
        case value, label, labelAr
    }
}

struct ContractOption: Codable, Identifiable {
    let id = UUID()
    let value: Bool
    let label: String
    let labelAr: String
    
    private enum CodingKeys: String, CodingKey {
        case value, label, labelAr
    }
}

struct CalculationRules: Codable {
    let minimumServiceDays: Int
    let firstFiveYearsRate: Double
    let additionalYearsRate: Double
    let resignationPenalty: ResignationPenalty
}

struct ResignationPenalty: Codable {
    let lessThanOneYear: Double
    let lessThanThreeYears: Double
    let lessThanFiveYears: Double
    let fiveYearsOrMore: Double
}

struct ApiResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let message: String?
    let error: String?
}

// MARK: - UI Models
class CalculatorFormData: ObservableObject {
    @Published var basicSalary: String = ""
    @Published var selectedTerminationType: DropdownOption?
    @Published var selectedContractType: ContractOption?
    @Published var joiningDate: Date = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
    @Published var lastWorkingDay: Date = Date()
    
    @Published var isCalculating: Bool = false
    @Published var calculationResult: EOSBCalculationResult?
    @Published var errorMessage: String?
    
    var isFormValid: Bool {
        guard let basicSalaryValue = Double(basicSalary),
              basicSalaryValue > 0,
              selectedTerminationType != nil,
              selectedContractType != nil,
              joiningDate <= lastWorkingDay else {
            return false
        }
        return true
    }
    
    func reset() {
        basicSalary = ""
        selectedTerminationType = nil
        selectedContractType = nil
        joiningDate = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        lastWorkingDay = Date()
        calculationResult = nil
        errorMessage = nil
    }
}

// MARK: - App State
class AppState: ObservableObject {
    @Published var configurationData: ConfigurationData?
    @Published var isLoadingConfiguration: Bool = false
    @Published var configurationError: String?
    @Published var selectedLanguage: Language = .english
    @Published var isDarkMode: Bool = false
    @Published var formRefreshTrigger: UUID = UUID() // Add this to force form re-rendering
    
    init() {
        // Set initial color scheme based on system settings
        if #available(iOS 13.0, *) {
            DispatchQueue.main.async {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    self.isDarkMode = window.traitCollection.userInterfaceStyle == .dark
                } else {
                    // Fallback to default trait collection
                    self.isDarkMode = UITraitCollection.current.userInterfaceStyle == .dark
                }
            }
        } else {
            self.isDarkMode = false
        }
    }
    
    // Function to update based on system color scheme
    func updateFromSystemColorScheme(_ colorScheme: ColorScheme) {
        self.isDarkMode = colorScheme == .dark
    }
    
    enum Language: String, CaseIterable {
        case english = "en"
        case arabic = "ar"
        
        var displayName: String {
            switch self {
            case .english: return "English"
            case .arabic: return "العربية"
            }
        }
        
        var isRTL: Bool {
            return self == .arabic
        }
    }
}

// MARK: - Network Monitor
class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "NetworkMonitor")
    @Published var isConnected = false
    
    init() {
        networkMonitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
    
    deinit {
        networkMonitor.cancel()
    }
}
