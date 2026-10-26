//
//  Slogansparkview.swift
//  Unstock
//
//  Created by Renad Sameer Alharbi on 14/05/1448 AH.
//

import SwiftUI
 
// MARK: - Brand model
struct Brand: Identifiable {
    let id = UUID()
    let name: String
    let logo: String              // اسم الـ Image Set في Assets
    let slogan: String            // السلوقن الأصلي (غير مستخدم حالياً في البوب أب)
    var fillsCircle: Bool = false // true = الصورة تغطي الدايرة كاملة
 
    static let all: [Brand] = [
        Brand(name: "Kitkat", logo: "kitkatlogo", slogan: "Have a break, have a KitKat"),
        Brand(name: "Red Bull", logo: "redbulllogo", slogan: "Red Bull gives you wings", fillsCircle: true)
    ]
}
 
// MARK: - Wave (الحافة المموجة تحت الهيدر، مقاسات التصميم 402 عرض)
struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        let s = rect.width / 402
        var p = Path()
        p.move(to: .zero)
        p.addLine(to: CGPoint(x: rect.width, y: 0))
        var x = rect.width
        while x >= 0 {
            let y = (223 - 24 * cos(2 * .pi * (x / s - 140) / 177)) * s
            p.addLine(to: CGPoint(x: x, y: y))
            x -= 1
        }
        p.closeSubpath()
        return p
    }
}
 
// MARK: - Slogan Spark (Game 1)
struct Slogansparkview: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool
 
    @State private var brandIndex = 0
    @State private var slogan = ""
    @State private var showPopup = false
 
    private let brands = Brand.all
    private var brand: Brand { brands[brandIndex] }
    private var isEmpty: Bool { slogan.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
 
    // الألوان (من التصميم)
    private let pageBackground = Color(red: 0.992, green: 0.980, blue: 0.965)
    private let headerTop      = Color(red: 0.929, green: 0.890, blue: 0.710)
    private let headerBottom   = Color(red: 0.969, green: 0.949, blue: 0.863)
    private let cardTop        = Color(red: 0.996, green: 0.988, blue: 0.973)
    private let cardBottom     = Color(red: 0.996, green: 0.961, blue: 0.843)
    private let borderGray     = Color(white: 0.58)
 
    var body: some View {
        ZStack {
            pageBackground.ignoresSafeArea()
 
            ScrollView {
                ZStack(alignment: .top) {
                    WaveShape()
                        .fill(LinearGradient(colors: [headerTop, headerBottom],
                                             startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(height: 250)
                        .shadow(color: .black.opacity(0.10), radius: 8, y: 4)
 
                    VStack(spacing: 0) {
                        titleBar.padding(.top, 110)
                        card.padding(.top, 115)
                        doneButton.padding(.top, 54)
                        Spacer(minLength: 0)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 874)
            }
            .ignoresSafeArea(edges: .top)
            .scrollDismissesKeyboard(.interactively)
            .scrollBounceBehavior(.basedOnSize)
 
            // POP UP: خلفية معتمة + صفحة البنت الثانية (PopUpView)
            if showPopup {
                ZStack {
                    Color.black.opacity(0.35).ignoresSafeArea()
                    PopUpView(onHome: goHome, onReplay: replay)
                }
                .transition(.opacity)
            }
        }
    }
 
    // MARK: Title bar
    private var titleBar: some View {
        ZStack {
            VStack(spacing: 2) {
                Text("Slogan Spark")
                    .font(.system(size: 24, weight: .semibold))
                Text("Give this brand its spark.")
                    .font(.system(size: 16, weight: .light))
            }
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 22, weight: .regular))
                }
                Spacer()
            }
            .padding(.leading, 36)
        }
        .foregroundColor(.black)
    }
 
    // MARK: Logo (دايرة)
    private var logoCircle: some View {
        Image(brand.logo)
            .resizable()
            .aspectRatio(contentMode: brand.fillsCircle ? .fill : .fit)
            .padding(brand.fillsCircle ? 0 : 12)
            .frame(width: 182, height: 182)
            .background(Color.white)
            .clipShape(Circle())
    }
 
    // MARK: Card
    private var card: some View {
        VStack(spacing: 0) {
            logoCircle
 
            Text(brand.name)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black)
                .padding(.top, 2)
 
            Text("What would you say in a few words?")
                .font(.system(size: 15))
                .foregroundColor(.black)
                .padding(.top, 37)
 
            TextField("", text: $slogan,
                      prompt: Text("Type your slogan here").foregroundColor(.gray))
                .focused($isFocused)
                .submitLabel(.done)                          // زر الكيبورد يكتب Done
                .onSubmit { if !isEmpty { submit() } }       // الضغط عليه يرسل الإجابة
                .autocorrectionDisabled()                    // بدون تصحيح تلقائي
                .textInputAutocapitalization(.sentences)     // أول حرف كبير
                .font(.system(size: 17))
                .padding(.horizontal, 24)
                .frame(width: 292, height: 58)
                .background(Capsule().fill(Color.white))
                .overlay(Capsule().stroke(borderGray, lineWidth: 1))
                .padding(.top, 11)
        }
        .padding(.top, 24)
        .padding(.bottom, 60)
        .frame(width: 343)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(LinearGradient(colors: [cardTop, cardBottom],
                                     startPoint: .top, endPoint: .bottom))
                .shadow(color: .black.opacity(0.18), radius: 12, x: 4, y: 10)
        )
        .id(brand.id)
    }
 
    // MARK: Done
    private var doneButton: some View {
        Button { submit() } label: {
            Text("Done")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
                .frame(width: 227, height: 56)
                .background(Capsule().fill(Color.white))
                .overlay(Capsule().stroke(borderGray, lineWidth: 1))
        }
        .disabled(isEmpty) // معطّل إذا الحقل فاضي (نفس شكل التصميم)
    }
 
    // MARK: Actions
    private func submit() {
        let reply = slogan.trimmingCharacters(in: .whitespacesAndNewlines)
        isFocused = false
        // هنا تحفظين ردّ المستخدم (reply) لو تبين
        print("Reply for \(brand.name): \(reply)")
        withAnimation { showPopup = true }
    }
 
    /// زر Replay: يسكّر البوب أب ويبدأ براند جديد
    private func replay() {
        withAnimation { showPopup = false }
        slogan = ""
        brandIndex = (brandIndex + 1) % brands.count
    }
 
    /// زر Home: حالياً يرجع للصفحة السابقة، غيّريه لتنقّل صفحة Home عندكم
    private func goHome() {
        showPopup = false
        dismiss()
    }
}
 
#Preview {
    Slogansparkview()
}
 
