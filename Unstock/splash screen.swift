import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

enum SplashDesign {
    static let cream = Color(hex: "FEFAF3")
    static let logoWidthRatio: CGFloat = 0.58   // 230 / 393
}

struct SplashView: View {
    @State private var logoVisible = false
    @State private var goHome = false

    var body: some View {
        ZStack {
            if goHome {
                HomeView()
                    .transition(.opacity)
            } else {
                splashContent
                    .transition(.opacity)
            }
        }
        .task {
            try? await Task.sleep(nanoseconds: 2_500_000_000) // 2.5 ثانية
            withAnimation(.easeInOut(duration: 0.5)) {
                goHome = true
            }
        }
    }

    private var splashContent: some View {
        GeometryReader { geo in
            ZStack {
                SplashDesign.cream

                // Upper background image
                VStack(spacing: 0) {
                    Image("Upper Background waves")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    Spacer()
                }

                // Lower background image
                VStack(spacing: 0) {
                    Spacer()
                    Image("background Wvaes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                }

                // Logo
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width * SplashDesign.logoWidthRatio)
                    .scaleEffect(logoVisible ? 1 : 0.8)
                    .opacity(logoVisible ? 1 : 0)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                logoVisible = true
            }
        }
    }
}
#Preview {
    SplashView()
}
