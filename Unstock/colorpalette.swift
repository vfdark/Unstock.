//
//  colorpalette.swift
//  Unstock
//
//  Created by Tala Almansor on 14/05/1448 AH.
//

import SwiftUI
import PencilKit

struct ColorpaletteView: View {
    @State private var selectedColor: Color = .black
    @State private var canvasView = PKCanvasView()
    @State private var toolPicker = PKToolPicker()
    
    var body: some View {
        ZStack {
            Color("backgraundyellow")
                .ignoresSafeArea()
            
            Image("Path 4")
                .padding(.bottom, 600)
            
            CanvasViewRepresentable(canvasView: $canvasView)
                .ignoresSafeArea()
                .onAppear {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let _ = windowScene.windows.first {
                        toolPicker.setVisible(true, forFirstResponder: canvasView)
                        toolPicker.addObserver(canvasView)
                        canvasView.becomeFirstResponder()
                    }
                }
        
        .onChange(of: selectedColor) { oldValue, newValue in
                canvasView.tool = PKInkingTool(.pen, color: UIColor(newValue), width: 5)

                }
        }
    }
}

struct CanvasViewRepresentable: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
     
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        return canvasView
    }
     
    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}

#Preview {
    ColorpaletteView()
}
