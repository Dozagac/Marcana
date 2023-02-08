//
//  AccountSettingsView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 08/02/2023.
//

import SwiftUI
import Firebase



struct AccountSettingsView: View {
    @Binding var selectedTab: Int
    var elementVerticalPadding: CGFloat
    var fortuneHistory = FortuneHistory() // does this need to be a stateobject? prob not

    @State var errorText: String = ""
    @State private var isPresentingEraseHistoryAlert = false
    @State private var isPresentingDeleteUserAlert = false
    @StateObject var toastManager = ToastManager()
    @AppStorage(wrappedValue: false, "loginStatus") var loginStatus

    var body: some View {
        ZStack {
            BackgroundView()
            List {
                Section {
                    //MARK: - erase data button
                    Button() {
                        isPresentingEraseHistoryAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "eraser.line.dashed.fill")
                                .modifier(SettingButtonIconModifier())
                            VStack(alignment: .leading) {
                                Text("Erase History")
                                Text("Keep the account but remove your history")
                                    .font(.customFontCaption)
                                    .foregroundColor(.secondary)
                            }
                        }
                            .foregroundColor(.white)
                    }
                        .padding(.vertical, elementVerticalPadding)
                        .confirmationDialog("Are you sure you want to erase your history?",
                                            isPresented: $isPresentingEraseHistoryAlert) {
                        Button("Erase?", role: .destructive) {
                            // erase history data
                            fortuneHistory.eraseAllHistory()
                        }
                    } message: {
                        Text("Are you sure you want to erase your history?")
                    }

                    //MARK: - delete account button
                    Button() {
                        isPresentingDeleteUserAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "trash.fill")
                                .modifier(SettingButtonIconModifier())
                            VStack(alignment: .leading) {
                                Text("Delete Account")
                                Text("Delete your account and all the data")
                                    .font(.customFontCaption)
                                    .foregroundColor(.secondary)
                            }
                        }
                            .foregroundColor(.red)
                    }
                        .padding(.vertical, elementVerticalPadding)
                        .confirmationDialog("Are you sure you want to delete your account?",
                                            isPresented: $isPresentingDeleteUserAlert) {
                        Button("Delete?", role: .destructive) {
                            let user = Auth.auth().currentUser
                            // delete account
                            user?.delete { error in
                                // error occured
                                if let error = error {
                                    errorText = error.localizedDescription
                                    toastManager.showingToast = true
                                } else {
                                    // Account deleted.

                                    // delete history
                                    fortuneHistory.eraseAllHistory()

                                    // erase user data
                                    UserDefaults.standard.resetUser()

                                    // Send to login screen
                                    loginStatus = false

                                    // Send to home screen (in the background of login)
                                    selectedTab = 0 }
                            }
                        }
                    } message: {
                        Text("Are you sure you want to delete your account?")
                    }
                }
            }
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
        }
            .font(.customFontBody)
            .simpleToast(isPresented: $toastManager.showingToast,
                         options: toastManager.toastOptions) {
            Text("Error: \(errorText)")
                .foregroundColor(.text)
                .font(.customFontBody)
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
        }
            .navigationTitle("Account Settings")
    }
}


struct AccountSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AccountSettingsView(selectedTab: .constant(2), elementVerticalPadding: 8)
                .preferredColorScheme(.dark)
        }
    }
}
