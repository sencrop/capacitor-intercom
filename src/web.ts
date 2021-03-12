import { WebPlugin } from "@capacitor/core";
import {
  IntercomPlugin,
  IntercomUser,
  IntercomSettings,
  IntercomIdentity,
  IntercomEvent,
  IntercomMessage,
  IntercomCustomAttributes,
} from "./definitions";
declare var window: any;

export class IntercomWeb extends WebPlugin implements IntercomPlugin {
  constructor() {
    super({
      name: "Intercom",
      platforms: ["web"],
    });
  }

  initialize(config: IntercomSettings) {
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
          if (x && x.parentNode) {
            x.parentNode.insertBefore(s, x);
          }
        };
        if (w.attachEvent) {
          w.attachEvent("onload", l);
        } else {
          w.addEventListener("load", l, false);
        }
      }
    })();
  }

  async registerIdentifiedUser(identity: IntercomIdentity): Promise<void> {
    const { userId, email, userHash } = identity;
    window.Intercom("boot", {
      user_id: userId,
      email,
      user_hash: userHash,
    });
  }

  async registerUnidentifiedUser(): Promise<void> {
    await window.Intercom("boot");
  }

  async updateUser(user: IntercomUser): Promise<void> {
    const { email, phone, name, language } = user;
    await window.Intercom("update", {
      email,
      phone,
      name,
      language_override: language,
    });
  }

  async setCustomAttributes(payload: IntercomCustomAttributes): Promise<void> {
    await window.Intercom("update", payload.attributes);
  }

  async logout(): Promise<void> {
    await window.Intercom("shutdown");
  }

  async logEvent(event: IntercomEvent): Promise<void> {
    const { name, data } = event;
    await window.Intercom("trackEvent", name, data);
  }

  async displayMessenger(): Promise<void> {
    await window.Intercom("show");
  }

  async displayMessageComposer(message?: IntercomMessage): Promise<void> {
    const { content } = message || {};
    if (content) {
      await window.Intercom("showNewMessage", content);
    } else {
      await window.Intercom("showNewMessage");
    }
  }

  async displayHelpCenter(): Promise<void> {
    window.Intercom("show");
  }

  async hideMessenger(): Promise<void> {
    await window.Intercom("hide");
  }

  async displayLauncher(): Promise<void> {
    await window.Intercom("update", {
      hide_default_launcher: false,
    });
  }

  async hideLauncher(): Promise<void> {
    await window.Intercom("update", {
      hide_default_launcher: true,
    });
  }
}
