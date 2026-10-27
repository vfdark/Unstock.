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
    @State private var showSuccessPopup = false
    
    var body: some View {
        ZStack {
            
            Color("backgraundyellow")
                .ignoresSafeArea()
            
            Image("Path 5")
                .padding(.bottom, 600)
         
            // ادوات ابل
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
            // done bottom
            VStack {
                Spacer()
                
                Button(action: {
                    showSuccessPopup = true
                }) {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(width: 220, height: 45)
                    .background(Color.white)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            .padding(.bottom, 150 )
        }
            // pop up
            if showSuccessPopup {
                
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    ZStack {
                        Image("checkmark")
                    }
                    .padding(.top, 50)
                    
                    
                    Text("Good Job!")
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Button(action: {
                        showSuccessPopup = false
                    }) {
                    
                    Text("Home")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 45)
                        .background(Color.black)
                        .cornerRadius(25)
                }
                
                Button(action: {
                    showSuccessPopup = false
                }) {
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
          }
        }
    }

    // لوحة الرسم
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
