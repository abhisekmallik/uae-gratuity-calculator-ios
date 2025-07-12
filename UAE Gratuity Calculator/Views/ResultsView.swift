import SwiftUI

// MARK: - Results View
struct ResultsView: View {
    let result: EOSBCalculationResult
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        VStack(spacing: 20) {
            // Results Header
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: result.isEligible ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(result.isEligible ? .green : .red)
        
                    Text(result.isEligible ?
                         localization.localizedString(for: "results.eligible") :
                         localization.localizedString(for: "results.notEligible"))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(result.isEligible ? .green : .red)
                }
                
                Text(localization.localizedString(for: "results.title"))
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            if result.isEligible {
                // Total Amount Card
                VStack(spacing: 16) {
                    Text(localization.localizedString(for: "results.totalAmount"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("AED \(formatCurrency(result.gratuityAmount))")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                )
                
                // Service Period
                ServicePeriodView(result: result)
                    .environmentObject(localization)
                
                // Calculation Breakdown
                CalculationBreakdownView(result: result)
                    .environmentObject(localization)
                
                // Summary Details
                SummaryDetailsView(result: result)
                    .environmentObject(localization)
            } else {
                // Not Eligible Message
                VStack(spacing: 12) {
                    Image(systemName: "info.circle")
                        .font(.title)
                        .foregroundColor(.orange)
                    
                    Text(result.reason ?? "Not eligible for gratuity")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "0.00"
    }
}

// MARK: - Service Period View
struct ServicePeriodView: View {
    let result: EOSBCalculationResult
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(localization.localizedString(for: "results.servicePeriod"))
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack(spacing: 20) {
                ServicePeriodItem(
                    value: Int(result.totalServiceYears),
                    unit: localization.localizedString(for: "results.years"),
                    color: .blue
                )
                
                ServicePeriodItem(
                    value: Int(result.totalServiceMonths),
                    unit: localization.localizedString(for: "results.months"),
                    color: .green
                )
                
                ServicePeriodItem(
                    value: Int(result.totalServiceDays),
                    unit: localization.localizedString(for: "results.days"),
                    color: .orange
                )
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ServicePeriodItem: View {
    let value: Int
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(color)
            
            Text(unit)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Calculation Breakdown View
struct CalculationBreakdownView: View {
    let result: EOSBCalculationResult
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(localization.localizedString(for: "results.breakdown"))
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                // First 5 Years
                if result.breakdown.firstFiveYears.years > 0 {
                    BreakdownRow(
                        title: localization.localizedString(for: "results.firstFiveYears"),
                        years: result.breakdown.firstFiveYears.years,
                        rate: Int(result.breakdown.firstFiveYears.rate),
                        amount: result.breakdown.firstFiveYears.amount,
                        localization: localization
                    )
                }
                
                // Additional Years
                if result.breakdown.additionalYears.years > 0 {
                    BreakdownRow(
                        title: localization.localizedString(for: "results.additionalYears"),
                        years: result.breakdown.additionalYears.years,
                        rate: Int(result.breakdown.additionalYears.rate),
                        amount: result.breakdown.additionalYears.amount,
                        localization: localization
                    )
                }
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct BreakdownRow: View {
    let title: String
    let years: Double
    let rate: Int
    let amount: Double
    let localization: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(String(format: "%.1f", years)) \(localization.localizedString(for: "results.years"))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("\(rate) \(localization.localizedString(for: "results.daysPerYear"))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("AED \(formatCurrency(amount))")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "0.00"
    }
}

// MARK: - Summary Details View
struct SummaryDetailsView: View {
    let result: EOSBCalculationResult
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Summary")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(spacing: 8) {
                SummaryRow(
                    label: localization.localizedString(for: "summary.basicSalary"),
                    value: "AED \(formatCurrency(result.basicSalaryAmount))"
                )
                
                SummaryRow(
                    label: localization.localizedString(for: "summary.totalSalary"),
                    value: "AED \(formatCurrency(result.totalSalary))"
                )
                
                SummaryRow(
                    label: localization.localizedString(for: "summary.eligibleYears"),
                    value: String(format: "%.2f", result.eligibleYears)
                )
                
                SummaryRow(
                    label: localization.localizedString(for: "summary.dailyWage"),
                    value: "AED \(formatCurrency(result.totalSalary / 30))"
                )
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "0.00"
    }
}

struct SummaryRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - About Section View
struct AboutSectionView: View {
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        VStack(spacing: 20) {
            // About UAE EOSB Calculator
            AboutCard(
                icon: "info.circle",
                title: localization.localizedString(for: "about.title"),
                description: localization.localizedString(for: "about.description")
            ) {
                VStack(alignment: .leading, spacing: 16) {
                    AboutSubsection(
                        title: localization.localizedString(for: "about.formula.title"),
                        content: localization.localizedString(for: "about.formula.description")
                    )
                    
                    AboutSubsection(
                        title: localization.localizedString(for: "about.rules.title"),
                        content: nil
                    ) {
                        VStack(alignment: .leading, spacing: 6) {
                            BulletPoint(text: localization.localizedString(for: "about.rules.firstFive"))
                            BulletPoint(text: localization.localizedString(for: "about.rules.afterFive"))
                            BulletPoint(text: localization.localizedString(for: "about.rules.minimum"))
                        }
                    }
                }
            }
            
            // Resignation Penalties
            AboutCard(
                icon: "building.2",
                title: localization.localizedString(for: "about.penalties.title"),
                description: nil
            ) {
                VStack(spacing: 16) {
                    // Penalty List
                    VStack(alignment: .leading, spacing: 4) {
                        PenaltyRow(
                            indicator: .red,
                            text: localization.localizedString(for: "about.penalties.lessThanOne")
                        )
                        PenaltyRow(
                            indicator: .yellow,
                            text: localization.localizedString(for: "about.penalties.oneToThree")
                        )
                        PenaltyRow(
                            indicator: .blue,
                            text: localization.localizedString(for: "about.penalties.threeToFive")
                        )
                        PenaltyRow(
                            indicator: .green,
                            text: localization.localizedString(for: "about.penalties.fiveOrMore")
                        )
                    }
                    
                    // Disclaimer
                    VStack(spacing: 8) {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "exclamationmark.shield")
                                .font(.system(size: 16))
                                .foregroundColor(Color(.purple))
                            
                            Text(localization.localizedString(for: "footer.disclaimer"))
                                .font(.caption)
                                .foregroundColor(Color(.darkGray))
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding(16)
                    .background(Color(.systemGray4))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            
            // Footer
            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    Text(localization.localizedString(for: "footer.madeWith"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Image(systemName: "heart.fill")
                        .font(.caption)
                        .foregroundColor(.red)
                    
                    Text(localization.localizedString(for: "footer.forEmployees"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text("© 2025 Abhisek Mallik - \(localization.localizedString(for: "footer.rights"))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct AboutCard<Content: View>: View {
    let icon: String
    let title: String
    let description: String?
    let content: Content
    
    init(icon: String, title: String, description: String?, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.title = title
        self.description = description
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header Section
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    if let description = description {
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
            }
            
            // Content Section
            content
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

struct AboutSubsection<Content: View>: View {
    let title: String
    let content: String?
    let customContent: Content?
    
    init(title: String, content: String?) where Content == EmptyView {
        self.title = title
        self.content = content
        self.customContent = nil
    }
    
    init(title: String, content: String?, @ViewBuilder customContent: () -> Content) {
        self.title = title
        self.content = content
        self.customContent = customContent()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            if let content = content {
                Text(content)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let customContent = customContent {
                customContent
            }
        }
    }
}

struct BulletPoint: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            Text("•")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct PenaltyRow: View {
    let indicator: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(indicator)
                .frame(width: 8, height: 8)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}
