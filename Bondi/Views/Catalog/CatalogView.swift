import ClerkKitUI
import SwiftUI

struct CatalogView: View {
    @State private var selectedCountry: String? = nil
    @State private var selectedRisk: Bond.RiskLevel? = nil
    @State private var searchText = ""

    private var filteredBonds: [Bond] {
        MockData.bonds.filter { bond in
            let matchesCountry = selectedCountry == nil || bond.country == selectedCountry
            let matchesRisk = selectedRisk == nil || bond.riskLevel == selectedRisk
            let matchesSearch = searchText.isEmpty
                || bond.name.localizedCaseInsensitiveContains(searchText)
                || bond.country.localizedCaseInsensitiveContains(searchText)
            return matchesCountry && matchesRisk && matchesSearch
        }
    }

    private var countries: [String] {
        Array(Set(MockData.bonds.map(\.country))).sorted()
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.bondiSoftBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Country filter
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                FilterChip(label: "Todos", isSelected: selectedCountry == nil) {
                                    selectedCountry = nil
                                }
                                ForEach(countries, id: \.self) { country in
                                    FilterChip(label: country, isSelected: selectedCountry == country) {
                                        selectedCountry = selectedCountry == country ? nil : country
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        // Risk filter
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                FilterChip(label: "Todo riesgo", isSelected: selectedRisk == nil) {
                                    selectedRisk = nil
                                }
                                ForEach(Bond.RiskLevel.allCases, id: \.self) { risk in
                                    FilterChip(label: "Riesgo \(risk.rawValue)", isSelected: selectedRisk == risk) {
                                        selectedRisk = selectedRisk == risk ? nil : risk
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        if filteredBonds.isEmpty {
                            ContentUnavailableView(
                                "Sin resultados",
                                systemImage: "doc.text.magnifyingglass",
                                description: Text("Prueba cambiando los filtros")
                            )
                            .padding(.top, 40)
                            .frame(maxWidth: .infinity)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredBonds) { bond in
                                    NavigationLink(destination: BondDetailView(bond: bond)) {
                                        BondCardView(bond: bond)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Bondi")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Buscar bonos")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    UserButton()
                        .environment(\.clerkTheme, .bondi)
                }
            }
        }
    .preferredColorScheme(.dark)
    }
}

private struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(label, action: action)
            .buttonStyle(BondiChipButtonStyle(isSelected: isSelected))
    }
}
