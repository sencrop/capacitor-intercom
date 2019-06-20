import { WebPlugin } from "@capacitor/core";
import { IntercomPlugin, IntercomUser, IntercomSettings, IntercomIdentity } from "./definitions";
declare var window: any;

export class IntercomWeb extends WebPlugin implements IntercomPlugin {
  constructor(config: IntercomSettings) {
    super({
      name: "Intercom",
      platforms: ["web"]
    });

    const app_id = config.app_id;

    window.intercomSettings = {
      hide_default_launcher: true,
      ...config
    };

    (function() {
      var w = window;
      var ic = w.Intercom;
      if (typeof ic === "function") {
        ic("reattach_activator");
        ic("update", w.intercomSettings);
      } else {
        var d = document;
        var i = <any>function() {
          i.c(arguments);
        };
        i.q = [];
        i.c = function(args: any) {
          i.q.push(args);
        };
        w.Intercom = i;
        var l = function() {
          var s = d.createElement("script");
          s.type = "text/javascript";
          s.async = true;
          s.src = `https://widget.intercom.io/widget/${app_id}`;
          var x = d.getElementsByTagName("script")[0];
          x.parentNode.insertBefore(s, x);
        };
        if (w.attachEvent) {
          w.attachEvent("onload", l);
        } else {
          w.addEventListener("load", l, false);
        }
      }
    })();
  }

  registerIdentifiedUser(options: IntercomIdentity): Promise<void> {
    const { userId, email } = options;
    window.Intercom("boot", {
      user_id: userId,
      email: email,
    });
    return;
  }

  updateUser(user: IntercomUser): Promise<void> {
    const { email, phone, name } = user;
    window.Intercom("update", {
      email: email,
      phone: phone,
      name: name
    });
    return;
  }

  displayMessenger(): Promise<void> {
    window.Intercom("show");
    return;
  }

  logout(): Promise<void> {
    window.Intercom("shutdown");
    return;
  }

  registerUnidentifiedUser(): Promise<void> {
    throw new Error("Method not implemented.");
  }

  logEvent(name: string, data: any): Promise<void> {
    console.log(name, data);
    throw new Error("Method not implemented.");
  }

  displayMessageComposer(): Promise<void> {
    throw new Error("Method not implemented.");
  }

  displayHelpCenter(): Promise<void> {
    throw new Error("Method not implemented.");
  }

  hideMessenger(): Promise<void> {
    throw new Error("Method not implemented.");
  }

  displayLauncher(): Promise<void> {
    throw new Error("Method not implemented.");
  }

  hideLauncher(): Promise<void> {
    throw new Error("Method not implemented.");
  }

}

// const Intercom = new IntercomWeb();
// export { Intercom };
