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

// Cream area with wavy top and bottom edges
struct WavyBand: Shape {
    var topFraction: CGFloat = 0.22
    var bottomFraction: CGFloat = 0.20
    var amplitude: CGFloat = 16
    var waves: CGFloat = 1.5

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
        ZStack {
            // Pastel gradient visible at top and bottom
            LinearGradient(
                colors: [
                    Color(red: 0.84, green: 0.92, blue: 0.84),
                    Color(red: 0.82, green: 0.90, blue: 0.95),
                    Color(red: 0.95, green: 0.91, blue: 0.75)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )

            // Cream center with wavy edges
            WavyBand()
                .fill(Color(hex: "FEFAF3"))

            // Logo
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 260)
                .scaleEffect(logoVisible ? 1 : 0.8)
                .opacity(logoVisible ? 1 : 0)
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
