import SwiftUI

struct PortfolioAnalysisView: View {
    let investments: [InvestmentRecord]
    let cashBalanceUSD: Double

    @Environment(\.dismiss) private var dismiss
    @State private var service = PortfolioAnalysisService()
    @State private var scrollProxy: ScrollViewProxy?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.bondiSoftBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    messageList
                    Divider().opacity(0.5)
                    suggestionChips
                    inputBar
                }
            }
            .navigationTitle("Análisis IA")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    intelligenceBadge
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") { dismiss() }
                        .font(.bondiSubheadline.weight(.medium))
                        .foregroundStyle(Color.bondiGreenLight)
                }
            }
            .task {
                await service.start(investments: investments, cashBalanceUSD: cashBalanceUSD)
            }
        }
    }

    // MARK: - Header badge
    private var intelligenceBadge: some View {
        HStack(spacing: 5) {
            Image(systemName: "apple.intelligence")
                .font(.caption)
            Text("Apple Intelligence")
                .font(.bondiCaption.weight(.bold))
        }
        .foregroundStyle(Color.bondiGreen)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(Color.bondiCardLight.opacity(0.7))
        )
        .overlay(
            Capsule()
                .stroke(Color.bondiGreen.opacity(0.35), lineWidth: 1)
        )
    }

    // MARK: - Message list
    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    if service.messages.isEmpty {
                        TypingIndicator()
                            .padding(.top, 32)
                    }

                    ForEach(service.messages) { message in
                        MessageBubble(message: message)
                            .id(message.id)
                    }

                    Color.clear
                        .frame(height: 8)
                        .id("bottom")
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .onAppear { scrollProxy = proxy }
            .onChange(of: service.messages.last?.content) { _, _ in
                withAnimation(.easeOut(duration: 0.2)) {
                    proxy.scrollTo("bottom", anchor: .bottom)
                }
            }
            .onChange(of: service.messages.count) { _, _ in
                withAnimation(.easeOut(duration: 0.2)) {
                    proxy.scrollTo("bottom", anchor: .bottom)
                }
            }
        }
    }

    // MARK: - Suggestion chips
    @ViewBuilder
    private var suggestionChips: some View {
        let suggestions = service.suggestedPrompts
        if !suggestions.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(suggestions, id: \.self) { suggestion in
                        Button {
                            Task { await service.submit(text: suggestion) }
                        } label: {
                            Text(suggestion)
                                .font(.bondiCaption.weight(.semibold))
                                .foregroundStyle(Color.bondiGreenLight)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 9)
                                .background(
                                    Capsule()
                                        .fill(Color.bondiCardLight.opacity(0.55))
                                )
                                .overlay(
                                    Capsule()
                                        .stroke(Color.bondiGreen.opacity(0.4), lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                        .disabled(service.isLoading)
                        .opacity(service.isLoading ? 0.5 : 1.0)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }
            .background(Color.bondiSoftBackground)
        }
    }

    // MARK: - Input bar
    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Preguntá sobre tu portafolio…", text: $service.inputText, axis: .vertical)
                .lineLimit(1...4)
                .font(.bondiCallout)
                .foregroundStyle(Color.bondiNavy)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.bondiCardLight.opacity(0.6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.bondiGreen.opacity(0.25), lineWidth: 1)
                )
                .onSubmit { sendMessage() }

            Button(action: sendMessage) {
                Image(systemName: service.isLoading ? "ellipsis" : "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(canSend ? Color.bondiGreen : Color.bondiCardLight)
                    .symbolEffect(.pulse, isActive: service.isLoading)
            }
            .disabled(!canSend)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.bondiSoftBackground)
    }

    private var canSend: Bool {
        !service.isLoading && !service.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func sendMessage() {
        guard canSend else { return }
        Task { await service.sendMessage() }
    }
}

// MARK: - Message Bubble
private struct MessageBubble: View {
    let message: PortfolioAnalysisService.ChatMessage

    var isUser: Bool { message.role == .user }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isUser { Spacer(minLength: 56) }

            if !isUser {
                ZStack {
                    Circle()
                        .fill(Color.bondiCardLight)
                        .frame(width: 28, height: 28)
                        .shadow(color: Color.bondiNavy.opacity(0.05), radius: 4, y: 2)
                    Image(systemName: "sparkles")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.bondiGreen)
                }
            }

            VStack(alignment: isUser ? .trailing : .leading, spacing: 4) {
                bubbleContent
            }

            if isUser {
                Circle()
                    .fill(Color.bondiCardLight)
                    .frame(width: 28, height: 28)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.bondiNavy.opacity(0.6))
                    )
                    .shadow(color: Color.bondiNavy.opacity(0.05), radius: 4, y: 2)
            } else {
                Spacer(minLength: 56)
            }
        }
    }

    @ViewBuilder
    private var bubbleContent: some View {
        if message.content.isEmpty && message.isStreaming {
            TypingIndicator()
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.bondiCardLight)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: Color.bondiNavy.opacity(0.03), radius: 4, y: 2)

        } else if message.isStreaming {
            TimelineView(.periodic(from: .now, by: 0.5)) { context in
                let tick = Int(context.date.timeIntervalSinceReferenceDate * 2)
                let on = tick % 2 == 0
                styledText(cursor: on ? Text(" ▋").foregroundColor(Color.bondiGreen) : Text(""))
            }

        } else {
            styledText(cursor: Text(""))
        }
    }

    private func styledText(cursor: Text) -> some View {
        (Text(message.content) + cursor)
            .font(.bondiCallout)
            .foregroundStyle(isUser ? Color.bondiSoftBackground : Color.bondiNavy)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(isUser ? Color.bondiGreen : Color.bondiCardLight)
            )
    }
}

// MARK: - Typing Indicator
private struct TypingIndicator: View {
    @State private var animating = false

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(Color.bondiGreen.opacity(0.6))
                    .frame(width: 7, height: 7)
                    .offset(y: animating ? -4 : 0)
                    .animation(
                        .easeInOut(duration: 0.45)
                            .repeatForever()
                            .delay(Double(i) * 0.15),
                        value: animating
                    )
            }
        }
        .onAppear { animating = true }
    }
}
