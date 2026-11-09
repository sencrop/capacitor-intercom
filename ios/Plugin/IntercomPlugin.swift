import Capacitor
import Foundation
import Intercom

enum PluginError: Error {
    case initialize
}

/// Please read the Capacitor iOS Plugin Development Guide
/// here: https://capacitorjs.com/docs/plugins/ios
@objc(IntercomPlugin)
public class IntercomPlugin: CAPPlugin {

    @objc func initialize(_ call: CAPPluginCall) {
        let config = getConfig()
        let apiKey = config.getString("ios_apiKey") ?? "ADD_IN_CAPACITOR_CONFIG_JSON"
        let appId = config.getString("appId") ?? "ADD_IN_CAPACITOR_CONFIG_JSON"
        Intercom.setApiKey(apiKey, forAppId: appId)
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.didRegisterWithToken(notification:)),
            name: .capacitorDidRegisterForRemoteNotifications, object: nil)
        call.resolve()
    }

    @objc func didRegisterWithToken(notification: NSNotification) {
        guard let deviceToken = notification.object as? Data else {
            return
        }

        Intercom.setDeviceToken(
            deviceToken,
            completion: { result in
                if case .failure(let error) = result {
                    print("[Intercom SDK] Error while setting device token")
                    print(error)
                }
            })
    }

    @objc func updateUser(_ call: CAPPluginCall) {
        Intercom.updateUser(with: Self.userAttributes(call)) { result in
            switch result {
            case .success:
                call.resolve()
            case .failure(let error):
                call.reject("[Intercom SDK] Error while updating user: \(error.localizedDescription)", nil, error)
            }
        }
    }

    @objc func setCustomAttributes(_ call: CAPPluginCall) {
        guard let attributes = call.getObject("attributes") else {
            call.reject("[Intercom SDK] You must supply the attributes to set")
            return
        }

        let userAttributes = ICMUserAttributes()
        userAttributes.customAttributes = attributes

        Intercom.updateUser(with: userAttributes) { result in
            switch result {
            case .success:
                call.resolve()
            case .failure(let error):
                call.reject(
                    "[Intercom SDK] Error while setting custom attribute(s): \(error.localizedDescription)", nil, error)
            }
        }
    }

    @objc func loginIdentifiedUser(_ call: CAPPluginCall) {
        let userId = Self.nonEmptyString(call, "userId")
        let email = Self.nonEmptyString(call, "email")
        let hmac = Self.nonEmptyString(call, "userHash")

        if userId == nil && email == nil {
            call.reject("[Intercom SDK] You must supply an email, userId or both")
            return
        }

        if let hmac {
            Intercom.setUserHash(hmac)
        }

        Intercom.loginUser(with: Self.identityAttributes(userId: userId, email: email)) { result in
            switch result {
            case .success:
                call.resolve()
            case .failure(let error):
                call.reject("[Intercom SDK] Error while login user: \(error.localizedDescription)", nil, error)
            }
        }
    }

    @objc func loginUnidentifiedUser(_ call: CAPPluginCall) {
        Intercom.loginUnidentifiedUser { result in
            switch result {
            case .success:
                call.resolve()
            case .failure(let error):
                call.reject(
                    "[Intercom SDK] Error while login unidentified user: \(error.localizedDescription)", nil, error)
            }
        }
    }

    @objc func logout(_ call: CAPPluginCall) {
        Intercom.logout()
        call.resolve()
    }

    @objc func logEvent(_ call: CAPPluginCall) {
        guard let eventName = Self.nonEmptyString(call, "name") else {
            call.reject("[Intercom SDK] You must supply an event name")
            return
        }

        if let metaData = call.getObject("data"), !metaData.isEmpty {
            Intercom.logEvent(withName: eventName, metaData: metaData)
        } else {
            Intercom.logEvent(withName: eventName)
        }

        call.resolve()
    }

    @objc func displayMessenger(_ call: CAPPluginCall) {
        Intercom.present()
        call.resolve()
    }

    @objc func displayMessageComposer(_ call: CAPPluginCall) {
        Intercom.presentMessageComposer(call.getString("content"))
        call.resolve()
    }

    @objc func displayHelpCenter(_ call: CAPPluginCall) {
        Intercom.present(.helpCenter)
        call.resolve()
    }

    @objc func displayArticle(_ call: CAPPluginCall) {
        guard let articleId = id(call) else {
            call.reject("[Intercom SDK] You must supply an articleId to display it")
            return
        }

        Intercom.presentContent(.article(id: articleId))
        call.resolve()
    }

    @objc func displaySurvey(_ call: CAPPluginCall) {
        guard let surveyId = id(call) else {
            call.reject("[Intercom SDK] You must supply a surveyId to display it")
            return
        }

        Intercom.presentContent(.survey(id: surveyId))
        call.resolve()
    }

    @objc func hideMessenger(_ call: CAPPluginCall) {
        Intercom.hide()
        call.resolve()
    }

    @objc func displayLauncher(_ call: CAPPluginCall) {
        Intercom.setLauncherVisible(true)
        call.resolve()
    }

    // the SDK logs "'<attribute>' must be an NSString and can't be nil or empty" for each attribute set to nil or ""
    static func userAttributes(
        _ call: CAPPluginCall, into attributes: ICMUserAttributes = ICMUserAttributes()
    ) -> ICMUserAttributes {
        if let email = nonEmptyString(call, "email") {
            attributes.email = email
        }
        if let phone = nonEmptyString(call, "phone") {
            attributes.phone = phone
        }
        if let name = nonEmptyString(call, "name") {
            attributes.name = name
        }
        if let language = nonEmptyString(call, "language") {
            attributes.languageOverride = language
        }
        return attributes
    }

    static func identityAttributes(
        userId: String?, email: String?, into attributes: ICMUserAttributes = ICMUserAttributes()
    ) -> ICMUserAttributes {
        if let userId {
            attributes.userId = userId
        }
        if let email {
            attributes.email = email
        }
        return attributes
    }

    private static func nonEmptyString(_ call: CAPPluginCall, _ key: String) -> String? {
        guard let value = call.getString(key), !value.isEmpty else {
            return nil
        }
        return value
    }

    // the TypeScript API types the id as a number, which call.getString() reads as nil
    private func id(_ call: CAPPluginCall) -> String? {
        if let id = call.getInt("id") {
            return String(id)
        }
        return Self.nonEmptyString(call, "id")
    }

    @objc func hideLauncher(_ call: CAPPluginCall) {
        Intercom.setLauncherVisible(false)
        call.resolve()
    }
}
