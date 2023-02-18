import SwiftUI
import RevenueCat

struct RevCatTestingView: View {
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



struct RevCatTestingView_Previews: PreviewProvider {
    static var previews: some View {
        RevCatTestingView()
    }
}
