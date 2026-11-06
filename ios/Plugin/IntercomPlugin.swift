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
        do {
            let apiKey = getConfigValue("ios_apiKey") as? String ?? "ADD_IN_CAPACITOR_CONFIG_JSON"
            let appId = getConfigValue("appId") as? String ?? "ADD_IN_CAPACITOR_CONFIG_JSON"
            Intercom.setApiKey(apiKey, forAppId: appId)
            NotificationCenter.default.addObserver(
                self, selector: #selector(self.didRegisterWithToken(notification:)),
                name: .capacitorDidRegisterForRemoteNotifications, object: nil)
            call.resolve()
        } catch {
            call.reject("[Intercom SDK] Could not initialize the Intercom plugin")
        }
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
        let email = call.getString("email")
        let phone = call.getString("phone")
        let name = call.getString("name")
        let language = call.getString("language")

        let userAttributes = ICMUserAttributes()
        userAttributes.email = email
        userAttributes.phone = phone
        userAttributes.name = name
        userAttributes.languageOverride = language

        Intercom.updateUser(with: userAttributes) { result in
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
        let userId = nonEmptyString(call, "userId")
        let email = nonEmptyString(call, "email")
        let hmac = nonEmptyString(call, "userHash")

        if userId == nil && email == nil {
            call.reject("[Intercom SDK] You must supply an email, userId or both")
            return
        }

        if let hmac {
            Intercom.setUserHash(hmac)
        }

        let attributes = ICMUserAttributes()
        attributes.userId = userId
        attributes.email = email

        Intercom.loginUser(with: attributes) { result in
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
        guard let eventName = nonEmptyString(call, "name") else {
            call.reject("[Intercom SDK] You must supply an event name")
            return
        }

        if let metaData = call.getObject("data") {
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

    private func nonEmptyString(_ call: CAPPluginCall, _ key: String) -> String? {
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
        return nonEmptyString(call, "id")
    }

    @objc func hideLauncher(_ call: CAPPluginCall) {
        Intercom.setLauncherVisible(false)
        call.resolve()
    }
}
