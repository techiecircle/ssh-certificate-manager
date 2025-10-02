import SwiftUI

struct MarketplaceView: View {
    @EnvironmentObject var api: APIService

    var body: some View {
        NavigationView {
            List {
                ForEach(api.products) { product in
                    HStack {
                        Image(systemName: "bag")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(.trailing, 10)

                        VStack(alignment: .leading) {
                            Text(product.name)
                                .font(.headline)
                            Text("$\(product.price, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        Button {
                            api.addToCart(product: product)
                        } label: {
                            Image(systemName: "cart.badge.plus")
                                .font(.title2)
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
            .navigationTitle("Marketplace")
            .toolbar {
                NavigationLink(destination: CartView()) {
                    HStack {
                        Image(systemName: "cart")
                        Text("\(api.cart.count)")
                    }
                }
            }
            .onAppear {
                api.fetchDummyProducts()
            }
        }
    }
}
