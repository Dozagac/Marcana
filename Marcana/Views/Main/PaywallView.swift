//
//  PayWallView.swift
//  Marcana
//
//  Created by Deniz Ozagac on 05/02/2023.
//

import SwiftUI

struct PaywallView: View {
    @AppStorage(wrappedValue: true, "doOnboarding") var doOnboarding
    @Binding var showingPaywall: Bool
    @State private var animatingViews = false

    private let monthlyPrice = 9.99
    var VPadding: CGFloat = 24
    var currencyCode = "EUR"
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
                        .padding(.horizontal, VPadding)

                    Spacer()


                    // MARK: - Pricing Box
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(monthlyPrice, format: .currency(code: currencyCode))/month, cancel anytime")
                            .font(.customFontBody)
                        Text("First 7 days free")
                            .font(.customFontFootnote)
                    }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.text)
                        .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.green, lineWidth: 2)
                    )
                        .padding(.horizontal, VPadding)


                    Spacer()

                    // MARK: - Trial Start Button
                    VStack {
                        Button {
                            dismissPaywall()
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
                                .padding(.horizontal, VPadding)
                        }

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
                        }
                            .foregroundColor(.secondary)
                            .font(.customFontCaption)

                        Button("Terms & Conditions") {
                            // restore purchase action
                        }
                            .foregroundColor(.secondary)
                            .font(.customFontCaption)

                        Button("Privacy") {
                            // restore purchase action
                        }
                            .foregroundColor(.secondary)
                            .font(.customFontCaption)
                    }
                        .padding(.bottom, 12)

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

struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView(showingPaywall: .constant(false))
            .preferredColorScheme(.dark)
    }
}
