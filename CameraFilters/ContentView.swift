import SwiftUI

struct ContentView: View {
    @StateObject private var camera = CameraManager()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let image = camera.filteredImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                VStack(spacing: 12) {
                    ProgressView()
                        .tint(.white)
                    Text("Starting camera…")
                        .foregroundStyle(.white.opacity(0.6))
                        .font(.caption)
                }
            }

            VStack {
                Spacer()
                FilterBar(selectedFilter: $camera.currentFilter)
                    .padding(.bottom, 44)
            }
        }
        .statusBar(hidden: true)
    }
}

// MARK: - Filter selector bar

private struct FilterBar: View {
    @Binding var selectedFilter: FilterType

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(FilterType.allCases) { filter in
                    FilterPill(
                        label: filter.rawValue,
                        isSelected: selectedFilter == filter
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedFilter = filter
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

private struct FilterPill: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(isSelected ? Color.black : Color.white)
                .padding(.horizontal, 18)
                .padding(.vertical, 9)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.white : Color.white.opacity(0.2))
                )
        }
        .buttonStyle(.plain)
    }
}
