//
//  ContentView.swift
//  UAE Gratuity Calculator
//
//  Created by Abhisek Mallik on 10/07/2025.
//

import SwiftUI
import Network

struct ContentView: View {
    @StateObject private var appState = AppState()
    @StateObject private var formData = CalculatorFormData()
    @StateObject private var localization = LocalizationManager()
    @StateObject private var apiService = APIService.shared
    @StateObject private var networkMonitor = NetworkMonitor()
    @Environment(\.colorScheme) private var systemColorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemBackground),
                        Color(.systemBackground).opacity(0.8)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Sticky Header
                    HeaderView()
                        .environmentObject(appState)
                        .environmentObject(localization)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        .background(
                            Color(.systemBackground)
                                .opacity(0.95)
                                .blur(radius: 10)
                        )
                        .zIndex(1)
                    
                    // Scrollable Content
                    ScrollView {
                        VStack(spacing: 24) {
                            // Main Calculator Form
                            CalculatorFormView()
                                .environmentObject(appState)
                                .environmentObject(formData)
                                .environmentObject(localization)
                                .id("CalculatorForm-\(appState.configurationData?.terminationTypes.count ?? 0)")
                            
                            // Results Section
                            if let result = formData.calculationResult {
                                ResultsView(result: result)
                                    .environmentObject(localization)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                            
                            // About Section
                            AboutSectionView()
                                .environmentObject(localization)
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                    .refreshable {
                        await refreshConfiguration()
                    }
                }
                .environment(\.layoutDirection, appState.selectedLanguage.isRTL ? .rightToLeft : .leftToRight)
                
                // Configuration Error Toast
                if let configError = appState.configurationError {
                    VStack {
                        ToastView(
                            message: networkMonitor.isConnected ? configError : localization.localizedString(for: "error.noInternet"),
                            actionText: nil,
                            isVisible: .constant(true)
                        )
                        .zIndex(2)
                        Spacer()
                    }
                }
                
                // Calculation Error Toast
                if let calcError = formData.errorMessage {
                    VStack {
                        ToastView(
                            message: calcError,
                            actionText: "Dismiss",
                            isVisible: .constant(true),
                            onAction: {
                                formData.errorMessage = nil
                            }
                        )
                        .zIndex(2)
                        Spacer()
                    }
                }
                
                // Loading overlay
                if appState.isLoadingConfiguration {
                    LoadingOverlay(message: localization.localizedString(for: "loading.configuration"))
                }
                
                // Calculation loading overlay
                if formData.isCalculating {
                    LoadingOverlay(message: localization.localizedString(for: "loading.calculating"))
                }
            }
            .navigationBarHidden(true)
            .preferredColorScheme(appState.isDarkMode ? .dark : .light)
            .onAppear {
                // Set initial color scheme based on system setting
                appState.updateFromSystemColorScheme(systemColorScheme)
                loadConfiguration()
                localization.setLanguage(appState.selectedLanguage)
            }
            .onChange(of: networkMonitor.isConnected) { _, isConnected in
                if isConnected && appState.configurationError != nil {
                    // Auto-retry when network is restored
                    loadConfiguration()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func loadConfiguration() {
        appState.isLoadingConfiguration = true
        appState.configurationError = nil
        
        Task {
            do {
                let config = try await apiService.fetchConfiguration()
                await MainActor.run {
                    appState.configurationData = config
                    appState.isLoadingConfiguration = false
                    // Clear any existing configuration errors on successful load
                    appState.configurationError = nil
                }
            } catch {
                await MainActor.run {
                    appState.configurationError = error.localizedDescription
                    appState.isLoadingConfiguration = false
                }
            }
        }
    }
    
    private func refreshConfiguration() async {
        // Clear existing error before starting refresh
        await MainActor.run {
            appState.configurationError = nil
        }
        
        do {
            let config = try await apiService.fetchConfiguration()
            await MainActor.run {
                // Update configuration data which will trigger form re-render
                appState.configurationData = config
                appState.isLoadingConfiguration = false
                // Ensure error is cleared on successful refresh
                appState.configurationError = nil
            }
        } catch {
            // Only show error if it's not a cancellation
            if !error.localizedDescription.contains("cancelled") && !error.localizedDescription.contains("canceled") {
                await MainActor.run {
                    appState.configurationError = error.localizedDescription
                }
            }
        }
    }
}

// MARK: - Header View
struct HeaderView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                // App Logo and Title
                HStack(spacing: 12) {
                    Image(systemName: "building.2")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.blue)
                        .frame(width: 48, height: 48)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(localization.localizedString(for: "app.title"))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(localization.localizedString(for: "app.subtitle"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
                
                // Controls
                HStack(spacing: 12) {
                    // Dark Mode Toggle
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            appState.isDarkMode.toggle()
                        }
                    }) {
                        Image(systemName: appState.isDarkMode ? "sun.max.fill" : "moon.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.primary)
                            .frame(width: 36, height: 36)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                    
                    // Language Toggle
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            let newLanguage: AppState.Language = appState.selectedLanguage == .english ? .arabic : .english
                            appState.selectedLanguage = newLanguage
                            localization.setLanguage(newLanguage)
                        }
                    }) {
                        Text(appState.selectedLanguage == .english ? "عربي" : "EN")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                            .frame(width: 36, height: 36)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding(.top, 8)
    }
}

// MARK: - Calculator Form View
struct CalculatorFormView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var formData: CalculatorFormData
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        VStack(spacing: 20) {
            // Form Title
            VStack(alignment: .leading, spacing: 8) {
                Text(localization.localizedString(for: "form.title"))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(localization.localizedString(for: "form.description"))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Form Fields
            VStack(spacing: 16) {
                // Basic Salary
                FormFieldView(
                    title: localization.localizedString(for: "form.basicSalary.label"),
                    description: localization.localizedString(for: "form.basicSalary.description")
                ) {
                    TextField(localization.localizedString(for: "form.basicSalary.placeholder"), text: $formData.basicSalary)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(CustomTextFieldStyle())
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    hideKeyboard()
                                }
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.blue)
                            }
                        }
                }
                
                // Termination Type
                if let terminationTypes = appState.configurationData?.terminationTypes {
                    FormFieldView(
                        title: localization.localizedString(for: "form.terminationType.label"),
                        description: localization.localizedString(for: "form.terminationType.description")
                    ) {
                        DropdownSelector(
                            options: terminationTypes,
                            selection: $formData.selectedTerminationType,
                            placeholder: localization.localizedString(for: "form.terminationType.placeholder"),
                            isRTL: appState.selectedLanguage.isRTL
                        )
                    }
                }
                
                // Contract Type
                if let contractTypes = appState.configurationData?.contractTypes {
                    FormFieldView(
                        title: localization.localizedString(for: "form.contractType.label"),
                        description: localization.localizedString(for: "form.contractType.description")
                    ) {
                        ContractTypeSelector(
                            options: contractTypes,
                            selection: $formData.selectedContractType,
                            placeholder: localization.localizedString(for: "form.contractType.placeholder"),
                            isRTL: appState.selectedLanguage.isRTL
                        )
                    }
                }
                VStack(spacing: 20) {
                    // Joining Date
                    FormFieldView(
                        title: localization.localizedString(for: "form.joiningDate.label"),
                        description: localization.localizedString(for: "form.joiningDate.description")
                    ) {
                        DatePicker(
                            "",
                            selection: $formData.joiningDate,
                            in: ...Date(),
                            displayedComponents: .date
                        )
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // Last Working Day
                    FormFieldView(
                        title: localization.localizedString(for: "form.lastWorkingDay.label"),
                        description: localization.localizedString(for: "form.lastWorkingDay.description")
                    ) {
                        DatePicker(
                            "",
                            selection: $formData.lastWorkingDay,
                            in: formData.joiningDate...,
                            displayedComponents: .date
                        )
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            
            // Action Buttons
            VStack(spacing: 12) {
                // Calculate Button
                Button(action: calculateEOSB) {
                    HStack {
                        if formData.isCalculating {
                            ProgressView()
                                .scaleEffect(0.8)
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                        
                        Text(formData.isCalculating ?
                             localization.localizedString(for: "form.calculating") :
                             localization.localizedString(for: "form.calculate"))
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(formData.isFormValid ? Color.blue : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(!formData.isFormValid || formData.isCalculating)
                
                // Clear Button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        formData.reset()
                    }
                }) {
                    Text(localization.localizedString(for: "form.clear"))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color(.systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func calculateEOSB() {
        formData.isCalculating = true
        formData.errorMessage = nil
        
        Task {
            do {
                let employeeData = try EmployeeData(from: formData)
                let result = try await APIService.shared.calculateEOSB(employeeData: employeeData)
                
                await MainActor.run {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        formData.calculationResult = result
                        formData.isCalculating = false
                    }
                }
            } catch {
                await MainActor.run {
                    formData.errorMessage = error.localizedDescription
                    formData.isCalculating = false
                }
            }
        }
    }
}
