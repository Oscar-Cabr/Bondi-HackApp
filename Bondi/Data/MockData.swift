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
            issuerDescription: "Certificados de la Tesorería de la Federación, el instrumento de deuda del gobierno federal mexicano.",
            heroImageName: "bond-hero-mx-cetes"
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
            issuerDescription: "Nota del Tesoro Nacional de Brasil, indexada a la inflación (IPCA).",
            heroImageName: "bond-hero-br-ntnb"
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
            issuerDescription: "Títulos de Tesorería del gobierno colombiano, denominados en pesos.",
            heroImageName: "bond-hero-co-tes"
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
        Bond(
            id: "US-TNOTE-24M",
            name: "T-Note USA",
            country: "Estados Unidos",
            countryFlag: "🇺🇸",
            yieldAnnual: 4.3,
            maturityDate: Calendar.current.date(byAdding: .month, value: 24, to: .now)!,
            minInvestmentUSD: 5,
            riskLevel: .low,
            issuerDescription: "Treasury Note del Departamento del Tesoro de Estados Unidos, considerado uno de los activos más seguros del mundo.",
            heroImageName: "bond-hero-us-tnote"
        ),
        Bond(
            id: "UK-GILT-36M",
            name: "Gilt UK",
            country: "Reino Unido",
            countryFlag: "🇬🇧",
            yieldAnnual: 4.6,
            maturityDate: Calendar.current.date(byAdding: .month, value: 36, to: .now)!,
            minInvestmentUSD: 5,
            riskLevel: .low,
            issuerDescription: "Gilt emitido por HM Treasury del Reino Unido, deuda soberana respaldada por el gobierno británico.",
            heroImageName: "bond-hero-uk-gilt"
        ),
        Bond(
            id: "KR-KTB-30M",
            name: "KTB Corea",
            country: "Corea del Sur",
            countryFlag: "🇰🇷",
            yieldAnnual: 5.2,
            maturityDate: Calendar.current.date(byAdding: .month, value: 30, to: .now)!,
            minInvestmentUSD: 5,
            riskLevel: .low,
            issuerDescription: "Korea Treasury Bond emitido por el Ministerio de Economía y Finanzas de Corea del Sur.",
            heroImageName: "bond-hero-kr-ktb"
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
