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
    static let mint  = Color(hex: "D6EBD6")
    static let sky   = Color(hex: "D1E6F2")
    static let sand  = Color(hex: "F2E8BF")
    static let cream = Color(hex: "FEFAF3")

    static let logoWidthRatio: CGFloat = 0.58   // 230 / 393
    static let topFraction: CGFloat = 0.15
    static let bottomFraction: CGFloat = 0.11
    static let amplitudeRatio: CGFloat = 0.046  // 18 / 393
    static let waves: CGFloat = 1.5
}

struct WavyBand: Shape {
    var topFraction: CGFloat
    var bottomFraction: CGFloat
    var amplitude: CGFloat
    var waves: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let top = rect.height * topFraction
        let bottom = rect.height * (1 - bottomFraction)

        path.move(to: CGPoint(x: rect.minX, y: top))
        for x in stride(from: rect.minX, through: rect.maxX, by: 2) {
            let progress = x / rect.width
            let y = top + sin(progress * .pi * 2 * waves) * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: rect.maxX, y: bottom))
        for x in stride(from: rect.maxX, through: rect.minX, by: -2) {
            let progress = x / rect.width
            let y = bottom + sin(progress * .pi * 2 * waves + .pi) * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.closeSubpath()
        return path
    }
}

struct SplashView: View {
    @State private var logoVisible = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    colors: [SplashDesign.mint, SplashDesign.sky, SplashDesign.sand],
                    startPoint: .leading,
                    endPoint: .trailing
                )

                WavyBand(
                    topFraction: SplashDesign.topFraction,
                    bottomFraction: SplashDesign.bottomFraction,
                    amplitude: geo.size.width * SplashDesign.amplitudeRatio,
                    waves: SplashDesign.waves
                )
                .fill(SplashDesign.cream)

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
