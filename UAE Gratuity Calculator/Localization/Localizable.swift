import Foundation

// MARK: - Localization Manager
class LocalizationManager: ObservableObject {
    @Published var currentLanguage: AppState.Language = .english
    
    func localizedString(for key: String) -> String {
        return LocalizedStrings.string(for: key, language: currentLanguage)
    }
    
    func setLanguage(_ language: AppState.Language) {
        currentLanguage = language
    }
}

// MARK: - Localized Strings
struct LocalizedStrings {
    static func string(for key: String, language: AppState.Language) -> String {
        switch language {
        case .english:
            return englishStrings[key] ?? key
        case .arabic:
            return arabicStrings[key] ?? englishStrings[key] ?? key
        }
    }
    
    // MARK: - English Strings
    private static let englishStrings: [String: String] = [
        // App
        "app.title": "UAE Gratuity Calculator",
        "app.subtitle": "Calculate End of Service Benefits according to UAE Labor Law",
        
        // Navigation
        "navigation.calculator": "Calculator",
        "navigation.about": "About",
        "navigation.help": "Help",
        
        // Themes
        "themes.light": "Light",
        "themes.dark": "Dark",
        "themes.system": "System",
        
        // Languages
        "languages.en": "English",
        "languages.ar": "العربية",
        
        // Form
        "form.title": "Employment Details",
        "form.description": "Enter your employment information to calculate your End of Service Benefits",
        "form.basicSalary.label": "Basic Salary (AED)",
        "form.basicSalary.placeholder": "Enter basic salary",
        "form.basicSalary.description": "Monthly basic salary amount",
        "form.allowances.label": "Allowances (AED)",
        "form.allowances.placeholder": "Enter allowances (optional)",
        "form.allowances.description": "Monthly allowances amount",
        "form.terminationType.label": "Termination Type",
        "form.terminationType.placeholder": "Select termination type",
        "form.terminationType.description": "How the employment ended",
        "form.contractType.label": "Contract Type",
        "form.contractType.placeholder": "Select contract type",
        "form.contractType.description": "Type of employment contract",
        "form.joiningDate.label": "Joining Date",
        "form.joiningDate.placeholder": "Select joining date",
        "form.joiningDate.description": "Date when employment started",
        "form.lastWorkingDay.label": "Last Working Day",
        "form.lastWorkingDay.placeholder": "Select last working day",
        "form.lastWorkingDay.description": "Date when employment ended",
        "form.calculate": "Calculate EOSB",
        "form.calculating": "Calculating...",
        "form.clear": "Clear Form",
        
        // Results
        "results.title": "EOSB Calculation Results",
        "results.eligible": "Eligible for Gratuity",
        "results.notEligible": "Not Eligible for Gratuity",
        "results.totalAmount": "Total Gratuity Amount",
        "results.servicePeriod": "Service Period",
        "results.breakdown": "Calculation Breakdown",
        "results.years": "years",
        "results.months": "months",
        "results.days": "days",
        "results.firstFiveYears": "First 5 Years",
        "results.additionalYears": "Additional Years",
        "results.rate": "Rate",
        "results.amount": "Amount",
        "results.daysPerYear": "days per year",
        
        // Summary
        "summary.totalService": "Total Service",
        "summary.basicSalary": "Basic Salary",
        "summary.totalSalary": "Total Salary",
        "summary.eligibleYears": "Eligible Years",
        "summary.gratuityFormula": "Gratuity Formula",
        "summary.dailyWage": "Daily Wage",
        "summary.eligibleDays": "Eligible Days",
        
        // Calculation
        "calculation.success": "Calculation completed successfully!",
        
        // Errors
        "errors.required": "This field is required",
        "errors.invalidAmount": "Please enter a valid amount",
        "errors.invalidDate": "Please enter a valid date",
        "errors.joiningDateFuture": "Joining date cannot be in the future",
        "errors.lastWorkingDayBeforeJoining": "Last working day must be after joining date",
        "errors.apiError": "Failed to connect to server. Please try again.",
        "errors.calculationError": "Failed to calculate EOSB. Please check your inputs.",
        "errors.configError": "Failed to load configuration. Please refresh the page.",
        "errors.networkError": "Network connection failed. Please check your internet connection.",
        "errors.timeout": "Request timed out. Please try again.",
        "errors.unexpectedError": "An unexpected error occurred. Please try again.",
        "error.noInternet": "No internet connection. Please check your connection and try again.",
        
        // Server Down
        "serverDown.title": "Server Unavailable",
        "serverDown.description": "We're unable to connect to our servers at the moment.",
        "serverDown.checkConnection": "Please check your internet connection",
        "serverDown.tryAgainLater": "The service may be temporarily unavailable. Please try again in a few minutes.",
        "serverDown.retry": "Try Again",
        "serverDown.retrying": "Checking server...",
        "serverDown.goHome": "Go to Home",
        "serverDown.contactSupport": "If the problem persists, please contact support.",
        
        // Loading
        "loading.configuration": "Loading configuration...",
        "loading.calculating": "Calculating EOSB...",
        "loading.general": "Loading...",
        
        // About
        "about.title": "About UAE EOSB Calculator",
        "about.description": "This calculator implements the official UAE Labor Law Article 132 for End of Service Benefits calculation.",
        "about.formula.title": "Calculation Formula",
        "about.formula.description": "Gratuity = (Monthly Salary ÷ 30) × Eligible Days",
        "about.rules.title": "Calculation Rules",
        "about.rules.firstFive": "First 5 years: 21 days per year",
        "about.rules.afterFive": "After 5 years: 30 days per year",
        "about.rules.minimum": "Minimum service: 1 year (365 days)",
        "about.penalties.title": "Resignation Penalties (Unlimited Contracts Only)",
        "about.penalties.lessThanOne": "< 1 year: No gratuity",
        "about.penalties.oneToThree": "1-3 years: 1/3 of calculated gratuity",
        "about.penalties.threeToFive": "3-5 years: 2/3 of calculated gratuity",
        "about.penalties.fiveOrMore": "5+ years: Full gratuity",
        
        // Footer
        "footer.rights": "All rights reserved",
        "footer.disclaimer": "This calculator is for informational purposes only. Consult with legal professionals for official calculations.",
        "footer.madeWith": "Made with",
        "footer.forEmployees": "for UAE employees"
    ]
    
    // MARK: - Arabic Strings
    private static let arabicStrings: [String: String] = [
        // App
        "app.title": "حاسبة مكافأة نهاية الخدمة الإماراتية",
        "app.subtitle": "احسب مكافأة نهاية الخدمة وفقاً لقانون العمل الإماراتي",
        
        // Navigation
        "navigation.calculator": "الحاسبة",
        "navigation.about": "حول",
        "navigation.help": "مساعدة",
        
        // Themes
        "themes.light": "فاتح",
        "themes.dark": "داكن",
        "themes.system": "النظام",
        
        // Languages
        "languages.en": "English",
        "languages.ar": "العربية",
        
        // Form
        "form.title": "تفاصيل التوظيف",
        "form.description": "أدخل معلومات التوظيف الخاصة بك لحساب مكافأة نهاية الخدمة",
        "form.basicSalary.label": "الراتب الأساسي (درهم)",
        "form.basicSalary.placeholder": "أدخل الراتب الأساسي",
        "form.basicSalary.description": "مبلغ الراتب الأساسي الشهري",
        "form.allowances.label": "البدلات (درهم)",
        "form.allowances.placeholder": "أدخل البدلات (اختياري)",
        "form.allowances.description": "مبلغ البدلات الشهرية",
        "form.terminationType.label": "نوع إنهاء الخدمة",
        "form.terminationType.placeholder": "اختر نوع إنهاء الخدمة",
        "form.terminationType.description": "كيف انتهت الخدمة",
        "form.contractType.label": "نوع العقد",
        "form.contractType.placeholder": "اختر نوع العقد",
        "form.contractType.description": "نوع عقد التوظيف",
        "form.joiningDate.label": "تاريخ الالتحاق",
        "form.joiningDate.placeholder": "اختر تاريخ الالتحاق",
        "form.joiningDate.description": "تاريخ بداية التوظيف",
        "form.lastWorkingDay.label": "آخر يوم عمل",
        "form.lastWorkingDay.placeholder": "اختر آخر يوم عمل",
        "form.lastWorkingDay.description": "تاريخ انتهاء التوظيف",
        "form.calculate": "احسب مكافأة نهاية الخدمة",
        "form.calculating": "جارٍ الحساب...",
        "form.clear": "مسح النموذج",
        
        // Results
        "results.title": "نتائج حساب مكافأة نهاية الخدمة",
        "results.eligible": "مؤهل للمكافأة",
        "results.notEligible": "غير مؤهل للمكافأة",
        "results.totalAmount": "إجمالي مبلغ المكافأة",
        "results.servicePeriod": "فترة الخدمة",
        "results.breakdown": "تفصيل الحساب",
        "results.years": "سنوات",
        "results.months": "أشهر",
        "results.days": "أيام",
        "results.firstFiveYears": "أول 5 سنوات",
        "results.additionalYears": "السنوات الإضافية",
        "results.rate": "المعدل",
        "results.amount": "المبلغ",
        "results.daysPerYear": "يوم في السنة",
        
        // Loading
        "loading.configuration": "جارٍ تحميل الإعدادات...",
        "loading.calculating": "جارٍ حساب مكافأة نهاية الخدمة...",
        "loading.general": "جارٍ التحميل...",
        
        // About
        "about.title": "حول حاسبة مكافأة نهاية الخدمة الإماراتية",
        "about.description": "تطبق هذه الحاسبة المادة 132 من قانون العمل الإماراتي الرسمي لحساب مكافأة نهاية الخدمة.",
        "about.formula.title": "صيغة الحساب",
        "about.formula.description": "المكافأة = (الراتب الشهري ÷ 30) × الأيام المستحقة",
        "about.rules.title": "قواعد الحساب",
        "about.rules.firstFive": "أول 5 سنوات: 21 يوم لكل سنة",
        "about.rules.afterFive": "بعد 5 سنوات: 30 يوم لكل سنة",
        "about.rules.minimum": "الحد الأدنى للخدمة: سنة واحدة (365 يوم)",
        "about.penalties.title": "عقوبات الاستقالة (العقود غير المحددة فقط)",
        "about.penalties.lessThanOne": "أقل من سنة: لا مكافأة",
        "about.penalties.oneToThree": "1-3 سنوات: ثلث المكافأة المحسوبة",
        "about.penalties.threeToFive": "3-5 سنوات: ثلثا المكافأة المحسوبة",
        "about.penalties.fiveOrMore": "5 سنوات أو أكثر: المكافأة كاملة",
        
        // Footer
        "footer.rights": "جميع الحقوق محفوظة",
        "footer.disclaimer": "هذه الحاسبة لأغراض إعلامية فقط. استشر المهنيين القانونيين للحسابات الرسمية.",
        "footer.madeWith": "صُنع بـ",
        "footer.forEmployees": "لموظفي دولة الإمارات"
    ]
}
