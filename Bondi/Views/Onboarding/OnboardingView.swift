import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var currentPage = 0

    private let slides: [(icon: String, title: String, subtitle: String)] = [
        (
            "building.columns.fill",
            "Bonos soberanos\ndesde $5 USD",
            "Antes necesitabas miles de dólares y un broker complicado. Ahora, solo tu iPhone."
        ),
        (
            "brain.head.profile",
            "La IA te explica\ntodo en español",
            "Sin jerga financiera. Bondi usa Apple Intelligence para que entiendas exactamente en qué estás invirtiendo."
        ),
        (
            "chart.line.uptrend.xyaxis",
            "Tu dinero\ntrabajando para ti",
            "Rendimientos de hasta 11% anual en bonos de gobiernos latinoamericanos. Sin complicaciones."
        )
    ]

    var body: some View {
        ZStack {
            Color.bondiSoftBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button("Saltar") { onComplete() }
                        .font(.bondiSubheadline.weight(.medium))
                        .foregroundStyle(Color.bondiNavy.opacity(0.6))
                        .padding()
                }

                Spacer()

                TabView(selection: $currentPage) {
                    ForEach(slides.indices, id: \.self) { index in
                        OnboardingSlide(
                            icon: slides[index].icon,
                            title: slides[index].title,
                            subtitle: slides[index].subtitle
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 420)

                HStack(spacing: 8) {
                    ForEach(slides.indices, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.bondiGreen : Color.bondiNavy.opacity(0.2))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.bottom, 40)

                Spacer()

                Button(currentPage < slides.count - 1 ? "Siguiente" : "Comenzar") {
                    if currentPage < slides.count - 1 {
                        withAnimation { currentPage += 1 }
                    } else {
                        onComplete()
                    }
                }
                .buttonStyle(BondiPrimaryButtonStyle(icon: currentPage < slides.count - 1 ? "arrow.right" : "checkmark"))
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
    }
}

private struct OnboardingSlide: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: icon)
                .font(.system(size: 64, weight: .light))
                .foregroundStyle(Color.bondiGreen)

            Text(title)
                .font(.bondiTitle)
                .foregroundStyle(Color.bondiNavy)
                .multilineTextAlignment(.center)
                .lineSpacing(2)

            Text(subtitle)
                .font(.bondiBody)
                .foregroundStyle(Color.bondiNavy.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .padding(.horizontal, 32)
        }
        .padding()
    }
}
