import Capacitor
import Intercom
import XCTest

@testable import IntercomPlugin

// the SDK logs an error from the setter itself, and attributes() drops nil values
private class AssignmentRecorder: ICMUserAttributes {
    var assigned: [String] = []

    override var email: String? { didSet { assigned.append("email") } }
    override var userId: String? { didSet { assigned.append("userId") } }
    override var name: String? { didSet { assigned.append("name") } }
    override var phone: String? { didSet { assigned.append("phone") } }
    override var languageOverride: String? { didSet { assigned.append("languageOverride") } }
}

class IntercomTests: XCTestCase {
    private func call(_ options: [String: Any]) -> CAPPluginCall {
        CAPPluginCall(callbackId: "test", methodName: "test", options: options, success: { _, _ in }, error: { _ in })
    }

    func testUpdateUserAssignsOnlyTheReceivedAttributes() {
        let recorder = AssignmentRecorder()

        _ = IntercomPlugin.userAttributes(call(["name": "Jane"]), into: recorder)

        XCTAssertEqual(recorder.assigned, ["name"])
    }

    func testUpdateUserSkipsEmptyAttributes() {
        let recorder = AssignmentRecorder()

        _ = IntercomPlugin.userAttributes(
            call(["email": "", "phone": "", "name": "Jane", "language": ""]), into: recorder)

        XCTAssertEqual(recorder.assigned, ["name"])
    }

    func testUpdateUserAssignsEveryReceivedAttribute() {
        let attributes = IntercomPlugin.userAttributes(
            call(["email": "jane@example.com", "phone": "+33600000000", "name": "Jane", "language": "fr"]))

        XCTAssertEqual(attributes.email, "jane@example.com")
        XCTAssertEqual(attributes.phone, "+33600000000")
        XCTAssertEqual(attributes.name, "Jane")
        XCTAssertEqual(attributes.languageOverride, "fr")
    }

    func testLoginWithUserIdOnlyLeavesTheEmailUnassigned() {
        let recorder = AssignmentRecorder()

        _ = IntercomPlugin.identityAttributes(userId: "42", email: nil, into: recorder)

        XCTAssertEqual(recorder.assigned, ["userId"])
        XCTAssertEqual(recorder.userId, "42")
    }

    func testLoginWithEmailOnlyLeavesTheUserIdUnassigned() {
        let recorder = AssignmentRecorder()

        _ = IntercomPlugin.identityAttributes(userId: nil, email: "jane@example.com", into: recorder)

        XCTAssertEqual(recorder.assigned, ["email"])
        XCTAssertEqual(recorder.email, "jane@example.com")
    }

    func testLoggedInUserIsOnlyTheFlagWhenNobodyIsLoggedIn() {
        let attributes = ICMUserAttributes()
        attributes.userId = "42"

        let user = IntercomPlugin.loggedInUser(isLoggedIn: false, attributes: attributes)

        XCTAssertEqual(user as NSDictionary, ["loggedIn": false])
    }

    func testLoggedInUserCarriesTheIdentifiers() {
        let attributes = ICMUserAttributes()
        attributes.userId = "42"
        attributes.email = "jane@example.com"

        let user = IntercomPlugin.loggedInUser(isLoggedIn: true, attributes: attributes)

        XCTAssertEqual(
            user as NSDictionary, ["loggedIn": true, "userId": "42", "email": "jane@example.com"])
    }

    func testLoggedInUserLeavesOutTheIdentifiersOfAnUnidentifiedUser() {
        let user = IntercomPlugin.loggedInUser(isLoggedIn: true, attributes: ICMUserAttributes())

        XCTAssertEqual(user as NSDictionary, ["loggedIn": true])
    }
}
