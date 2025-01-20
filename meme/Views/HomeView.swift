import SwiftUI

struct HomeView: View {

    init() {
        // Customize the navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 237/255, green: 249/255, blue: 255/255, alpha: 1.0) // Light blue-ish color
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: "Quicksand-Bold", size: 18)!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: "Quicksand-Bold", size: 34)!]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // Print available fonts (for verification)
        for family in UIFont.familyNames {
            print("\(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   \(name)")
            }
        }
    }

    var body: some View {
        VStack {
            Text("Meme Maker")
                .font(.custom("Quicksand-Bold", size: 40))
                .foregroundColor(.black)
                .padding(.top, 40)
                .padding(.bottom, 5)

            Text("Presented by Nocabot")
                .font(.custom("Quicksand-Medium", size: 20))
                .foregroundColor(.black)

            Spacer()

            Image("homeImage")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 40)

            Spacer()

            // Create a Meme Button
            NavigationLink(destination: MemeListView()) {
                Text("Create a Meme")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .font(.custom("Quicksand-Medium", size: 18))
            }
            .padding(.horizontal, 20)

            // Settings Button
            NavigationLink(destination: SettingsView()) {
                            Text("Settings")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black, lineWidth: 1)
                                )
                                .font(.custom("Quicksand-Medium", size: 18))
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
        }
        .background(Color(hex: "edf9ff").edgesIgnoringSafeArea(.all)) // Set background color
    }
}

// Extension to create Color from hex
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
