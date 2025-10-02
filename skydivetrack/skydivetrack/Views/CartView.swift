import SwiftUI

struct CartView: View {
    @EnvironmentObject var api: APIService

    var body: some View {
        List {
            ForEach(api.cart, id: \.id) { product in
                HStack {
                    Text(product.name)
                    Spacer()
                    Text("$\(product.price, specifier: "%.2f")")
                }
            }
        }
        .navigationTitle("Your Cart")
    }
}
