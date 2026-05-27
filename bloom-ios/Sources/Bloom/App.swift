import SwiftUI

/// Top-level Bloom root. Consumers of the library wire this into their
/// iOS app target — it inspects the persisted `OnboardingStore.state` and
/// either drops the user into onboarding or the placeholder Home.
///
/// Example app integration:
///
/// ```swift
/// @main
/// struct BloomAppEntry: App {
///     var body: some Scene {
///         WindowGroup { BloomRootView() }
///     }
/// }
/// ```
public struct BloomRootView: View {
    @StateObject private var store: OnboardingStore

    public init(defaults: UserDefaults = .standard) {
        _store = StateObject(wrappedValue: OnboardingStore(defaults: defaults))
    }

    public var body: some View {
        Group {
            if store.state.isCompleted {
                HomeStubView(store: store)
                    .transition(.opacity)
            } else {
                OnboardingCoordinator(store: store)
                    .transition(.opacity)
            }
        }
        .animation(.easeOut(duration: 0.4), value: store.state.isCompleted)
    }
}

#if DEBUG
struct BloomRootView_Previews: PreviewProvider {
    static var previews: some View {
        BloomRootView()
    }
}
#endif
