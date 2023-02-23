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

    // offerings hold each of the packages that we are presenting to the user
    private(set) var offering: Offering? = UserSubscriptionManager.shared.offerings?.current

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

                    Image("ExtendedHeadFortuneTellerWoman")
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

                    Spacer()

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
                            Text("Personal Tarot Wisdom")
                                .font(.customFontBody)
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "checkmark")
                                .font(.body.bold())
                                .foregroundColor(.green)
                            Text("Most personal readings of any app out there. Try for yourself.")
                                .font(.customFontBody)

                        }
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.text)
                    }
                        .padding(.horizontal, UIValues.bigButtonHPadding)

                    Spacer()

                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(offering?.availablePackages ?? []) { package in
                            // MARK: - Pricing Box
                            PackageCellView(package: package, selectedPackage: $selectedPackage)
                            // A package is pre-selected with onAppear
                            .onAppear {
                                selectedPackage = package
                            }
                        }

                    }
                        .padding(.horizontal, UIValues.bigButtonHPadding)

                    Spacer()

                    // MARK: - Trial Start Button
                    VStack {
                        PurchaseButton(selectedPackage: selectedPackage)

                        // Assurance text
                        Text("Payment billed at trial end. Cancel anytime.")
                            .foregroundColor(.secondary)
                            .font(.customFontCaption)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
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

                        Button("Terms & Conditions") {
                            // restore purchase action
                            guard let url = URL(string: "https://www.marcana.app/terms-of-use") else { return }
                            UIApplication.shared.open(url)
                        }
                            .foregroundColor(.secondary)
                            .font(.customFontCaption)

                        Button("Privacy") {
                            // restore purchase action
                            guard let url = URL(string: "https://www.marcana.app/privacy-policy") else { return }
                            UIApplication.shared.open(url)
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
            VStack(alignment: .leading) {
                Text(periodName(for: package))
                    .font(.customFontTitle3)
                    .fontWeight(.black)
                VStack{
                    Text("\(package.storeProduct.localizedPriceString)") +
                    Text("/\(PricePoint.yearly.denominator),")
                    Text("cancel anytime")
                }
                .font(.customFontCaption)
            }
                .frame(width: 300, height: 125)
                .cornerRadius(12)
                .foregroundColor(.text)
                .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedPackage == package ? Color.green : Color.gray, lineWidth: selectedPackage == package ? 2 : 0.3)
            )
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

enum PricePoint {
    case weekly, monthly, yearly

    var denominator: String {
        switch self {
        case .weekly:
            return "week"
        case .monthly:
            return "month"
        case .yearly:
            return "year"
        }
    }

    var freeDays: Int {
        switch self {
        case .weekly:
            return 3
        case .monthly:
            return 3
        case .yearly:
            return 3
        }
    }
}


struct PurchaseButton: View {
    let selectedPackage: Package?
    var body: some View {
        Button {
            guard let selectedPackage = selectedPackage else { return }
            // puchase action
            Purchases.shared.purchase(package: selectedPackage) { (transaction, customerInfo, error, userCancelled) in
                if UserSubscriptionManager.shared.customerInfo?.entitlements[RevCatConstants.entitlementID]?.isActive == true {
                    // Unlock that great "pro" content
                }
            }
//            dismissPaywall()
        }
        label: {
            Text("Start Free Trial") // Try Free & Subscribe
                .font(.customFontBody)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.black)
                .background(.white)
                .cornerRadius(50)
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
