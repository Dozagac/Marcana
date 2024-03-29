//
//  ProfileView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 28/01/2023.
//

import Firebase
import MessageUI
import SwiftUI

struct SettingsView: View {
    @State var isPresentingConfirm = false
    var userDataManager = UserDataManager()
    @AppStorage(wrappedValue: false, DefaultKeys.loginStatus) var loginStatus
    @AppStorage(wrappedValue: true, DefaultKeys.doUserInfoFlow) var doUserInfoFlow

    @State private var mailSubject: String? = nil
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingMailView = false

    @State private var showingAccountSettings = false
    @StateObject var userSubscriptionManager = UserSubscriptionManager.shared

    @State private var isNotificationEnabled = false

    var body: some View {
        ZStack(alignment: .top) {
            ImageBackgroundView(imageName: "Vine3")
            List {
                // MARK: - Reminder Notifications
                Section(header: Text("Notifications").font(.customFontFootnote).foregroundColor(.secondary)) {

                    if !isNotificationEnabled {
                        Button {
                            if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                                UIApplication.shared.open(appSettings)
                            }
                        } label: {
                            HStack {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .modifier(SettingButtonIconModifier())

                                Text("Need notification permissions")
                            }
                                .foregroundColor(.orange)
                        }
                            .padding(.vertical, UIValues.listElementVerticalPadding)
                    }

                    HStack {
                        Image(systemName: "bubble.left.fill")
                            .modifier(SettingButtonIconModifier())

                        Text("Daily Reminder Time:")

                        Spacer()
                        ReminderTimePickerView()
                    }
                        .padding(.vertical, UIValues.listElementVerticalPadding)
                }
                    .listRowBackground(UIValues.listRowBackroundColor)
                    .onAppear {
                    UNUserNotificationCenter.current().getNotificationSettings { settings in
                        DispatchQueue.main.async {
                            self.isNotificationEnabled = settings.authorizationStatus == .authorized
                        }
                    }
                }

                // MARK: - Contact
                Section(header: Text("Contact Us").font(.customFontFootnote).foregroundColor(.secondary)) {
                    // MARK: - Mail us
                    Button {
                        mailSubject = "Hello"
                        isShowingMailView = true
                    } label: {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .modifier(SettingButtonIconModifier())
                            VStack(alignment: .leading) {
                                Text("Send us an email")
                                Text(verbatim: "contact@marcana.app")
                                    .font(.customFontCaption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                        .padding(.vertical, UIValues.listElementVerticalPadding)

                    // MARK: - Report a Bug
                    Button {
                        mailSubject = "Report a bug"
                        isShowingMailView = true
                    } label: {
                        HStack {
                            Image(systemName: "ladybug.fill")
                                .modifier(SettingButtonIconModifier())
                            VStack(alignment: .leading) {
                                Text("Report a bug")
                                Text(verbatim: "contact@marcana.app")
                                    .font(.customFontCaption)
                                    .foregroundColor(.secondary)
                            }
                        }

                    }
                        .padding(.vertical, UIValues.listElementVerticalPadding)

                }
                    .listRowBackground(UIValues.listRowBackroundColor)
                    .sheet(item: $mailSubject) { subject in
                    MailView(result: self.$mailResult, subject: subject)
                        .font(.body) // mail screen uses regular sf font
                }

// MARK: - DISABLED UNTIL LOGIN IS ENABLED
                Section(header: Text("Account").font(.customFontFootnote).foregroundColor(.secondary)) {

                    Button {
                        // restore purchase action
                        userSubscriptionManager.restorePurchases()
                    } label: {
                        HStack {
                            Image(systemName: "gearshape.arrow.triangle.2.circlepath")
                                .modifier(SettingButtonIconModifier())
                            VStack(alignment: .leading) {
                                Text("Restore Purchase")
                                Text(verbatim: "Re-claim an existing subscription")
                                    .font(.customFontCaption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    // Restore Confirmed
                    .alert(isPresented: $userSubscriptionManager.showingConfirmation) {
                        Alert(title: Text("Purcase Restored!"), message: Text("You continue your premium access."), dismissButton: .default(Text("OK")) {
                            userSubscriptionManager.showingConfirmation = false
                        })
                    }
                    // Restore Purchase Error
                    .alert(isPresented: $userSubscriptionManager.showingError) {
                        Alert(title: Text(userSubscriptionManager.errorTitle), message: Text(userSubscriptionManager.errorMessage), dismissButton: .default(Text("OK")) {
                            userSubscriptionManager.showingError = false
                        })
                    }
//
//                        //MARK: - Account Settings
//                        NavigationLink() {
//                            AccountSettingsView(selectedTab: $selectedTab, UIValues.listElementVerticalPadding)
//                        } label: {
//                            HStack {
//                                Image(systemName: "person")
//                                    .modifier(SettingButtonIconModifier())
//                                Text("Account Settings")
//                            }
//                                .padding(.vertical, UIValues.listElementVerticalPadding)
//                                .foregroundColor(.white)
//                        }
//
//                        //MARK: - Logout button
//                        Button() {
//                            // Log out
//                            DispatchQueue.global(qos: .background).async {
//                                try? Auth.auth().signOut()
//                            }
//                            // Set the view back to login
//                            withAnimation(.easeInOut) {
//                                isPresentingConfirm = true
//                            }
//                        } label: {
//                            HStack {
//                                Image(systemName: "delete.left.fill")
//                                    .modifier(SettingButtonIconModifier())
//                                Text("Log Out")
//                            }
//                                .padding(.vertical, UIValues.listElementVerticalPadding)
//                                .foregroundColor(.red)
//                        }
//                            .confirmationDialog("Are you sure you want to log out?",
//                                                isPresented: $isPresentingConfirm) {
//                            Button("Log Out?", role: .destructive) {
//                                loginStatus = false
//                                selectedTab = 0
//                            }
//                        } message: {
//                            Text("Are you sure you want to log out?")
//                        }
                }
                    .listRowBackground(UIValues.listRowBackroundColor)
            }

                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
        }
            .onAppear {
            AnalyticsManager.shared.logEvent(eventName: AnalyticsKeys.settingsPageview)
        }

            .font(.customFontBody) // font for all the text in this view unless overwritten at child view
        .modifier(customNavBackModifier())
            .foregroundColor(.text)
            .navigationTitle("Settings")
    }
}

//MARK: Custom modifier for the continue navigation button
struct SettingButtonIconModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .frame(width: 32, height: 24)
//            .background(.ultraThinMaterial)
        .cornerRadius(8)
            .padding(.trailing, 8)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
                .preferredColorScheme(.dark)
        }
    }
}
