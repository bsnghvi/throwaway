import Foundation
import SwiftUI
import Combine

/// Owns the onboarding state and persists every mutation to UserDefaults.
/// Views observe the published `state` and call `advance()`, `back()`,
/// `commit()`, or any of the typed mutators. A single JSON blob is used
/// so we can evolve the schema without juggling per-field keys.
public final class OnboardingStore: ObservableObject {
    public static let storageKey = "bloom.onboarding.state.v1"

    @Published public private(set) var state: OnboardingState

    private let defaults: UserDefaults

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: Self.storageKey),
           let decoded = try? JSONDecoder().decode(OnboardingState.self, from: data) {
            self.state = decoded
        } else {
            self.state = .initial
        }
    }

    // MARK: - Stage mutation

    public func toggleStage(_ stage: UserStage) {
        var updated = state.selectedStages
        if updated.contains(stage) {
            updated.remove(stage)
        } else {
            updated.insert(stage)
        }
        state.selectedStages = updated
        // Drop personalization values that no longer apply.
        if !updated.contains(.pregnant) {
            state.weekPregnant = nil
            state.dueDate = nil
        }
        if !updated.contains(where: { $0.isPostnatal }) {
            state.childAgeMonths = nil
        }
        persist()
    }

    public func setWeekPregnant(_ week: Int?) {
        state.weekPregnant = week
        persist()
    }

    public func setDueDate(_ date: Date?) {
        state.dueDate = date
        persist()
    }

    public func setChildAgeMonths(_ months: Int?) {
        state.childAgeMonths = months
        persist()
    }

    public func toggleTopic(_ topic: String) {
        if state.topics.contains(topic) {
            state.topics.remove(topic)
        } else {
            state.topics.insert(topic)
        }
        persist()
    }

    /// Pre-populate the topics set with the recommended slugs for the
    /// currently selected stages (FR-3). Only fires when the topics set
    /// is empty, so user choices aren't overwritten by stage edits.
    public func seedRecommendedTopicsIfNeeded() {
        guard state.topics.isEmpty else { return }
        state.topics = Self.recommendedTopics(for: state.selectedStages)
        persist()
    }

    // MARK: - Navigation

    /// Move to the next visible step. Skips `personalization` when only
    /// "trying to conceive" is selected (FR-2).
    public func advance() {
        guard let next = nextStep(after: state.currentStep) else { return }
        state.currentStep = next
        persist()
    }

    public func back() {
        guard let previous = previousStep(before: state.currentStep) else { return }
        state.currentStep = previous
        persist()
    }

    /// Mark the user as having finished onboarding (PrivacyView CTA).
    public func commit() {
        state.isCompleted = true
        persist()
    }

    /// Reset everything. Used by debug menus / tests.
    public func reset() {
        state = .initial
        persist()
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(state) else { return }
        defaults.set(data, forKey: Self.storageKey)
    }

    // MARK: - Step navigation logic

    private func nextStep(after step: OnboardingStep) -> OnboardingStep? {
        let ordered = OnboardingStep.allCases
        guard let idx = ordered.firstIndex(of: step), idx + 1 < ordered.count else { return nil }
        var candidate = ordered[idx + 1]
        while shouldSkip(candidate) {
            guard let nextIdx = ordered.firstIndex(of: candidate), nextIdx + 1 < ordered.count else { return nil }
            candidate = ordered[nextIdx + 1]
        }
        return candidate
    }

    private func previousStep(before step: OnboardingStep) -> OnboardingStep? {
        let ordered = OnboardingStep.allCases
        guard let idx = ordered.firstIndex(of: step), idx > 0 else { return nil }
        var candidate = ordered[idx - 1]
        while shouldSkip(candidate) {
            guard let prevIdx = ordered.firstIndex(of: candidate), prevIdx > 0 else { return nil }
            candidate = ordered[prevIdx - 1]
        }
        return candidate
    }

    /// Personalization is skipped iff the only selected stage is TTC.
    public func shouldSkip(_ step: OnboardingStep) -> Bool {
        guard step == .personalization else { return false }
        return state.selectedStages == [.tryingToConceive]
    }

    // MARK: - Topic catalogue + recommendations

    /// 18+ topic slugs surfaced on the Topics step (FR-3).
    public static let allTopics: [String] = [
        "Fertility", "Conception tips", "Morning sickness", "Birth preparation",
        "Hospital bag", "Breastfeeding", "Bottle feeding", "Sleep training",
        "Postpartum recovery", "Newborn care", "Vaccinations", "Weaning",
        "Toddler tantrums", "Speech & language", "Mental health", "Nutrition",
        "Exercise", "Partner support", "Childcare", "Returning to work"
    ]

    /// Stage → recommended topic slug map. Pre-selects 3-5 per stage.
    public static func recommendedTopics(for stages: Set<UserStage>) -> Set<String> {
        var topics = Set<String>()
        for stage in stages {
            switch stage {
            case .tryingToConceive:
                topics.formUnion(["Fertility", "Conception tips", "Mental health", "Nutrition"])
            case .pregnant:
                topics.formUnion(["Morning sickness", "Birth preparation", "Hospital bag", "Mental health", "Nutrition"])
            case .newborn:
                topics.formUnion(["Breastfeeding", "Bottle feeding", "Sleep training", "Postpartum recovery", "Newborn care"])
            case .toddler:
                topics.formUnion(["Sleep training", "Toddler tantrums", "Speech & language", "Nutrition"])
            case .beyond:
                topics.formUnion(["Childcare", "Mental health", "Nutrition", "Returning to work"])
            }
        }
        return topics
    }
}
