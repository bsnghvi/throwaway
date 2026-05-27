import Foundation

/// Snapshot of everything onboarding collects. Persisted as a single JSON
/// payload via `OnboardingStore`; the `currentStep` field lets us resume
/// onboarding mid-flow after a force-quit (FR-6).
public struct OnboardingState: Codable, Equatable {
    public var currentStep: OnboardingStep
    public var selectedStages: Set<UserStage>
    public var weekPregnant: Int?
    public var dueDate: Date?
    public var childAgeMonths: Int?
    public var topics: Set<String>
    public var isCompleted: Bool

    public init(
        currentStep: OnboardingStep = .welcome,
        selectedStages: Set<UserStage> = [],
        weekPregnant: Int? = nil,
        dueDate: Date? = nil,
        childAgeMonths: Int? = nil,
        topics: Set<String> = [],
        isCompleted: Bool = false
    ) {
        self.currentStep = currentStep
        self.selectedStages = selectedStages
        self.weekPregnant = weekPregnant
        self.dueDate = dueDate
        self.childAgeMonths = childAgeMonths
        self.topics = topics
        self.isCompleted = isCompleted
    }

    /// Initial blank state used when no persisted payload is found.
    public static let initial = OnboardingState()
}

/// The five visible steps. `personalization` is skipped by the coordinator
/// when only `tryingToConceive` is selected (FR-2).
public enum OnboardingStep: String, Codable, CaseIterable, Comparable {
    case welcome
    case stage
    case personalization
    case topics
    case privacy

    public static func < (lhs: OnboardingStep, rhs: OnboardingStep) -> Bool {
        lhs.orderIndex < rhs.orderIndex
    }

    public var orderIndex: Int {
        switch self {
        case .welcome: return 0
        case .stage: return 1
        case .personalization: return 2
        case .topics: return 3
        case .privacy: return 4
        }
    }

    /// 1-based step number for the progress bar (FR-5).
    public var displayNumber: Int { orderIndex + 1 }

    /// Total visible steps in the flow.
    public static let total = OnboardingStep.allCases.count
}
