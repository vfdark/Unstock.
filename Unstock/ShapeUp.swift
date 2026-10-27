import SwiftUI
import PencilKit

struct ShapeUp: View {

    @Environment(\.dismiss) private var dismiss

    @State private var canvasView = PKCanvasView()
    @State private var toolPicker = PKToolPicker()
    @State private var showSuccessPopup = false

    
    private let puzzles: [(image: String, question: String)] = [
        ("2Lines", "This is not a triangle, This is a .."),
        ("Shape2", "This is not a wave, This is a .."),
        ("Shape3", "This is not a circle, This is a ..")
    ]
    @State private var puzzleIndex = 0

    private let cardTop: CGFloat = 400
    private let bgColor = Color(red: 254.0 / 255, green: 250.0 / 255, blue: 243.0 / 255)

    var body: some View {
        GeometryReader { geometry in
            let scale = min(geometry.size.width / 585, geometry.size.height / 1261)

            referenceLayout
                .frame(width: 585, height: 1261)
                .scaleEffect(scale)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .background(bgColor)
        .ignoresSafeArea()
        .toolbar(.hidden, for: .navigationBar)
        .overlay {
            if showSuccessPopup {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()

                    VStack(spacing: 20) {
                        Image("checkmark")
                            .padding(.top, 50)

                        Text("Good Job!")
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                            .foregroundColor(.black)

                        Button {
                            showSuccessPopup = false
                            dismiss()
                        } label: {
                            Text("Home")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 200, height: 45)
                                .background(Color.black)
                                .cornerRadius(25)
                        }

                        Button {
                            replayWithNextPuzzle()
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
        .animation(.easeInOut(duration: 0.25), value: showSuccessPopup)
    }
    private func replayWithNextPuzzle() {
        canvasView.drawing = PKDrawing()
        showSuccessPopup = false
        withAnimation(.easeInOut(duration: 0.3)) {
            puzzleIndex = (puzzleIndex + 1) % puzzles.count
        }
    }
    
    private var referenceLayout: some View {
        ZStack(alignment: .topLeading) {
            bgColor

            // البطاقة
            Image("Rectangle 6")
                .resizable(
                    capInsets: EdgeInsets(top: 60, leading: 40, bottom: 60, trailing: 40),
                    resizingMode: .stretch
                )
                .frame(width: 540, height: 1051 - cardTop)
                .frame(maxWidth: .infinity)
                .offset(x: 10, y: cardTop)

            // موجة الهيدر
            Image("Path 3")
                .resizable()
                .scaledToFit()
                .frame(width: 600, height: 500, alignment: .top)
                .allowsHitTesting(false)
                .accessibilityHidden(true)
                .padding(.bottom, 700)

            // زر الرجوع
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
            .position(x: 55, y: 181)

            // العنوان
            Text("Shape UP")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.black)
                .position(x: 292, y: 182)

            Text("Fit the shapes together to build the picture.")
                .font(.system(size: 25.5))
                .foregroundStyle(Color(white: 0.1))
                .fixedSize()
                .position(x: 292, y: 226)

            // السؤال
            Text(puzzles[puzzleIndex].question)
                .font(.system(size: 30))
                .foregroundStyle(.black)
                .fixedSize()
                .position(x: 292, y: 420)

            // مساحة الرسم
            drawingArea
                .position(x: 294, y: 620)

            // Undo / Redo / Clear
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
            .position(x: 292, y: 850)

            // Done
            Button {
                showSuccessPopup = true
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
            .position(x: 288, y: 950)
        }
    }

    private var drawingArea: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(.white)

            CanvasView(canvasView: canvasView, toolPicker: toolPicker)

            Image(puzzles[puzzleIndex].image)
                .resizable()
                .scaledToFit()
                .padding(90)
                .offset(y: -50)
                .allowsHitTesting(false)
                .id(puzzleIndex)
                .transition(.opacity)
        }
        .frame(width: 400, height: 340)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .contentShape(RoundedRectangle(cornerRadius: 30))
    }
}

#Preview {
    ShapeUp()
}

struct CanvasView: UIViewRepresentable {
    let canvasView: PKCanvasView
    let toolPicker: PKToolPicker

    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.drawingPolicy = .anyInput
        canvasView.isScrollEnabled = false
        canvasView.isUserInteractionEnabled = true

        toolPicker.addObserver(canvasView)

        DispatchQueue.main.async {
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            canvasView.becomeFirstResponder()
        }

        return canvasView
    }


    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}
