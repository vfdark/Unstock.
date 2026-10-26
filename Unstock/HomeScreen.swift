import SwiftUI

// Background (wave images)
struct WavyBackground: View {
    var body: some View {
        ZStack {
            Color(red: 0.99, green: 0.98, blue: 0.96)

            VStack(spacing: 0) {
                Image(.upperBackgroundWaves)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 170, alignment: .bottom)
                    .clipped()

                Spacer()

                Image(.backgroundWvaes)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 170, alignment: .top)
                    .clipped()
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Exercise card
struct ExerciseCard: View {
    let icon: Image
    let title: String
    let description: String
    let accent: Color
    let gradient: [Color]

    var body: some View {
        HStack(spacing: 16) {
            icon
                .resizable()
                .scaledToFit()
                .frame(width: 58, height: 58)
                .foregroundStyle(accent)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 22, weight: .semibold))
                Text(description)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(accent)
                .frame(width: 24, height: 24)
                .background(Circle().fill(accent.opacity(0.25)))
        }
        .padding(.leading, 17)
        .padding(.trailing, 20)
        .padding(.vertical, 28)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(LinearGradient(colors: gradient, startPoint: .top, endPoint: .bottom))
        )
        .shadow(color: .black.opacity(0.12), radius: 10, y: 6)
    }
}

// MARK: - Home screen
struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                WavyBackground()

                VStack(alignment: .leading, spacing: 0) {

                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 4) {
                            Text("Welcome")
                                .font(.system(size: 17, weight: .bold))
                                .tracking(1.5)
                            Image(.lightBulb)
                                .foregroundStyle(.orange)
                        }
                        .padding(.leading, 4)

                        Text("Unblock Your\nSpark.")
                            .font(.system(size: 40, weight: .bold))

                        Rectangle()
                            .fill(.orange)
                            .frame(width: 74, height: 1.5)
                            .padding(.top, 2)

                        Text("Pick a quick exercise and start")
                            .font(.system(size: 16))
                            .foregroundStyle(Color(white: 0.25))
                            .padding(.leading, 4)
                            .padding(.top, 6)
                    }
                    .padding(.horizontal, 24)

                    // Cards (tap to open each game)
                    VStack(spacing: 20) {

                        NavigationLink {
                            SplashIt3()                        } label: {
                            ExerciseCard(
                                icon: Image(.paintArt),
                                title: "Splash It",
                                description: "Pick the right colors and bring the logo to life.",
                                accent: Color(red: 0.28, green: 0.42, blue: 0.22),
                                gradient: [Color(red: 0.96, green: 0.96, blue: 0.92),
                                           Color(red: 0.78, green: 0.88, blue: 0.75)]
                            )
                        }

                        NavigationLink {
                            ShapeUpView()
                        } label: {
                            ExerciseCard(
                                icon: Image(.shapeUp),
                                title: "Shape Up",
                                description: "Fit the shapes together to build the picture.",
                                accent: Color(red: 0.17, green: 0.37, blue: 0.58),
                                gradient: [Color(red: 0.95, green: 0.95, blue: 0.94),
                                           Color(red: 0.86, green: 0.90, blue: 0.94)]
                            )
                        }

                        NavigationLink {
                            SloganSparkView()
                        } label: {
                            ExerciseCard(
                                icon: Image(.sloganSpark),
                                title: "Slogan Spark",
                                description: "Come up with a catchy slogan for the company.",
                                accent: Color(red: 0.76, green: 0.72, blue: 0.20),
                                gradient: [Color(red: 0.99, green: 0.98, blue: 0.95),
                                           Color(red: 0.99, green: 0.96, blue: 0.86)]
                            )
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 16)
                    .padding(.top, 14)

                    Spacer()
                }
                .padding(.top, 62)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}




#Preview {
    HomeView()
}
