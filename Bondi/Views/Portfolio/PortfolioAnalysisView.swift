import SwiftUI

struct PortfolioAnalysisView: View {
    let investments: [InvestmentRecord]

    @Environment(\.dismiss) private var dismiss
    @State private var service = PortfolioAnalysisService()
    @State private var scrollProxy: ScrollViewProxy?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                messageList
                Divider()
                inputBar
            }
            .navigationTitle("Análisis IA")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    intelligenceBadge
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") { dismiss() }
                        .foregroundStyle(Color.bondiNavy)
                }
            }
            .task {
                await service.start(investments: investments)
            }
        }
    }

    // MARK: - Header badge

    private var intelligenceBadge: some View {
        HStack(spacing: 5) {
            Image(systemName: "apple.intelligence")
                .font(.caption)
            Text("Apple Intelligence")
                .font(.caption.bold())
        }
        .foregroundStyle(Color.bondiGreen)
        .padding(.horizontal, 9)
        .padding(.vertical, 5)
        .background(Color.bondiGreen.opacity(0.12))
        .clipShape(Capsule())
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

    // MARK: - Input bar

    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Preguntá sobre tu portafolio…", text: $service.inputText, axis: .vertical)
                .lineLimit(1...4)
                .font(.callout)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .onSubmit { sendMessage() }

            Button(action: sendMessage) {
                Image(systemName: service.isLoading ? "ellipsis" : "arrow.up.circle.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(canSend ? Color.bondiGreen : Color(.tertiaryLabel))
                    .symbolEffect(.pulse, isActive: service.isLoading)
            }
            .disabled(!canSend)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.regularMaterial)
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

    @State private var cursorVisible = true

    var isUser: Bool { message.role == .user }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isUser { Spacer(minLength: 56) }

            if !isUser {
                // Avatar
                ZStack {
                    Circle()
                        .fill(Color.bondiNavy)
                        .frame(width: 28, height: 28)
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
                    .fill(Color(.tertiarySystemFill))
                    .frame(width: 28, height: 28)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    )
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
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        } else {
            (Text(message.content) + cursorText)
                .font(.callout)
                .foregroundStyle(isUser ? .white : .primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(isUser ? Color.bondiNavy : Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .onAppear {
                    guard message.isStreaming else { return }
                    withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                        cursorVisible = false
                    }
                }
        }
    }

    private var cursorText: Text {
        guard message.isStreaming else { return Text("") }
        return Text(cursorVisible ? " ▋" : "  ")
            .foregroundColor(Color.bondiGreen)
    }
}

// MARK: - Typing Indicator (3 bouncing dots)

private struct TypingIndicator: View {
    @State private var animating = false

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(Color.bondiNavy.opacity(0.5))
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
