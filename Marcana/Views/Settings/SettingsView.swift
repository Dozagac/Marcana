//
//  ProfileView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 28/01/2023.
//

import SwiftUI
import Firebase

struct SettingsView: View {
    @State var launchOnboarding = false
    @State var isPresentingConfirm = false
    @AppStorage(wrappedValue: false, "doOnboarding") var doOnboarding // for development
    @AppStorage(wrappedValue: false, "loginStatus") var loginStatus // for development

    @AppStorage(wrappedValue: "", "userName") var userName
    @AppStorage(wrappedValue: "", "userGender") var userGender
    @AppStorage(wrappedValue: 0.0, "userBirthday") var userBirthday
    @AppStorage(wrappedValue: "", "userOccupation") var userOccupation
    @AppStorage(wrappedValue: "", "userRelationship") var userRelationship

    init() {
        UITableView.appearance().backgroundColor = UIColor(.red)
    }

    let elementVerticalPadding : CGFloat = 8
    
    //MARK: Custom modifier for the continue navigation button
    struct SettingButtonModifier: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(.title3)
                .frame(width: 32, height: 32)
                .background(.ultraThinMaterial)
                .cornerRadius(8)
                .padding(.trailing, 8)
        }
    }
    
    
    var body: some View {
        ZStack {
            BackgroundView()

            VStack {
                List {
                    Section(header: Text("User Info")) {
                        //MARK: - Name
                        NavigationLink {
                            GetUserNameView(onboardingStage: .constant(99)) // 99 is chosen to set button functionality, see the view
                        } label: {
                            HStack {
                                Image(systemName: "pencil.line")
                                    .modifier(SettingButtonModifier())
                                Text("Name").frame(width: 100, alignment: .leading)
                                    .foregroundColor(.gray)
                                Text(userName)
                            }
                            .padding(.vertical, elementVerticalPadding)
                        }
                        //MARK: - Gender
                        NavigationLink {
                            GetUserGenderView(onboardingStage: .constant(99)) // 99 is chosen to set button functionality, see the view
                        } label: {
                            HStack {
                                Image(systemName: "person.fill")
                                    .modifier(SettingButtonModifier())
                                
                                Text("Gender").frame(width: 100, alignment: .leading)
                                    .foregroundColor(.gray)
                                Text(userGender)
                            }
                            .padding(.vertical, elementVerticalPadding)
                        }
                        //MARK: - Birthday
                        NavigationLink {
                            GetUserBirthdayView(onboardingStage: .constant(99)) // 99 is chosen to set button functionality, see the view
                        } label: {
                            HStack {
                                Image(systemName: "birthday.cake.fill")
                                    .modifier(SettingButtonModifier())
                                Text("Birthday").frame(width: 100, alignment: .leading)
                                    .foregroundColor(.gray)
                                Text(Date(timeIntervalSince1970: userBirthday).formatted(date: .abbreviated, time: .omitted))
                            }
                            .padding(.vertical, elementVerticalPadding)
                        }
                        //MARK: - Occupation
                        NavigationLink {
                            GetUserOccupationView(onboardingStage: .constant(99)) // 99 is chosen to set button functionality, see the view
                        } label: {
                            HStack {
                                Image(systemName: "briefcase.fill")
                                    .modifier(SettingButtonModifier())
                                Text("Occupation").frame(width: 100, alignment: .leading)
                                    .foregroundColor(.gray)
                                Text(userOccupation)
                            }
                            .padding(.vertical, elementVerticalPadding)
                        }
                        //MARK: - Relationship
                        NavigationLink {
                            GetUserRelationshipView(onboardingStage: .constant(99)) // 99 is chosen to set button functionality, see the view
                        } label: {
                            HStack {
                                Image(systemName: "heart.circle")
                                    .modifier(SettingButtonModifier())
                                Text("Relationship").frame(width: 100, alignment: .leading)
                                    .foregroundColor(.gray)
                                Text(userRelationship)
                            }
                        }
                        .padding(.vertical, elementVerticalPadding)
                    }
                    
                    Section(header: Text("Explore Cards")) {
                        NavigationLink{
                            DeckInfoView()
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.portrait.inset.filled")
                                    .modifier(SettingButtonModifier())
                                Text("Explore Tarot Deck").frame(alignment: .leading)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, elementVerticalPadding)
                    }

                    Section {
                        //MARK: - Development , re-launch onboarding
                        Button() {
                            doOnboarding = true
                        } label: {
                            HStack{
                                Image(systemName: "arrow.counterclockwise.circle")
                                    .modifier(SettingButtonModifier())
                                Text("Re-Launch Onboarding")
                            }
                            .padding(.vertical, elementVerticalPadding)
                        }

                        //MARK: - logout test button
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
                                Image(systemName: "delete.left")
                                    .modifier(SettingButtonModifier())
                                Text("Log Out")
                            }
                            .padding(.vertical, elementVerticalPadding)
                                .foregroundColor(.red)
                        }
                            .confirmationDialog("Are you sure you want to log out?",
                                                isPresented: $isPresentingConfirm) {
                            Button("Log Out?", role: .destructive) {
                                loginStatus = false
                            }
                        } message: {
                            Text("Are you sure you want to log out?")
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
            .navigationTitle("Profile")
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
                .preferredColorScheme(.dark)
        }
    }
}
