import SwiftUI

struct ContentView: View {
    @StateObject var api = APIService()

    var body: some View {
        if api.isLoggedIn {
            MarketplaceView()
                .environmentObject(api)
        } else {
            AuthView()
                .environmentObject(api)
        }
    }
}
