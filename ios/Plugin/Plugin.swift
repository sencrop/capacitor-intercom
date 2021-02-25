import Foundation
import Capacitor
import Intercom

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(IntercomPlugin)
public class IntercomPlugin: CAPPlugin {
    
    public override func load() {
        let apiKey = getConfigValue("ios_apiKey") as? String ?? "ADD_IN_CAPACITOR_CONFIG_JSON"
        let appId = getConfigValue("appId") as? String ?? "ADD_IN_CAPACITOR_CONFIG_JSON"
        Intercom.setApiKey(apiKey, forAppId: appId)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didRegisterWithToken(notification:)), name: Notification.Name(CAPNotifications.DidRegisterForRemoteNotificationsWithDeviceToken.name()), object: nil)
    }
    
    @objc func didRegisterWithToken(notification: NSNotification) {
        guard let deviceToken = notification.object as? Data else {
            return
        }
        Intercom.setDeviceToken(deviceToken)
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

        Intercom.updateUser(userAttributes)
        call.success()
    }
    
    @objc func setCustomAttributes(_ call: CAPPluginCall) {
        let attributes = call.getObject("attributes")

        let userAttributes = ICMUserAttributes()
        userAttributes.customAttributes = attributes
        Intercom.updateUser(userAttributes)

        call.success()
    }
    
    @objc func registerIdentifiedUser(_ call: CAPPluginCall) {
        let userId = call.getString("userId")
        let email = call.getString("email")
        let hmac = call.getString("userHash")
      
        if (userId != nil && email != nil) {
            Intercom.registerUser(withUserId: userId!, email: email!)
        }else if (userId != nil) {
            Intercom.registerUser(withUserId: userId!)
        }else if (email != nil) {
            Intercom.registerUser(withEmail: email!)
        }else{
            call.error("No user registered. You must supply an email, userId or both")
        }

        if (hmac != nil) {
            Intercom.setUserHash(hmac!)
        }

        call.success()
    }
    
    @objc func registerUnidentifiedUser(_ call: CAPPluginCall) {
        Intercom.registerUnidentifiedUser()
        call.success()
    }
    
    @objc func logout(_ call: CAPPluginCall) {
        Intercom.logout()
        call.success()
    }
    
    @objc func logEvent(_ call: CAPPluginCall) {
        let eventName = call.getString("name")
        let metaData = call.getObject("data")
        
        if (eventName != nil && metaData != nil) {
            Intercom.logEvent(withName: eventName!, metaData: metaData!)
            
        }else if (eventName != nil) {
            Intercom.logEvent(withName: eventName!)
        }
        
        call.success()
    }
    
    @objc func displayMessenger(_ call: CAPPluginCall) {
        Intercom.presentMessenger();
        call.success()
    }
    
    @objc func displayMessageComposer(_ call: CAPPluginCall) {
        guard let initialMessage = call.getString("content") else {
            call.error("Enter an initial message")
            return
        }
        Intercom.presentMessageComposer(initialMessage);
        call.success()
    }
    
    @objc func displayHelpCenter(_ call: CAPPluginCall) {
        Intercom.presentHelpCenter()
        call.success()
    }
    
    @objc func hideMessenger(_ call: CAPPluginCall) {
        Intercom.hideMessenger()
        call.success()
    }
    
    @objc func displayLauncher(_ call: CAPPluginCall) {
        Intercom.setLauncherVisible(true)
        call.success()
    }
    
    @objc func hideLauncher(_ call: CAPPluginCall) {
        Intercom.setLauncherVisible(false)
        call.success()
    }
}
