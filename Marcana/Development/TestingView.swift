import SwiftUI
import RevenueCat

struct TestingView: View {
    @State private var packages: [Package] = []
    
    var body: some View {
        VStack {
            ForEach(packages) { package in
                Text(package.localizedPriceString)
                    .padding()
            }
            
            Button("Check Packages") {
                self.checkPackages()
            }
        }
    }
    
    func checkPackages() {
        Purchases.shared.getOfferings { (offerings, error) in
            if let packages = offerings?.current?.availablePackages {
                self.packages = packages
            } else {
                self.packages = []
            }
        }
    }
}



struct TestingView_Previews: PreviewProvider {
    static var previews: some View {
        TestingView()
    }
}
