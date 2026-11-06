import { WebPlugin } from "@capacitor/core";

import type {
  Intercom,
  IntercomArticle,
  IntercomCustomAttributes,
  IntercomEvent,
  IntercomIdentity,
  IntercomMessage,
  IntercomPlugin,
  IntercomSettings,
  IntercomSurvey,
  IntercomUser,
} from "./definitions";

declare global {
  interface Window {
    Intercom?: Intercom;
    intercomSettings?: IntercomSettings;
    // oxlint-disable-next-line typescript/no-explicit-any -- part of the published Window augmentation
    attachEvent?: any;
  }
}

export class IntercomWeb extends WebPlugin implements IntercomPlugin {
  initialize(config?: IntercomSettings): void {
    const app_id = config?.app_id;

    if (!app_id) {
      // oxlint-disable-next-line no-console -- tells the app developer why the widget does not load
      console.error("Intercom app_id is not defined");
      return;
    }
    window.intercomSettings = config;
    try {
      (function () {
        const w = window;
        const ic = w.Intercom;
        if (typeof ic === "function") {
          ic("reattach_activator");
          ic("update", w.intercomSettings);
        } else {
          const d = document;
          // oxlint-disable-next-line typescript/no-explicit-any -- Intercom's loader snippet, a function carrying a queue
          const i = <any>function () {
            // eslint-disable-next-line prefer-rest-params
            i.c(arguments);
          };
          i.q = [];
          i.c = function (args: unknown) {
            i.q.push(args);
          };
          w.Intercom = i;
          const l = function () {
            const s = d.createElement("script");
            s.type = "text/javascript";
            s.async = true;
            s.src = `https://widget.intercom.io/widget/${app_id}`;
            const x = d.getElementsByTagName("script")[0];
            if (x?.parentNode) {
              x.parentNode.insertBefore(s, x);
            }
          };
          if (document.readyState === "complete") {
            l();
          } else if (w.attachEvent) {
            w.attachEvent("onload", l);
          } else {
            w.addEventListener("load", l, false);
          }
        }
      })();
    } catch {
      throw Error("Could not initialize the Intercom plugin.");
    }
  }

  async loginIdentifiedUser(identity: IntercomIdentity): Promise<void> {
    const { userId, email, userHash } = identity;
    if (!userId && !email) {
      throw new Error(
        "[Intercom SDK] You must supply an email, userId or both"
      );
    }
    if (window.Intercom) {
      window.Intercom("boot", {
        user_id: userId,
        email,
        user_hash: userHash,
      });
    }
  }

  async loginUnidentifiedUser(): Promise<void> {
    if (window.Intercom) {
      await window.Intercom("boot", {});
    }
  }

  async updateUser(user: IntercomUser): Promise<void> {
    const { email, phone, name, language } = user;
    if (window.Intercom) {
      await window.Intercom("update", {
        email,
        phone,
        name,
        language_override: language,
      });
    }
  }

  async setCustomAttributes(payload: IntercomCustomAttributes): Promise<void> {
    if (!payload?.attributes) {
      throw new Error("[Intercom SDK] You must supply the attributes to set");
    }
    if (window.Intercom) {
      await window.Intercom("update", payload.attributes);
    }
  }

  async logout(): Promise<void> {
    if (window.Intercom) {
      await window.Intercom("shutdown");
    }
  }

  async logEvent(event: IntercomEvent): Promise<void> {
    const { name, data } = event;
    if (!name) {
      throw new Error("[Intercom SDK] You must supply an event name");
    }
    if (window.Intercom) {
      await window.Intercom("trackEvent", name, data);
    }
  }

  async displayMessenger(): Promise<void> {
    if (window.Intercom) {
      await window.Intercom("show");
    }
  }

  async displayArticle(article: IntercomArticle): Promise<void> {
    if (article?.id == null) {
      throw new Error(
        "[Intercom SDK] You must supply an articleId to display it"
      );
    }
    if (window.Intercom) {
      await window.Intercom("showArticle", article.id);
    }
  }

  async displayMessageComposer(message?: IntercomMessage): Promise<void> {
    const { content } = message || {};
    if (window.Intercom) {
      if (content) {
        await window.Intercom("showNewMessage", content);
      } else {
        await window.Intercom("showNewMessage");
      }
    }
  }

  async displayHelpCenter(): Promise<void> {
    if (window.Intercom) {
      window.Intercom("show");
    }
  }

  async hideMessenger(): Promise<void> {
    if (window.Intercom) {
      await window.Intercom("hide");
    }
  }

  async displayLauncher(): Promise<void> {
    if (window.Intercom) {
      await window.Intercom("update", {
        hide_default_launcher: false,
      });
    }
  }

  async hideLauncher(): Promise<void> {
    if (window.Intercom) {
      await window.Intercom("update", {
        hide_default_launcher: true,
      });
    }
  }

  async displaySurvey(survey: IntercomSurvey): Promise<void> {
    if (survey?.id == null) {
      throw new Error(
        "[Intercom SDK] You must supply a surveyId to display it"
      );
    }
    if (window.Intercom) {
      await window.Intercom("startSurvey", survey.id);
    }
  }
}
