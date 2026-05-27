import XCTest
@testable import Bloom

final class OnboardingStoreTests: XCTestCase {
    private var defaults: UserDefaults!
    private let suiteName = "BloomOnboardingTests"

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: suiteName)
        defaults.removePersistentDomain(forName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        defaults = nil
        super.tearDown()
    }

    // MARK: - Initial state

    func testStartsInWelcomeStepWhenNoPersistedState() {
        let store = OnboardingStore(defaults: defaults)
        XCTAssertEqual(store.state.currentStep, .welcome)
        XCTAssertTrue(store.state.selectedStages.isEmpty)
        XCTAssertFalse(store.state.isCompleted)
    }

    func testRehydratesFromPersistedState() {
        let first = OnboardingStore(defaults: defaults)
        first.toggleStage(.pregnant)
        first.setWeekPregnant(14)
        first.advance()

        let rehydrated = OnboardingStore(defaults: defaults)
        XCTAssertEqual(rehydrated.state.selectedStages, [.pregnant])
        XCTAssertEqual(rehydrated.state.weekPregnant, 14)
        XCTAssertEqual(rehydrated.state.currentStep, .stage)
    }

    // MARK: - Stage selection

    func testToggleStageAddsAndRemoves() {
        let store = OnboardingStore(defaults: defaults)
        store.toggleStage(.pregnant)
        XCTAssertEqual(store.state.selectedStages, [.pregnant])
        store.toggleStage(.toddler)
        XCTAssertEqual(store.state.selectedStages, [.pregnant, .toddler])
        store.toggleStage(.pregnant)
        XCTAssertEqual(store.state.selectedStages, [.toddler])
    }

    func testDeselectingPregnantClearsPregnancyFields() {
        let store = OnboardingStore(defaults: defaults)
        store.toggleStage(.pregnant)
        store.setWeekPregnant(20)
        store.setDueDate(Date(timeIntervalSinceReferenceDate: 100_000))
        store.toggleStage(.pregnant)
        XCTAssertNil(store.state.weekPregnant)
        XCTAssertNil(store.state.dueDate)
    }

    func testDeselectingLastPostnatalStageClearsChildAge() {
        let store = OnboardingStore(defaults: defaults)
        store.toggleStage(.toddler)
        store.setChildAgeMonths(18)
        store.toggleStage(.toddler)
        XCTAssertNil(store.state.childAgeMonths)
    }

    // MARK: - Navigation

    func testAdvanceMovesThroughStepsInOrder() {
        let store = OnboardingStore(defaults: defaults)
        store.toggleStage(.pregnant)
        XCTAssertEqual(store.state.currentStep, .welcome)
        store.advance()
        XCTAssertEqual(store.state.currentStep, .stage)
        store.advance()
        XCTAssertEqual(store.state.currentStep, .personalization)
        store.advance()
        XCTAssertEqual(store.state.currentStep, .topics)
        store.advance()
        XCTAssertEqual(store.state.currentStep, .privacy)
        store.advance() // no-op
        XCTAssertEqual(store.state.currentStep, .privacy)
    }

    func testAdvanceSkipsPersonalizationWhenOnlyTTC() {
        let store = OnboardingStore(defaults: defaults)
        store.toggleStage(.tryingToConceive)
        store.advance() // welcome → stage
        store.advance() // stage → (skip personalization) → topics
        XCTAssertEqual(store.state.currentStep, .topics)
    }

    func testBackMovesPrevious() {
        let store = OnboardingStore(defaults: defaults)
        store.toggleStage(.pregnant)
        store.advance()
        store.advance()
        store.advance()
        store.back()
        XCTAssertEqual(store.state.currentStep, .personalization)
    }

    func testBackSkipsPersonalizationWhenOnlyTTC() {
        let store = OnboardingStore(defaults: defaults)
        store.toggleStage(.tryingToConceive)
        store.advance()
        store.advance()
        XCTAssertEqual(store.state.currentStep, .topics)
        store.back()
        XCTAssertEqual(store.state.currentStep, .stage)
    }

    // MARK: - Topics

    func testToggleTopicAddsAndRemoves() {
        let store = OnboardingStore(defaults: defaults)
        store.toggleTopic("Sleep training")
        XCTAssertEqual(store.state.topics, ["Sleep training"])
        store.toggleTopic("Sleep training")
        XCTAssertTrue(store.state.topics.isEmpty)
    }

    func testSeedRecommendedOnlyAppliesWhenTopicsEmpty() {
        let store = OnboardingStore(defaults: defaults)
        store.toggleStage(.pregnant)
        store.seedRecommendedTopicsIfNeeded()
        XCTAssertTrue(store.state.topics.contains("Morning sickness"))

        // User unchecks something
        store.toggleTopic("Morning sickness")
        let snapshot = store.state.topics

        // Seeding again should NOT overwrite user's edit
        store.seedRecommendedTopicsIfNeeded()
        XCTAssertEqual(store.state.topics, snapshot)
    }

    func testRecommendedTopicsForPregnantHasAtLeastThree() {
        let topics = OnboardingStore.recommendedTopics(for: [.pregnant])
        XCTAssertGreaterThanOrEqual(topics.count, 3)
        XCTAssertLessThanOrEqual(topics.count, 7)
    }

    func testAllTopicsHasAtLeast18Items() {
        XCTAssertGreaterThanOrEqual(OnboardingStore.allTopics.count, 18)
    }

    // MARK: - Completion

    func testCommitMarksCompleted() {
        let store = OnboardingStore(defaults: defaults)
        XCTAssertFalse(store.state.isCompleted)
        store.commit()
        XCTAssertTrue(store.state.isCompleted)

        let rehydrated = OnboardingStore(defaults: defaults)
        XCTAssertTrue(rehydrated.state.isCompleted)
    }

    func testResetClearsEverything() {
        let store = OnboardingStore(defaults: defaults)
        store.toggleStage(.pregnant)
        store.setWeekPregnant(14)
        store.commit()
        store.reset()
        XCTAssertFalse(store.state.isCompleted)
        XCTAssertTrue(store.state.selectedStages.isEmpty)
        XCTAssertNil(store.state.weekPregnant)
        XCTAssertEqual(store.state.currentStep, .welcome)
    }
}
