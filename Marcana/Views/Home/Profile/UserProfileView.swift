//
//  UserProfileView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 17/02/2023.
//

import SwiftUI

struct UserProfileView: View {
    var userDataManager = UserDataManager()
    @AppStorage(wrappedValue: false, DefaultKeys.loginStatus) var loginStatus
    @AppStorage(wrappedValue: true, DefaultKeys.doUserInfoFlow) var doUserInfoFlow

    @AppStorage(wrappedValue: "", UserDataManager.UserKeys.userName.rawValue) var userName
    @AppStorage(wrappedValue: "", UserDataManager.UserKeys.userGender.rawValue) var userGender
    @AppStorage(wrappedValue: 0.0, UserDataManager.UserKeys.userBirthday.rawValue) var userBirthday
    @AppStorage(wrappedValue: "", UserDataManager.UserKeys.userOccupation.rawValue) var userOccupation
    @AppStorage(wrappedValue: "", UserDataManager.UserKeys.userRelationship.rawValue) var userRelationship
    
//    @Environment(\.dismiss) var dismiss //
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .top) {
            ImageBackgroundView(imageName: "Vine3")
            List {
                Section(header: Text("User Info").font(.customFontFootnote).foregroundColor(.secondary)) {
                    
                    //MARK: - Reset User Info
                    Button() {
                        UserDefaults.standard.resetUser()
//                        dismiss()
                        doUserInfoFlow = true
                        self.presentationMode.wrappedValue.dismiss()

                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .modifier(SettingButtonIconModifier())
                            VStack(alignment: .leading) {
                                Text("Change User")
                                Text("Re-enter user info")
                                    .font(.customFontCaption)
                            }
                        }
                            .foregroundColor(.text)
                            .padding(.vertical, UIValues.listElementVerticalPadding)
                    }

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
                            .padding(.vertical, UIValues.listElementVerticalPadding)
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
                            .padding(.vertical, UIValues.listElementVerticalPadding)
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
                            .padding(.vertical, UIValues.listElementVerticalPadding)
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
                            .padding(.vertical, UIValues.listElementVerticalPadding)
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
                        .padding(.vertical, UIValues.listElementVerticalPadding)

                }
                    .listRowBackground(UIValues.listRowBackroundColor)

                Section {
                    NavigationLink {
                        FavoriteFortunesView()
                    } label: {
                        HStack {
                            Image(systemName: "heart.fill")
                                .modifier(SettingButtonIconModifier())
                            Text("Your Favorites").frame(alignment: .leading)
                        }
                    }
                        .padding(.vertical, UIValues.listElementVerticalPadding)
                }
                    .listRowBackground(UIValues.listRowBackroundColor)
            }
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
        }
            .font(.customFontBody) // font for all the text in this view unless overwritten at child view
            .modifier(customNavBackModifier())
        .foregroundColor(.text)
            .navigationTitle("Profile")
//            .navigationBarTitleDisplayMode(.large)
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            UserProfileView()
        }
    }
}
