import { WebPlugin } from "@capacitor/core";
import {
  IntercomPlugin,
  IntercomUser,
  IntercomSettings,
  IntercomIdentity,
  IntercomEvent,
  IntercomMessage,
  Property,
} from "./definitions";
declare var window: any;

const DELAY_SEND_BATCH_CUSTOM_PROPERTIES = 1000;

export class IntercomWeb extends WebPlugin implements IntercomPlugin {

  customProperties: Record<string, string> = {};
  timeoutCustomProperties: number = null;

  constructor(config: IntercomSettings) {
    super({
      name: "Intercom",
      platforms: ["web"],
    });

    const app_id = config.app_id;

    window.intercomSettings = config;

    (function () {
      var w = window;
      var ic = w.Intercom;
      if (typeof ic === "function") {
        ic("reattach_activator");
        ic("update", w.intercomSettings);
      } else {
        var d = document;
        var i = <any>function () {
          i.c(arguments);
        };
        i.q = [];
        i.c = function (args: any) {
          i.q.push(args);
        };
        w.Intercom = i;
        var l = function () {
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

  registerIdentifiedUser(identity: IntercomIdentity): Promise<void> {
    const { userId, email, userHash } = identity;
    window.Intercom("boot", {
      user_id: userId,
      email,
      user_hash: userHash,
    });
    return;
  }

  registerUnidentifiedUser(): Promise<void> {
    window.Intercom("boot");
    return;
  }

  updateUser(user: IntercomUser): Promise<void> {
    const { email, phone, name, language } = user;
    window.Intercom("update", {
      email,
      phone,
      name,
      language_override: language,
    });
    return;
  }

  // Since there is a limit in Intecom (20 calls per 30 minutes)
  // We need to accumulate those properties and send it in one batch
  setCustomProperty(property: Property): Promise<void> {
    const { key, value } = property;

    this.customProperties[key] = value;

    if(this.timeoutCustomProperties) {
      clearTimeout(this.timeoutCustomProperties)
    }

    this.timeoutCustomProperties = setTimeout(() => {
      window.Intercom("update", this.customProperties);
      this.customProperties = {};
      this.timeoutCustomProperties = null;
    }, DELAY_SEND_BATCH_CUSTOM_PROPERTIES);

    return;
  }

  logout(): Promise<void> {
    window.Intercom("shutdown");
    if(this.timeoutCustomProperties) {
      clearTimeout(this.timeoutCustomProperties)
    }
    return;
  }

  logEvent(event: IntercomEvent): Promise<void> {
    const { name, data } = event;
    window.Intercom("trackEvent", name, data);
    return;
  }

  displayMessenger(): Promise<void> {
    window.Intercom("show");
    return;
  }

  displayMessageComposer(message?: IntercomMessage): Promise<void> {
    const { content } = message;
    if (content) {
      window.Intercom("showNewMessage", content);
    } else {
      window.Intercom("showNewMessage");
    }

    return;
  }

  displayHelpCenter(): Promise<void> {
    window.Intercom("show");
    return;
  }

  hideMessenger(): Promise<void> {
    window.Intercom("hide");
    return;
  }

  displayLauncher(): Promise<void> {
    window.Intercom("update", {
      hide_default_launcher: false,
    });
    return;
  }

  hideLauncher(): Promise<void> {
    window.Intercom("update", {
      hide_default_launcher: true,
    });
    return;
  }
}

// const Intercom = new IntercomWeb();
// export { Intercom };
