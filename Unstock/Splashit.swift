import SwiftUI
import PencilKit

// MARK: - Models

enum Tool: String, CaseIterable {
    case pen, marker, crayon, eraser
    var label: String { rawValue.capitalized }
    var imageName: String {
        switch self {
        case .pen: "Pen"
        case .marker: "Marker2"
        case .crayon: "Crayon"
        case .eraser: "Eraser"
        }
    }
}

// MARK: - PencilKit canvas

struct PencilCanvas: UIViewRepresentable {
    let canvasView: PKCanvasView
    var tool: Tool
    var color: Color
    var size: CGFloat
    /// true  = system iOS markup palette (docked at the bottom by iOS, can't be repositioned)
    /// false = your custom toolbar drives PencilKit
    var useSystemPalette: Bool

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.isScrollEnabled = false
        canvasView.overrideUserInterfaceStyle = .light
        canvasView.tool = makeTool()

        if useSystemPalette {
            let picker = context.coordinator.toolPicker
            picker.colorUserInterfaceStyle = .light
            picker.addObserver(canvasView)
            DispatchQueue.main.async {
                picker.setVisible(true, forFirstResponder: canvasView)
                canvasView.becomeFirstResponder()
            }
        }
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if !useSystemPalette { uiView.tool = makeTool() }
    }

    static func dismantleUIView(_ uiView: PKCanvasView, coordinator: Coordinator) {
        coordinator.toolPicker.setVisible(false, forFirstResponder: uiView)
        coordinator.toolPicker.removeObserver(uiView)
    }

    final class Coordinator {
        let toolPicker = PKToolPicker()
    }

    private func makeTool() -> PKTool {
        let ui = UIColor(color)
        switch tool {
        case .pen:    return ink(.pen, ui, size * 0.5)
        case .marker: return ink(.marker, ui, size)
        case .crayon: return ink(.crayon, ui, size)       // iOS 17+
        case .eraser: return PKEraserTool(.bitmap, width: size * 2)
        }
    }

    private func ink(_ type: PKInkingTool.InkType, _ color: UIColor, _ width: CGFloat) -> PKInkingTool {
        let range = type.validWidthRange                  // iOS 17+
        return PKInkingTool(type, color: color,
                            width: min(max(width, range.lowerBound), range.upperBound))
    }
}

// MARK: - Screen

struct Splashit: View {

    @Environment(\.dismiss) private var dismiss

    @State private var canvasView = PKCanvasView()
    @State private var tool: Tool = .pen
    @State private var raisedTool: Tool?
    @State private var color: Color = .black
    @State private var size: CGFloat = 17

    /// Logos shown one after another. Each name must match an image in Assets.
    /// To add another logo, drop the image in Assets and add its name here.
    private let logos = ["Pepsi", "mac", "starbucks"]
    @State private var logoIndex = 0
    /// Shows the "Good Job!" popup (same design as Shape Up).
    @State private var showGoodJob = false

    /// true = Apple's iOS markup palette (docked at the bottom by iOS).
    /// false = the custom toolbar.
    private let useSystemPalette = true
    private let logoSize: CGFloat = 320
    /// Where the white/green card begins (reference-layout units). Starts below the header wave
    /// so its edges and shadow don't show through the header. Nudge if you see a seam.
    private let cardTop: CGFloat = 330

    var body: some View {
        GeometryReader { geometry in
            let scale = min(geometry.size.width / 585, geometry.size.height / 1261)

            referenceLayout
                .frame(width: 585, height: 1261)
                .scaleEffect(scale)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .background(Color(red: 254.0 / 255, green: 250.0 / 255, blue: 243.0 / 255))
        .ignoresSafeArea()
        .toolbar(.hidden, for: .navigationBar)
        .overlay {
            if showGoodJob {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()

                    VStack(spacing: 20) {
                        Image(.checkmarkIcon)
                            .padding(.top, 50)

                        Text("Good Job!")
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                            .foregroundColor(.black)

                        // Main action
                        Button {
                            showGoodJob = false
                            dismiss()
                        } label: {
                            Text("Home")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 200, height: 45)
                                .background(Color.black)
                                .cornerRadius(25)
                        }

                        // Secondary action
                        Button {
                            replayWithNextLogo()
                        } label: {
                            Text("Replay")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(width: 200, height: 45)
                                .background(Color.white)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                    .padding(30)
                    .background(Color("backgraundyellow"))
                    .cornerRadius(30)
                    .shadow(radius: 10)
                    .padding(.horizontal, 40)
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showGoodJob)
    }

    // MARK: Actions

    /// Called by the popup's Replay button: closes the popup, clears the drawing
    /// and switches to the next logo (wraps back to the first after the last one).
    private func replayWithNextLogo() {
        canvasView.drawing = PKDrawing()
        showGoodJob = false
        withAnimation(.easeInOut(duration: 0.3)) {
            logoIndex = (logoIndex + 1) % logos.count
        }
    }

    // MARK: Layout

    private var referenceLayout: some View {
        ZStack(alignment: .topLeading) {
            Color(red: 254.0 / 255, green: 250.0 / 255, blue: 243.0 / 255)

            Image("Group")
                .resizable(
                    capInsets: EdgeInsets(top: 60, leading: 40, bottom: 60, trailing: 40),
                    resizingMode: .stretch
                )
                .frame(width: 540, height: 1051 - cardTop)
                .frame(maxWidth: .infinity)
                .offset(x: 10, y: cardTop)

            Image("Path 5")
                .resizable()
                .scaledToFit()
                .frame(width: 585, height: 435, alignment: .top)
                .allowsHitTesting(false)
                .accessibilityHidden(true)
                .padding(.bottom, 700)

            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(Color(white: 0.15))
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Back")
            .position(x: 55, y: 181)

            Text("Splash It")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.black)
                .position(x: 292, y: 182)

            Text("Pick the right colors and bring the logo to life.")
                .font(.system(size: 25.5))
                .foregroundStyle(Color(white: 0.1))
                .fixedSize()
                .position(x: 292, y: 226)

            canvas
                .position(x: 294, y: 574)

            HStack(spacing: 24) {
                Button { canvasView.undoManager?.undo() } label: {
                    Label("Undo", systemImage: "arrow.uturn.backward")
                }
                Button { canvasView.undoManager?.redo() } label: {
                    Label("Redo", systemImage: "arrow.uturn.forward")
                }
                Button(role: .destructive) { canvasView.drawing = PKDrawing() } label: {
                    Label("Clear", systemImage: "trash")
                }
            }
            .font(.system(size: 24, weight: .medium))
            .foregroundStyle(.black)
            .position(x: 292, y: 790)

            if !useSystemPalette {
                toolbar
                    .frame(width: 434, height: 144)
                    .scaleEffect(466.0 / 434.0)
                    .position(x: 292, y: 933.3)
            }

            // Done: opens the "Good job" popup.
            Button {
                showGoodJob = true
            } label: {
                Text("Done")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.black)
                    .frame(width: 334, height: 82)
                    .background(.white, in: Capsule())
                    .overlay {
                        Capsule().strokeBorder(Color(white: 0.6), lineWidth: 1.2)
                    }
                    .contentShape(Capsule())
            }
            .buttonStyle(.plain)
            // With the system palette, iOS docks it at the bottom of the screen,
            // so the button moves up into the card where the custom toolbar used to be.
            .position(x: 288, y: useSystemPalette ? 900 : 1129)
        }
    }

    // MARK: Canvas

    private var canvas: some View {
        ZStack {
            Circle().fill(.white)

            PencilCanvas(canvasView: canvasView, tool: tool, color: color,
                         size: size, useSystemPalette: useSystemPalette)

            Image(logos[logoIndex])
                .resizable()
                .scaledToFit()
                .padding(10)
                .blendMode(.multiply)
                .allowsHitTesting(false)
                .id(logoIndex)
                .transition(.opacity)
        }
        .frame(width: logoSize, height: logoSize)
        .clipShape(Circle())
        .contentShape(Circle())
    }

    // MARK: Toolbar (original look)

    private var toolbar: some View {
        ZStack(alignment: .topLeading) {
            Capsule()
                .fill(Color(red: 188.0 / 255, green: 212.0 / 255, blue: 180.0 / 255))
                .frame(width: 434, height: 88)
                .position(x: 217, y: 44)

            ColorPicker("Drawing color", selection: $color, supportsOpacity: false)
                .labelsHidden()
                .frame(width: 32, height: 32)
                .position(x: 51, y: 44)

            toolButton(.pen)
                .position(x: 119, y: 51)
            toolButton(.marker)
                .position(x: 196, y: 51)
            toolButton(.crayon)
                .position(x: 273, y: 51)
            toolButton(.eraser)
                .position(x: 350, y: 51)

            brushSizeSlider
                .frame(width: 316, height: 44)
                .position(x: 216, y: 122)
        }
        .environment(\.layoutDirection, .leftToRight)
    }

    private var brushSizeSlider: some View {
        GeometryReader { geometry in
            let progress = (size - 2) / 38
            let travel = geometry.size.width
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(red: 174.0 / 255, green: 195.0 / 255, blue: 165.0 / 255))
                    .frame(height: 8)
                Capsule()
                    .fill(.black)
                    .frame(width: max(8, progress * travel), height: 8)
                Circle()
                    .fill(.black)
                    .frame(width: 26, height: 26)
                    .offset(x: progress * travel - 13)
            }
            .frame(height: 44)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        size = 2 + min(1, max(0, value.location.x / travel)) * 38
                    }
            )
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Brush size")
            .accessibilityValue(Text("\(Int(size)) points"))
            .accessibilityAdjustableAction { direction in
                switch direction {
                case .increment: size = min(40, size + 1)
                case .decrement: size = max(2, size - 1)
                @unknown default: break
                }
            }
        }
    }

    private func toolButton(_ t: Tool) -> some View {
        let top: CGFloat = t == .pen ? 2 : (t == .marker ? 24 : (t == .crayon ? 17 : 22))
        return Button {
            tool = t
            raisedTool = t
        } label: {
            VStack(spacing: 3) {
                Image(t.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 154, alignment: .top)
                    .offset(y: top)
                    .frame(width: 44, height: 88, alignment: .top)
                    .clipped()
                    .overlay(alignment: .top) {
                        if t == .eraser {
                            Rectangle()
                                .fill(Color(red: 112.0 / 255, green: 103.0 / 255, blue: 246.0 / 255))
                                .frame(width: 40, height: 5)
                                .offset(y: 49)
                        }
                    }
                    .offset(y: raisedTool == t ? -14 : 0)
                    .animation(.easeInOut(duration: 0.2), value: raisedTool)
                    .accessibilityHidden(true)
                Text(t.label)
                    .font(.system(size: 10))
                    .foregroundStyle(.black)
            }
            .frame(width: 60, height: 102)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(tool == t ? .isSelected : [])
    }
}

#Preview {
    Splashit()
}
