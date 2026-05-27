import XCTest
@testable import Bloom

final class PackageTests: XCTestCase {
    func testModuleIsImportableAndVersionIsSet() {
        XCTAssertFalse(Bloom.version.isEmpty)
    }
}
