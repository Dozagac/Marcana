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
    @Binding var selectedTab: Int
    @State var isPresentingConfirm = false
    var userDataManager = UserDataManager()
    @AppStorage(wrappedValue: false, "loginStatus") var loginStatus
    @AppStorage(wrappedValue: true, "doUserInfoFlow") var doUserInfoFlow

    @AppStorage(wrappedValue: "", UserDataManager.UserKeys.userName.rawValue) var userName
    @AppStorage(wrappedValue: "", UserDataManager.UserKeys.userGender.rawValue) var userGender
    @AppStorage(wrappedValue: 0.0, UserDataManager.UserKeys.userBirthday.rawValue) var userBirthday
    @AppStorage(wrappedValue: "", UserDataManager.UserKeys.userOccupation.rawValue) var userOccupation
    @AppStorage(wrappedValue: "", UserDataManager.UserKeys.userRelationship.rawValue) var userRelationship

    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingMailView = false

    @State private var showingAccountSettings = false

    let elementVerticalPadding: CGFloat = 8
    var body: some View {
        ZStack {
            BackgroundView()
            List {
                Section(header: Text("User Info").font(.customFontFootnote).foregroundColor(.secondary)) {
                    //MARK: - Name
                    NavigationLink {
                        GetUserNameView(getUserInfoStep: .constant(99)) // 99 is chosen to set button functionality, see the view
                    } label: {
                        HStack {
                            Image(systemName: "pencil.line")
                                .modifier(SettingButtonIconModifier ())
                            Text("Name").frame(width: 100, alignment: .leading)
                                .foregroundColor(.gray)
                            Text(userName)
                        }
                            .padding(.vertical, elementVerticalPadding)
                    }
                    //MARK: - Gender
                    NavigationLink {
                        GetUserGenderView(getUserInfoStep: .constant(99)) // 99 is chosen to set button functionality, see the view
                    } label: {
                        HStack {
                            Image(systemName: "person.fill")
                                .modifier(SettingButtonIconModifier())

                            Text("Gender").frame(width: 100, alignment: .leading)
                                .foregroundColor(.gray)
                            Text(userGender)
                        }
                            .padding(.vertical, elementVerticalPadding)
                    }
                    //MARK: - Birthday
                    NavigationLink {
                        GetUserBirthdayView(getUserInfoStep: .constant(99)) // 99 is chosen to set button functionality, see the view
                    } label: {
                        HStack {
                            Image(systemName: "birthday.cake.fill")
                                .modifier(SettingButtonIconModifier())
                            Text("Birthday").frame(width: 100, alignment: .leading)
                                .foregroundColor(.gray)
                            Text(Date(timeIntervalSince1970: userBirthday).formatted(date: .abbreviated, time: .omitted))
                        }
                            .padding(.vertical, elementVerticalPadding)
                    }
                    //MARK: - Occupation
                    NavigationLink {
                        GetUserOccupationView(getUserInfoStep: .constant(99)) // 99 is chosen to set button functionality, see the view
                    } label: {
                        HStack {
                            Image(systemName: "briefcase.fill")
                                .modifier(SettingButtonIconModifier())
                            Text("Occupation").frame(width: 100, alignment: .leading)
                                .foregroundColor(.gray)
                            Text(userOccupation)
                        }
                            .padding(.vertical, elementVerticalPadding)
                    }


                    //MARK: - Relationship
                    NavigationLink {
                        GetUserRelationshipView(getUserInfoStep: .constant(99)) // 99 is chosen to set button functionality, see the view
                    } label: {
                        HStack {
                            Image(systemName: "heart.circle")
                                .modifier(SettingButtonIconModifier())
                            Text("Relationship").frame(width: 100, alignment: .leading)
                                .foregroundColor(.gray)
                            Text(userRelationship)
                        }
                    }
                        .padding(.vertical, elementVerticalPadding)

                    //MARK: - Reset User Info
                    Button() {
                        UserDefaults.standard.resetUser()
                        doUserInfoFlow = true
                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .modifier(SettingButtonIconModifier())
                            VStack(alignment: .leading) {
                                Text("Reset User Info")
                                Text("Re-enter all user data above")
                                    .font(.customFontCaption)
                            }
                        }
                            .foregroundColor(.cyan)
                            .padding(.vertical, elementVerticalPadding)
                    }
                }


                // MARK: - Explore Deck
                Section(header: Text("Explore Cards").font(.customFontFootnote).foregroundColor(.secondary)) {
                    NavigationLink {
                        DeckInfoView()
                    } label: {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .modifier(SettingButtonIconModifier())

                            Text("Explore Tarot Deck").frame(alignment: .leading)
                                .foregroundColor(.text)
                        }
                    }
                        .foregroundColor(.text)
                        .padding(.vertical, elementVerticalPadding)
                }

                // MARK: - Contact
                Section(header: Text("Contact Us").font(.customFontFootnote).foregroundColor(.secondary)) {
                    // MARK: - Mail us
                    Button {
                        isShowingMailView = true
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.inset.filled")
                                .modifier(SettingButtonIconModifier())
                            VStack(alignment: .leading) {
                                Text("Send us an email")
                                Text(verbatim: "contact@mantra.app")
                                    .font(.customFontCaption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                        .padding(.vertical, elementVerticalPadding)
                        .sheet(isPresented: $isShowingMailView) {
                            MailView(result: self.$mailResult)
                                .font(.body) // mail screen uses regular sf font
                        }
                    
                    // MARK: - Report a Bug
                    Button {
                        isShowingMailView = true
                    } label: {
                        HStack {
                            Image(systemName: "ladybug.fill")
                                .modifier(SettingButtonIconModifier())
                            VStack(alignment: .leading) {
                                Text("Report a bug")
                                Text(verbatim: "contact@mantra.app")
                                    .font(.customFontCaption)
                                    .foregroundColor(.secondary)
                            }
                        }

                    }
                        .padding(.vertical, elementVerticalPadding)
                        .sheet(isPresented: $isShowingMailView) {
                            MailView(result: self.$mailResult, subject: "Reporting a Bug")
                                .font(.body) // mail screen uses regular sf font
                        }
                }


                Section(header: Text("Account").font(.customFontFootnote).foregroundColor(.secondary)) {

                    //MARK: - Account Settings
                    NavigationLink() {
                        AccountSettingsView(selectedTab: $selectedTab, elementVerticalPadding: elementVerticalPadding)
                    } label: {
                        HStack {
                            Image(systemName: "person")
                                .modifier(SettingButtonIconModifier())
                            Text("Account Settings")
                        }
                            .padding(.vertical, elementVerticalPadding)
                            .foregroundColor(.white)
                    }

                    //MARK: - Logout button
                    Button() {
                        // Log out
                        DispatchQueue.global(qos: .background).async {
                            try? Auth.auth().signOut()
                        }
                        // Set the view back to login
                        withAnimation(.easeInOut) {
                            isPresentingConfirm = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: "delete.left.fill")
                                .modifier(SettingButtonIconModifier())
                            Text("Log Out")
                        }
                            .padding(.vertical, elementVerticalPadding)
                            .foregroundColor(.red)
                    }
                        .confirmationDialog("Are you sure you want to log out?",
                                            isPresented: $isPresentingConfirm) {
                        Button("Log Out?", role: .destructive) {
                            loginStatus = false
                            selectedTab = 0
                        }
                    } message: {
                        Text("Are you sure you want to log out?")
                    }
                }
            }
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
        }
            .font(.customFontBody)
            .foregroundColor(.text)
            .navigationTitle("Settings")
    }
}

//MARK: Custom modifier for the continue navigation button
struct SettingButtonIconModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .frame(width: 32, height: 32)
            .background(.ultraThinMaterial)
            .cornerRadius(8)
            .padding(.trailing, 8)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(selectedTab: .constant(2))
                .preferredColorScheme(.dark)
        }
    }
}
