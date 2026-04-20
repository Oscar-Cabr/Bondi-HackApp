import SwiftUI

struct LandingView: View {
    let onStart: () -> Void
    let onSignIn: () -> Void

    @State private var appeared = false
    @State private var animatedYield: Double = 0
    @State private var cardTilt: CGSize = .zero
    @State private var shinePhase: CGFloat = -1

    private let finalYield: Double = 8.2

    var body: some View {
        ZStack {
            AnimatedMeshBackground()
                .ignoresSafeArea()

            FloatingCoins()
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                header
                    .padding(.top, 16)
                    .padding(.horizontal, 24)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : -16)

                Spacer(minLength: 12)

                bondCard
                    .padding(.horizontal, 28)
                    .opacity(appeared ? 1 : 0)
                    .scaleEffect(appeared ? 1 : 0.9)
                    .offset(y: appeared ? 0 : 20)

                Spacer(minLength: 12)

                badgeRow
                    .padding(.horizontal, 24)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)

                Spacer(minLength: 16)

                headline
                    .padding(.horizontal, 28)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 16)

                Spacer(minLength: 20)

                cta
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 24)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear { start() }
    }

    private func start() {
        withAnimation(.spring(response: 0.9, dampingFraction: 0.75).delay(0.05)) {
            appeared = true
        }
        withAnimation(.easeOut(duration: 1.6).delay(0.3)) {
            animatedYield = finalYield
        }
        withAnimation(.linear(duration: 2.4).repeatForever(autoreverses: false).delay(0.6)) {
            shinePhase = 2
        }
    }

    private var header: some View {
        HStack {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Color.bondiGreen)
                        .frame(width: 32, height: 32)
                        .shadow(color: Color.bondiGreen.opacity(0.6), radius: 10)
                    Image(systemName: "b.circle.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color.bondiNavy)
                }
                Text("Bondi")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
            }

            Spacer()

            Text("BETA")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundStyle(.white.opacity(0.9))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(.white.opacity(0.12))
                        .overlay(Capsule().stroke(.white.opacity(0.25), lineWidth: 0.8))
                )
        }
    }

    private var headline: some View {
        VStack(spacing: 14) {
            (
                Text("Invierte en bonos\ndesde ")
                    .foregroundColor(.white)
                + Text("$5")
                    .font(.system(size: 34, weight: .heavy, design: .rounded))
                    .foregroundColor(Color.bondiGreen)
            )
            .font(.system(size: 34, weight: .bold, design: .rounded))
            .multilineTextAlignment(.center)

            Text("La IA te explica todo en español.\nSin jerga, sin brokers, sin fricción.")
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundStyle(.white.opacity(0.75))
                .multilineTextAlignment(.center)
                .lineSpacing(2)
        }
    }

    private var bondCard: some View {
        BondHeroCard(
            animatedYield: animatedYield,
            shinePhase: shinePhase,
            tilt: cardTilt
        )
        .aspectRatio(1.62, contentMode: .fit)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let clamped = CGSize(
                        width: max(-30, min(30, value.translation.width / 6)),
                        height: max(-30, min(30, value.translation.height / 6))
                    )
                    cardTilt = clamped
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.55)) {
                        cardTilt = .zero
                    }
                }
        )
    }

    private var badgeRow: some View {
        HStack(spacing: 10) {
            BadgePill(icon: "sparkles", text: "Apple Intelligence", tint: Color.bondiGreen)
            BadgePill(icon: "lock.shield.fill", text: "Stellar", tint: .white)
            BadgePill(icon: "bolt.fill", text: "KYC en minutos", tint: Color.bondiAmber)
        }
    }

    private var cta: some View {
        VStack(spacing: 14) {
            Button(action: onStart) {
                HStack(spacing: 10) {
                    Text("Crear mi cuenta")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .bold))
                }
                .foregroundStyle(Color.bondiNavy)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    ZStack {
                        LinearGradient(
                            colors: [Color.bondiGreen, Color(hex: "86EFAC")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        LinearGradient(
                            colors: [.white.opacity(0.45), .clear],
                            startPoint: .top,
                            endPoint: .center
                        )
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Color.bondiGreen.opacity(0.45), radius: 20, y: 10)
            }
            .buttonStyle(PressableButtonStyle())

            Button(action: onSignIn) {
                HStack(spacing: 6) {
                    Text("¿Ya tienes cuenta?")
                        .foregroundStyle(.white.opacity(0.7))
                    Text("Iniciar sesión")
                        .foregroundStyle(Color.bondiGreen)
                        .fontWeight(.semibold)
                }
                .font(.system(size: 14, design: .rounded))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.white.opacity(0.06))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(.white.opacity(0.18), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(PressableButtonStyle())
        }
    }
}

private struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Hero Card

private struct BondHeroCard: View {
    let animatedYield: Double
    let shinePhase: CGFloat
    let tilt: CGSize

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            ZStack {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: "0F2844"),
                                Color(hex: "1A3A5C"),
                                Color(hex: "24527F")
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.35), .white.opacity(0.05)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )

                GeometryReader { _ in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.bondiGreen.opacity(0.45), .clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: size.width * 0.55
                            )
                        )
                        .frame(width: size.width, height: size.width)
                        .offset(x: size.width * 0.35, y: -size.width * 0.25)
                        .blur(radius: 20)
                }
                .allowsHitTesting(false)

                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("BONO SOBERANO")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .tracking(1.2)
                                .foregroundStyle(.white.opacity(0.55))
                            Text("México · Serie M")
                                .font(.system(.headline, design: .rounded, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        Spacer()
                        Text("🇲🇽")
                            .font(.system(size: 30))
                            .shadow(color: .black.opacity(0.3), radius: 6)
                    }

                    Spacer(minLength: 8)

                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        AnimatedYieldText(value: animatedYield)
                        Text("%")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.bondiGreen)
                            .baselineOffset(4)
                        Text("anual")
                            .font(.system(size: 13, design: .rounded))
                            .foregroundStyle(.white.opacity(0.55))
                            .padding(.leading, 2)
                    }

                    Sparkline()
                        .stroke(
                            LinearGradient(
                                colors: [Color.bondiGreen.opacity(0.4), Color.bondiGreen],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 2.2, lineCap: .round, lineJoin: .round)
                        )
                        .frame(height: 40)
                        .padding(.top, 6)

                    Spacer(minLength: 6)

                    HStack {
                        CardStat(label: "Vence", value: "Jun 2027")
                        Spacer()
                        CardStat(label: "Mínimo", value: "$5")
                        Spacer()
                        CardStat(label: "Riesgo", value: "Bajo", valueColor: Color.bondiGreen, alignment: .trailing)
                    }
                }
                .padding(22)

                // Shine sweep
                ShineOverlay(phase: shinePhase)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .allowsHitTesting(false)
            }
            .rotation3DEffect(
                .degrees(Double(-tilt.height / 6)),
                axis: (x: 1, y: 0, z: 0),
                perspective: 0.6
            )
            .rotation3DEffect(
                .degrees(Double(tilt.width / 6)),
                axis: (x: 0, y: 1, z: 0),
                perspective: 0.6
            )
            .shadow(color: .black.opacity(0.45), radius: 30, y: 18)
            .shadow(color: Color.bondiGreen.opacity(0.15), radius: 40, y: 0)
        }
    }
}

private struct CardStat: View {
    let label: String
    let value: String
    var valueColor: Color = .white
    var alignment: HorizontalAlignment = .leading

    var body: some View {
        VStack(alignment: alignment, spacing: 3) {
            Text(label.uppercased())
                .font(.system(size: 9, weight: .semibold, design: .rounded))
                .tracking(0.8)
                .foregroundStyle(.white.opacity(0.5))
            Text(value)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(valueColor)
        }
    }
}

private struct AnimatedYieldText: View {
    let value: Double

    var body: some View {
        Text(String(format: "%.1f", value))
            .font(.system(size: 56, weight: .heavy, design: .rounded))
            .foregroundStyle(
                LinearGradient(
                    colors: [.white, Color.bondiGreen],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .contentTransition(.numericText(value: value))
            .monospacedDigit()
    }
}

private struct Sparkline: Shape {
    // Stylized upward-trending line
    private let points: [CGFloat] = [0.80, 0.72, 0.76, 0.62, 0.55, 0.58, 0.44, 0.36, 0.32, 0.20, 0.12]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard points.count > 1 else { return path }
        let step = rect.width / CGFloat(points.count - 1)
        for (i, p) in points.enumerated() {
            let x = CGFloat(i) * step
            let y = p * rect.height
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                let prevX = CGFloat(i - 1) * step
                let prevY = points[i - 1] * rect.height
                let midX = (prevX + x) / 2
                path.addCurve(
                    to: CGPoint(x: x, y: y),
                    control1: CGPoint(x: midX, y: prevY),
                    control2: CGPoint(x: midX, y: y)
                )
            }
        }
        return path
    }
}

private struct ShineOverlay: View {
    let phase: CGFloat

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0),
                    .init(color: .white.opacity(0.22), location: 0.45),
                    .init(color: .white.opacity(0.35), location: 0.5),
                    .init(color: .white.opacity(0.22), location: 0.55),
                    .init(color: .clear, location: 1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(width: w * 0.6)
            .rotationEffect(.degrees(20))
            .offset(x: phase * w)
            .blendMode(.plusLighter)
        }
    }
}

// MARK: - Animated Background

private struct AnimatedMeshBackground: View {
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { context in
            let t = context.date.timeIntervalSinceReferenceDate
            let a = CGFloat(sin(t * 0.35) * 0.5 + 0.5)
            let b = CGFloat(cos(t * 0.28) * 0.5 + 0.5)
            let c = CGFloat(sin(t * 0.22 + 1.2) * 0.5 + 0.5)

            ZStack {
                Color(hex: "0A1B30")

                meshOrFallback(a: a, b: b, c: c)

                glow(
                    color: Color.bondiGreen.opacity(0.28),
                    size: 360,
                    blur: 90,
                    offsetX: -140 + 40 * a,
                    offsetY: -260 + 30 * b
                )

                glow(
                    color: Color(hex: "3B82F6").opacity(0.25),
                    size: 320,
                    blur: 100,
                    offsetX: 160 - 30 * c,
                    offsetY: 280 + 20 * a
                )

                Rectangle()
                    .fill(.white.opacity(0.015))
                    .blendMode(.overlay)
            }
        }
    }

    @ViewBuilder
    private func meshOrFallback(a: CGFloat, b: CGFloat, c: CGFloat) -> some View {
        if #available(iOS 18.0, *) {
            let points: [SIMD2<Float>] = [
                SIMD2<Float>(0.0, 0.0),
                SIMD2<Float>(0.5, Float(0.08 * a)),
                SIMD2<Float>(1.0, 0.0),
                SIMD2<Float>(Float(0.1 * b), 0.5),
                SIMD2<Float>(Float(0.5 + 0.08 * c), Float(0.5 + 0.05 * a)),
                SIMD2<Float>(Float(1.0 - 0.1 * b), 0.5),
                SIMD2<Float>(0.0, 1.0),
                SIMD2<Float>(0.5, Float(1.0 - 0.08 * c)),
                SIMD2<Float>(1.0, 1.0)
            ]
            let colors: [Color] = [
                Color(hex: "0A1B30"), Color(hex: "11294A"), Color(hex: "0A1B30"),
                Color(hex: "1A3A5C"), Color(hex: "2A6B8A").opacity(0.9), Color(hex: "1A3A5C"),
                Color(hex: "0A1B30"), Color(hex: "0F2844"), Color(hex: "12355A")
            ]
            MeshGradient(width: 3, height: 3, points: points, colors: colors)
        } else {
            LinearGradient(
                colors: [Color(hex: "0A1B30"), Color(hex: "1A3A5C")],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    private func glow(color: Color, size: CGFloat, blur: CGFloat, offsetX: CGFloat, offsetY: CGFloat) -> some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .blur(radius: blur)
            .offset(x: offsetX, y: offsetY)
    }
}

// MARK: - Floating Coins

private struct FloatingCoins: View {
    private struct Coin: Identifiable {
        let id = UUID()
        let x: CGFloat
        let size: CGFloat
        let duration: Double
        let delay: Double
        let symbol: String
        let tint: Color
    }

    private let coins: [Coin] = [
        Coin(x: 0.08, size: 28, duration: 14, delay: 0, symbol: "dollarsign.circle.fill", tint: .bondiGreen),
        Coin(x: 0.22, size: 18, duration: 18, delay: 3, symbol: "percent", tint: .white.opacity(0.7)),
        Coin(x: 0.78, size: 22, duration: 16, delay: 1.5, symbol: "chart.line.uptrend.xyaxis", tint: .bondiGreen),
        Coin(x: 0.9, size: 26, duration: 20, delay: 5, symbol: "dollarsign.circle.fill", tint: .white.opacity(0.6)),
        Coin(x: 0.5, size: 16, duration: 22, delay: 2, symbol: "sparkle", tint: Color(hex: "86EFAC"))
    ]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(coins) { coin in
                    FloatingCoin(coin: coin, bounds: geo.size)
                }
            }
        }
    }

    private struct FloatingCoin: View {
        let coin: Coin
        let bounds: CGSize
        @State private var moved = false

        var body: some View {
            Image(systemName: coin.symbol)
                .font(.system(size: coin.size, weight: .semibold))
                .foregroundStyle(coin.tint)
                .opacity(0.55)
                .shadow(color: coin.tint.opacity(0.4), radius: 8)
                .position(
                    x: coin.x * bounds.width,
                    y: moved ? -coin.size : bounds.height + coin.size
                )
                .onAppear {
                    withAnimation(
                        .linear(duration: coin.duration)
                            .repeatForever(autoreverses: false)
                            .delay(coin.delay)
                    ) {
                        moved = true
                    }
                }
        }
    }
}

// MARK: - Badge

private struct BadgePill: View {
    let icon: String
    let text: String
    let tint: Color

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(tint)
            Text(text)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.9))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(.white.opacity(0.08))
                .overlay(
                    Capsule().stroke(.white.opacity(0.18), lineWidth: 0.8)
                )
        )
        .overlay(
            Capsule()
                .stroke(tint.opacity(0.3), lineWidth: 0.5)
                .blur(radius: 2)
        )
    }
}

#Preview {
    LandingView(onStart: {}, onSignIn: {})
}
