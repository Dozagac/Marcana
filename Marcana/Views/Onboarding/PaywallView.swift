//
//  PayWallView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 05/02/2023.
// See RevenueCat Documentation: https://www.revenuecat.com/docs/making-purchases

import SwiftUI
import RevenueCat
import Shimmer

struct PaywallView: View {
    @AppStorage(wrappedValue: true, DefaultKeys.doOnboarding) var doOnboarding
    @State private var animatingViews = false
    @Environment(\.dismiss) var dismiss

    @State var selectedPackage: Package?

    @StateObject var userSubscriptionManager = UserSubscriptionManager.shared

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                BackgroundView()

                // MARK: - X button
                HStack {
                    Button {
                        dismissPaywall()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3.bold())
                            .foregroundColor(.text)
                            .opacity(animatingViews ? 1 : 0)
                    }

                    Spacer()

                }
                    .animation(.default.delay(2.5), value: animatingViews)
                    .padding([.leading, .top], 20)
                    .zIndex(2)

                VStack(spacing: 0) {
                    // MARK: - Fortune Teller Image

                    Image("FortuneTellerWoman")
                        .resizable()
                        .scaledToFit()
                        .frame(width: proxy.size.width)
                        .mask(LinearGradient(
                        gradient: Gradient(stops: [
                                .init(color: .clear, location: 0.02),
                                .init(color: Color.marcanaBackground, location: 0.3)
                        ]),
                        startPoint: .bottom,
                        endPoint: .top
                    ))
                        .mask(LinearGradient(
                        gradient: Gradient(stops: [
                                .init(color: Color.marcanaBackground, location: 0.8),
                                .init(color: .clear, location: 1) // notc cover
                        ]),
                        startPoint: .bottom,
                        endPoint: .top
                    ))

//                    Spacer()

                    // MARK: - Bullet points
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "checkmark")
                                .font(.body.bold())
                                .foregroundColor(.green)
                            Text("Unlimited Fortune Readings")
                                .font(.customFontBody)
                        }
                        HStack {
                            Image(systemName: "checkmark")
                                .font(.body.bold())
                                .foregroundColor(.green)
                            Text("Personally created Tarot Wisdom")
                                .font(.customFontBody)
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "checkmark")
                                .font(.body.bold())
                                .foregroundColor(.green)
                            Text("Most personal tarot readings of any app! Try for yourself.")
                                .font(.customFontBody)

                        }
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.text)
                    }
                        .padding(.horizontal, UIValues.bigButtonHPadding)

                    Spacer()
                    Spacer()

                    HStack(spacing: 10) {
                        // offerings hold each of the packages that we are presenting to the user
                        if let offering = userSubscriptionManager.offerings?.current {
                            ForEach(offering.availablePackages) { package in
                                // MARK: - Pricing Box
                                PackageCellView(package: package, selectedPackage: $selectedPackage)
                                // A package is pre-selected with onAppear
                                .onAppear {
                                    // 1 is weekly package
                                    if package.storeProduct.subscriptionPeriod?.unit.rawValue == 1 {
                                        selectedPackage = package
                                    }
                                }
                            }
                        } else {
                            ProgressView()
                        }
                    }
                        .padding(.horizontal, UIValues.bigButtonHPadding)

                    Spacer()

                    // MARK: - Trial Start Button
                    VStack {
                        // Assurance text
                        Text("Payment billed at trial end. Cancel anytime.")
                            .foregroundColor(.secondary)
                            .font(.customFontCaption)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                        PurchaseButton(selectedPackage: selectedPackage)
                        
                        Text("By tapping above, you agree to the [Terms of Service](https://www.marcana.app/terms-of-use) and [Privacy Policy](https://www.marcana.app/privacy-policy)")
                            .foregroundColor(.secondary)
                            .font(.customFontCaption)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .padding(.horizontal)
                    }
                        .padding(.bottom, 12)

                    // MARK: - Legal Stuff at Bottom
                    HStack(spacing: 24) {
                        Button("Restore Purchase") {
                            // restore purchase action
                            userSubscriptionManager.restorePurchases()
                        }
                            .alert(isPresented: $userSubscriptionManager.showingError) {
                            Alert(title: Text(userSubscriptionManager.errorTitle), message: Text(userSubscriptionManager.errorMessage), dismissButton: .default(Text("OK")) {
                                userSubscriptionManager.showingError = false
                            })
                        }
                            .foregroundColor(.secondary)
                            .font(.customFontCaption)
                    }
                        .padding(.bottom, 16)
                }
                    .ignoresSafeArea(edges: .all)
                    .preferredColorScheme(.dark)
            }
        }
            .navigationBarBackButtonHidden(true)
            .onAppear {
            animatingViews = true
        }
    }

    func dismissPaywall() {
        doOnboarding = false
        dismiss() // so it can dismiss itself when called from anywhere
    }
}

struct PackageCellView: View {
    let package: Package
    @Binding var selectedPackage: Package?

    var body: some View {
        Button {
            selectedPackage = package
        } label: {
            VStack(spacing: 8) {
                Text(periodName(for: package))
                    .font(.customFontBody)
                    .fontWeight(.black)
                VStack() {
                    Text("\(3) ").bold() +
                        Text("days free ").bold() // +
//                        Text("then")
                    Text("\(package.storeProduct.localizedPriceString)").bold() +
                        Text(" / \(periodDenominator(for: package))")
                    Text("Cancel anytime")
                }
                    .lineSpacing(0)
                    .font(.customFontCaption)
            }
                .padding(.horizontal, 4)
                .frame(height: 135)
                .frame(maxWidth: .infinity)
                .cornerRadius(12)
                .foregroundColor(.text)
                .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedPackage == package ? Color.marcanaLightGreen : Color.gray, lineWidth: selectedPackage == package ? 2 : 0.3)
                    .if(periodName(for: package).lowercased() == "weekly") { view in
                    // Show most selected for "weekly" package
                    view.overlay(alignment: .top) {
                        Text("Most Selected").bold()
                            .padding(.vertical, 6)
                            .font(.caption)
//                            .frame(height: 30)
                        .frame(maxWidth: .infinity)
                            .background(Color.marcanaLightGreen)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .offset(y: -10)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .scaleEffect(1.015)
                    }
                }
            )
        }
    }

    func periodDenominator(for package: Package) -> String {
        switch package.storeProduct.subscriptionPeriod!.unit.rawValue {
        case 0:
            return "day"
        case 1:
            return "week"
        case 2:
            return "month"
        case 3:
            return "year"
        default:
            return "unknown period"
        }
    }


    func periodName(for package: Package) -> String {
        switch package.storeProduct.subscriptionPeriod!.unit.rawValue {
        case 0:
            return "Daily"
        case 1:
            return "Weekly"
        case 2:
            return "Monthly"
        case 3:
            return "Annually"
        default:
            return "unknown period"
        }

        // if you inspect .unit in the first line:
        // from the descriotion of Unit in revenuecat code
//        /// A subscription period unit of a day.
//        case day = 0
//        /// A subscription period unit of a week.
//        case week = 1
//        /// A subscription period unit of a month.
//        case month = 2
//        /// A subscription period unit of a year.
//        case year = 3
    }
}


struct PurchaseButton: View {
    @AppStorage(wrappedValue: true, DefaultKeys.doOnboarding) var doOnboarding
    @State private var animatingViews = false
    @Environment(\.dismiss) var dismiss
    @State private var isWaiting = false
    @AppStorage(wrappedValue: "Subscribe", DefaultKeys.paywallButtonText) var paywallButtonText

    let selectedPackage: Package?
    var body: some View {
        Button {
            guard let selectedPackage = selectedPackage else { return }
            // Set the waiting state to true
            isWaiting = true
            // purchase action completion handler
            Purchases.shared.purchase(package: selectedPackage) { (transaction, customerInfo, error, userCancelled) in
                if UserSubscriptionManager.shared.customerInfo?.entitlements[RevCatConstants.entitlementID]?.isActive == true {
                    // Unlock that great "pro" content
                }
                isWaiting = false
                doOnboarding = false
                //            dismiss() // so it can dismiss itself when called from anywhere
            }
        }
        label: {
            Group {
                if isWaiting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(.black)
                } else {
                    Group {
                            Text(paywallButtonText)
                    }
                        .font(.customFontTitle3)
                }
            }
                .modifier(OnboardingContinueButtonModifier(canContinue: true))
                .padding(.horizontal, UIValues.bigButtonHPadding)
        }
    }
}

struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView()
            .preferredColorScheme(.dark)
    }
}
