import Foundation

enum MockData {
    static let bonds: [Bond] = [
        Bond(
            id: "MX-CETES-18M",
            name: "CETES México",
            country: "México",
            countryFlag: "🇲🇽",
            yieldAnnual: 8.2,
            maturityDate: Calendar.current.date(byAdding: .month, value: 18, to: .now)!,
            minInvestmentUSD: 5,
            riskLevel: .low,
            issuerDescription: "Certificados de la Tesorería de la Federación, el instrumento de deuda del gobierno federal mexicano."
        ),
        Bond(
            id: "CL-BCT-12M",
            name: "Bono Chile",
            country: "Chile",
            countryFlag: "🇨🇱",
            yieldAnnual: 6.8,
            maturityDate: Calendar.current.date(byAdding: .month, value: 12, to: .now)!,
            minInvestmentUSD: 5,
            riskLevel: .low,
            issuerDescription: "Bono soberano de la Tesorería General de la República de Chile."
        ),
        Bond(
            id: "BR-NTN-24M",
            name: "NTN-B Brasil",
            country: "Brasil",
            countryFlag: "🇧🇷",
            yieldAnnual: 11.4,
            maturityDate: Calendar.current.date(byAdding: .month, value: 24, to: .now)!,
            minInvestmentUSD: 5,
            riskLevel: .medium,
            issuerDescription: "Nota del Tesoro Nacional de Brasil, indexada a la inflación (IPCA)."
        ),
        Bond(
            id: "CO-TES-20M",
            name: "TES Colombia",
            country: "Colombia",
            countryFlag: "🇨🇴",
            yieldAnnual: 9.5,
            maturityDate: Calendar.current.date(byAdding: .month, value: 20, to: .now)!,
            minInvestmentUSD: 5,
            riskLevel: .medium,
            issuerDescription: "Títulos de Tesorería del gobierno colombiano, denominados en pesos."
        ),
        Bond(
            id: "PE-SOB-15M",
            name: "Bono Perú",
            country: "Perú",
            countryFlag: "🇵🇪",
            yieldAnnual: 7.1,
            maturityDate: Calendar.current.date(byAdding: .month, value: 15, to: .now)!,
            minInvestmentUSD: 5,
            riskLevel: .low,
            issuerDescription: "Bonos soberanos del Ministerio de Economía y Finanzas del Perú."
        ),
    ]

    static let investments: [Investment] = [
        Investment(
            id: UUID(),
            bond: bonds[0],
            amountUSD: 50,
            feeUSD: 0.50,
            investedAt: Calendar.current.date(byAdding: .day, value: -60, to: .now)!
        ),
        Investment(
            id: UUID(),
            bond: bonds[1],
            amountUSD: 30,
            feeUSD: 0.30,
            investedAt: Calendar.current.date(byAdding: .day, value: -30, to: .now)!
        ),
    ]
}
