//
//  PopUpView.swift
//  Unstock
//
//  Created by Renad Sameer Alharbi on 15/05/1448 AH.
//

import SwiftUI
 

struct PopUpView: View {
    var onHome: () -> Void
    var onReplay: () -> Void
 
    var body: some View {
        VStack(spacing: 24) {
            Image(.checkmarkIcon)
                .font(.system(size: 90))
                .foregroundColor(.orange)
 
            Text("Good Job!")
                .font(.system(size: 44, weight: .heavy))
                .foregroundColor(.black)
 
            VStack(spacing: 12) {
                Button(action: onHome) {
                    Text("Home")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color(white: 0.13)))
                }
                Button(action: onReplay) {
                    Text("Replay")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, minHeight: 56)
                        .background(RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.white))
                        .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color(white: 0.8), lineWidth: 1))
                }
            }
        }
        .padding(24)
        .frame(width: 343)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color(red: 0.992, green: 0.980, blue: 0.965))
        )
    }
}
 
#Preview {
    PopUpView(onHome: {}, onReplay: {})
}
 
