import Foundation

enum FilterType: String, CaseIterable, Identifiable {
    case original = "Original"
    case sepia    = "Sepia"
    case noir     = "Noir"
    case fade     = "Fade"

    var id: String { rawValue }

    var ciFilterName: String? {
        switch self {
        case .original: return nil
        case .sepia:    return "CISepiaTone"
        case .noir:     return "CIPhotoEffectNoir"
        case .fade:     return "CIPhotoEffectFade"
        }
    }
}
