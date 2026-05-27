import Foundation

/// The five life-stages a Bloom user can identify with. Multi-select is
/// allowed at the screen layer; the enum itself is just the option set's
/// member.
public enum UserStage: String, CaseIterable, Codable, Identifiable, Hashable {
    case tryingToConceive = "tryingToConceive"
    case pregnant = "pregnant"
    case newborn = "newborn"
    case toddler = "toddler"
    case beyond = "beyond"

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .tryingToConceive: return "Trying to conceive"
        case .pregnant: return "Pregnant"
        case .newborn: return "Newborn (0–3 months)"
        case .toddler: return "Toddler (1–3 years)"
        case .beyond: return "Beyond toddler"
        }
    }

    public var subtitle: String {
        switch self {
        case .tryingToConceive: return "Planning a family"
        case .pregnant: return "Awaiting a baby"
        case .newborn: return "The first 3 months"
        case .toddler: return "The toddler years"
        case .beyond: return "Bigger kids, bigger questions"
        }
    }

    public var iconName: String {
        switch self {
        case .tryingToConceive: return "heart.fill"
        case .pregnant: return "figure.stand"
        case .newborn: return "figure.and.child.holdinghands"
        case .toddler: return "figure.walk.motion"
        case .beyond: return "figure.run"
        }
    }

    /// Does this stage indicate the user has at least one child already?
    public var isPostnatal: Bool {
        switch self {
        case .newborn, .toddler, .beyond: return true
        default: return false
        }
    }
}
