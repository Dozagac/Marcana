//
//  ContentView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 26/11/2022.
//

// http://www.aquatictarot.de/deck/list_major.html
// https://gist.github.com/ajzeigert/32461d73c17cfd8fd475c0049db451f5

import Firebase
import SwiftUI



struct HomePageView: View {
    @AppStorage(wrappedValue: false, "doOnboarding") var doOnboarding // for development
    @AppStorage(wrappedValue: false, "loginStatus") var loginStatus // for development
    @State var launchOnboarding = false
    @State var isPresentingConfirm = false
    
    let appearance = UINavigationBarAppearance()

    var body: some View {
        ZStack {
            BackgroundView() // this way the Vstack still respects the safe area
            VStack {

                GetFortuneButton(
                    title: "Get Fortune Reading",
                    subtitle: "Ask a question to Aurelion",
                    imageName: "threeReader")

                //MARK: - Development user info button
                VStack(spacing: 8) {
                    Button() {
                        doOnboarding = true
                    } label: {
                        Text("Re-enter info")
                            .padding(8)
                            .background(.cyan)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                        
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
                        Text("Log Out")
                            .padding(8)
                            .background(.red)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                        .padding(12)
                        .confirmationDialog("Are you sure you want to log out?",
                                            isPresented: $isPresentingConfirm) {
                        Button("Log Out?", role: .destructive) {
                            loginStatus = false
                        }
                    } message: {
                        Text("Are you sure you want to log out?")
                    }

                }
                    .padding(12)
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Home")
        }
    }
}


struct GetFortuneButton: View {
    let title: String
    let subtitle: String
    let imageName: String

    var body: some View {
        NavigationLink(destination: GetUserQuestionView(), label: {
            VStack() {
                // MARK: CARD IMAGE
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                VStack(alignment: .leading) {
                    //MARK: CARD TITLE
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .minimumScaleFactor(0.5)
                    //MARK: CARD SUBTITLE
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                    .padding(.horizontal, 8)
                Spacer()
            }
                .frame(width: 300, height: 500)
                .background()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .icon.opacity(0.5), radius: 5)
        })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                HomePageView()
                    .environmentObject(UserOO())
                    .preferredColorScheme(.dark)
            }
        }
    }
}






