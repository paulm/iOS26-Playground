import SwiftUI

struct ContentView_Showcase: View {
    @State private var selectedTab = "home"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: "home") {
                HomeView()
            }
            
            Tab("Search", systemImage: "magnifyingglass", value: "search", role: .search) {
                SearchView()
            }
            
            Tab("Profile", systemImage: "person.crop.circle.fill", value: "profile") {
                ProfileView()
            }
            
            Tab("Settings", systemImage: "gearshape.fill", value: "settings") {
                SettingsView()
            }
        }
        .tint(.blue)
    }
}

#Preview {
    ContentView_Showcase()
}