import SwiftUI

struct ContentView: View {
    @StateObject private var camera = CameraManager()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            switch camera.permissionStatus {
            case .denied:
                PermissionDeniedView()
            case .notDetermined:
                VStack(spacing: 12) {
                    ProgressView()
                        .tint(.white)
                    Text("Requesting camera access…")
                        .foregroundStyle(.white.opacity(0.6))
                        .font(.caption)
                }
            case .granted:
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
            }

            if camera.permissionStatus == .granted {
                VStack {
                    Spacer()
                    FilterBar(selectedFilter: $camera.currentFilter)
                        .padding(.bottom, 44)
                }
            }
        }
        .statusBar(hidden: true)
    }
}

// MARK: - Permission denied view

private struct PermissionDeniedView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.slash.fill")
                .font(.system(size: 52))
                .foregroundStyle(.white.opacity(0.8))
            Text("Camera Access Required")
                .font(.title3.bold())
                .foregroundStyle(.white)
            Text("Please enable camera access in\nSettings to use this app.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))
                .multilineTextAlignment(.center)
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .font(.subheadline.bold())
            .foregroundStyle(.black)
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            .background(Capsule().fill(.white))
            .padding(.top, 8)
        }
        .padding(32)
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
