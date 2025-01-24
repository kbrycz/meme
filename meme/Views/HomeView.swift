import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    init() {
        // Customize the navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont(name: "Quicksand-Bold", size: 18)!
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont(name: "Quicksand-Bold", size: 34)!
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        ZStack {
            // System background to adapt to Light/Dark mode
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Meme Maker")
                    .font(.custom("Quicksand-Bold", size: 40))
                    .foregroundColor(.primary)
                    .padding(.top, 40)
                    .padding(.bottom, 5)
                
                Text("Presented by Nocabot")
                    .font(.custom("Quicksand-Medium", size: 20))
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Swap out the image in dark mode
                if colorScheme == .dark {
                    Image("homeImage-white")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 40)
                } else {
                    Image("homeImage")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                // Button to navigate to MemeList
                NavigationLink(destination: MemeListView()) {
                    Text("Create a Meme")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.primary)
                        .foregroundColor(Color(UIColor.systemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .font(.custom("Quicksand-Medium", size: 18))
                }
                .padding(.horizontal, 20)
                
                // Settings
                NavigationLink(destination: SettingsView()) {
                    Text("Settings")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.primary)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.primary, lineWidth: 1)
                        )
                        .font(.custom("Quicksand-Medium", size: 18))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
    }
}
