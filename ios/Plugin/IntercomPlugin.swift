import Foundation
import Capacitor
import Intercom


enum PluginError: Error {
    case initialize
}

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(IntercomPlugin)
public class IntercomPlugin: CAPPlugin {
    
    
    @objc func initialize(_ call: CAPPluginCall) {
        do {
            let apiKey = getConfigValue("ios_apiKey") as? String ?? "ADD_IN_CAPACITOR_CONFIG_JSON"
            let appId = getConfigValue("appId") as? String ?? "ADD_IN_CAPACITOR_CONFIG_JSON"
            Intercom.setApiKey(apiKey, forAppId: appId)
            NotificationCenter.default.addObserver(self, selector: #selector(self.didRegisterWithToken(notification:)), name: .capacitorDidRegisterForRemoteNotifications, object: nil)
            call.resolve()
        } catch {
            call.reject("[Intercom SDK] Could not initialize the Intercom plugin");
        }
    }
    
    @objc func didRegisterWithToken(notification: NSNotification) {
        guard let deviceToken = notification.object as? Data else {
            return
        }
        
        do {
            Intercom.setDeviceToken(deviceToken) { error in
                print("[Intercom SDK] Error while setting device token")
                print(error ?? "Unknwown error")
            }
        }
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
                call.reject("[Intercom SDK] Error while updating user: ", error.localizedDescription)
            }
        }
    }
    
    @objc func setCustomAttributes(_ call: CAPPluginCall) {
        let attributes = call.getObject("attributes")
        
        let userAttributes = ICMUserAttributes()
        userAttributes.customAttributes = attributes
        
        Intercom.updateUser(with: userAttributes) { result in
            switch result {
            case .success:
                call.resolve()
            case .failure(let error):
                call.reject("[Intercom SDK] Error while setting custom attribute(s): ", error.localizedDescription)
            }
        }
    }
    
    @objc func loginUser(_ call: CAPPluginCall) {
        let userId = call.getString("userId")
        let email = call.getString("email")
        let hmac = call.getString("userHash")
        
        if(userId == nil && email == nil) {
            call.reject("[Intercom SDK] You must supply an email, userId or both")
            return
        }
        
        if hmac != nil {
            Intercom.setUserHash(hmac!)
        }
        
        let attributes = ICMUserAttributes()
        attributes.userId = userId
        attributes.email = email
        
        Intercom.loginUser(with: attributes) { result in
            switch result {
            case .success:
                call.resolve()
            case .failure(let error):
                call.reject("[Intercom SDK] Error while login user: ", error.localizedDescription);
            }
        }
    }
    
    @objc func loginUnidentifiedUser(_ call: CAPPluginCall) {
        Intercom.loginUnidentifiedUser { result in
            switch result {
            case .success:
                call.resolve()
            case .failure(let error):
                call.reject("[Intercom SDK] Error while login unidentified user: ", error.localizedDescription)
            }
        }
    }
    
    @objc func logout(_ call: CAPPluginCall) {
        Intercom.logout()
        call.resolve()
    }
    
    @objc func logEvent(_ call: CAPPluginCall) {
        let eventName = call.getString("name")
        let metaData = call.getObject("data")
        
        if eventName != nil && metaData != nil {
            Intercom.logEvent(withName: eventName!, metaData: metaData!)
            
        } else if eventName != nil {
            Intercom.logEvent(withName: eventName!)
        }
        
        call.resolve()
    }
    
    @objc func displayMessenger(_ call: CAPPluginCall) {
        Intercom.present()
        call.resolve()
    }
    
    @objc func displayMessageComposer(_ call: CAPPluginCall) {
        guard let initialMessage = call.getString("content") else {
            call.reject("[Intercom SDK] You must provide an initial message")
            return
        }
        Intercom.presentMessageComposer(initialMessage)
        call.resolve()
    }
    
    @objc func displayHelpCenter(_ call: CAPPluginCall) {
        Intercom.present(.helpCenter)
        call.resolve()
    }
    
    @objc func displayArticle(_ call: CAPPluginCall) {
        guard let articleId = call.getString("id") else {
            call.reject("[Intercom SDK] You must supply an articleId to display it")
            return
        }
        
        Intercom.presentContent(.article(id: articleId))
        call.resolve()
    }

    @objc func displaySurvey(_ call: CAPPluginCall) {
        guard let surveyId = call.getString("id") else {
            call.reject("[Intercom SDK] You must supply an surveyId to display it")
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
    
    @objc func hideLauncher(_ call: CAPPluginCall) {
        Intercom.setLauncherVisible(false)
        call.resolve()
    }
}
