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
    @AppStorage(wrappedValue: true, "doOnboarding") var doOnboarding
    @Binding var showingPaywall: Bool
    @State private var animatingViews = false

    // offerings hold each of the packages that we are presenting to the user
    private(set) var offering: Offering? = UserSubscriptionManager.shared.offerings?.current

    @State var selectedPackage: Package?

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
                            UserSubscriptionManager.shared.restorePurchases()
                        }
                            .foregroundColor(.secondary)
                            .font(.customFontCaption)

                        Button("Terms & Conditions") {
                            // restore purchase action
                            guard let url = URL(string: "https://www.marcana.app/privacy-policy") else { return }
                            UIApplication.shared.open(url)
                        }
                            .foregroundColor(.secondary)
                            .font(.customFontCaption)

                        Button("Privacy") {
                            // restore purchase action
                            guard let url = URL(string: "https://www.marcana.app/terms-of-use") else { return }
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
            .onAppear {
            animatingViews = true
        }
    }

    func dismissPaywall() {
        showingPaywall = false
        doOnboarding = false
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
                Text("\(package.storeProduct.localizedPriceString)/\(PricePoint.yearly.denominator), cancel anytime ")
                    .font(.customFontBody)

                Text("First \(PricePoint.yearly.freeDays) days free") // TODO this should come from revenuecat
                .font(.customFontCallout)
            }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.text)
                .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedPackage == package ? Color.green : Color.gray, lineWidth: 2)
            )
        }
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

struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView(showingPaywall: .constant(false))
            .preferredColorScheme(.dark)
    }
}



struct PurchaseButton: View {
    let selectedPackage: Package?
    var body: some View {
        Button {
            guard let selectedPackage = selectedPackage else { return }
            // puchase action
            Purchases.shared.purchase(package: selectedPackage) { (transaction, customerInfo, error, userCancelled) in
                if UserSubscriptionManager.shared.customerInfo?.entitlements[Constants.entitlementID]?.isActive == true {
                    // Unlock that great "pro" content
                }
            }
//            dismissPaywall()
        }
        label: {
            Text("Try Free & Subscribe")
                .font(.customFontBody)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.black)
                .background(.white)
                .cornerRadius(50)
                .padding(.horizontal, UIValues.bigButtonHPadding)
        }
    }
}
