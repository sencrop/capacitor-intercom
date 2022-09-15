import { WebPlugin } from '@capacitor/core';

import type {
  IntercomPlugin,
  IntercomUser,
  IntercomSettings,
  IntercomIdentity,
  IntercomEvent,
  IntercomMessage,
  IntercomCustomAttributes,
  Intercom,
  IntercomArticle,
} from './definitions';

declare global {
  interface Window {
    Intercom?: Intercom;
    intercomSettings?: IntercomSettings;
    attachEvent?: any;
  }
}

export class IntercomWeb extends WebPlugin implements IntercomPlugin {
  initialize(config?: IntercomSettings): void {
    const app_id = config?.app_id;

    if (!app_id) {
      console.error('Intercom app_id is not defined');
      return;
    }
    window.intercomSettings = config;
    try {
      (function () {
        const w = window;
        const ic = w.Intercom;
        if (typeof ic === 'function') {
          ic('reattach_activator');
          ic('update', w.intercomSettings);
        } else {
          const d = document;
          // eslint-disable-next-line @typescript-eslint/consistent-type-assertions
          const i = <any>function () {
            // eslint-disable-next-line prefer-rest-params
            i.c(arguments);
          };
          i.q = [];
          i.c = function (args: any) {
            i.q.push(args);
          };
          w.Intercom = i;
          const l = function () {
            const s = d.createElement('script');
            s.type = 'text/javascript';
            s.async = true;
            s.src = `https://widget.intercom.io/widget/${app_id}`;
            const x = d.getElementsByTagName('script')[0];
            if (x?.parentNode) {
              x.parentNode.insertBefore(s, x);
            }
          };
          if (w.attachEvent) {
            w.attachEvent('onload', l);
          } else {
            w.addEventListener('load', l, false);
          }
        }
      })();
    } catch (err) {
      throw Error('Could not initialize the Intercom plugin.');
    }
  }

  async loginIdentifiedUser(identity: IntercomIdentity): Promise<void> {
    const { userId, email, userHash } = identity;
    if (window.Intercom) {
      window.Intercom('boot', {
        user_id: userId,
        email,
        user_hash: userHash,
      });
    }
  }

  async loginUnidentifiedUser(): Promise<void> {
    if (window.Intercom) {
      await window.Intercom('boot', {});
    }
  }

  async updateUser(user: IntercomUser): Promise<void> {
    const { email, phone, name, language } = user;
    if (window.Intercom) {
      await window.Intercom('update', {
        email,
        phone,
        name,
        language_override: language,
      });
    }
  }

  async setCustomAttributes(payload: IntercomCustomAttributes): Promise<void> {
    if (window.Intercom) {
      await window.Intercom('update', payload.attributes);
    }
  }

  async logout(): Promise<void> {
    if (window.Intercom) {
      await window.Intercom('shutdown');
    }
  }

  async logEvent(event: IntercomEvent): Promise<void> {
    const { name, data } = event;
    if (window.Intercom) {
      await window.Intercom('trackEvent', name, data);
    }
  }

  async displayMessenger(): Promise<void> {
    if (window.Intercom) {
      await window.Intercom('show');
    }
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  async displayArticle(_article: IntercomArticle): Promise<void> {
    throw this.unimplemented('[Intercom] displayArticle is not implemented on web');
  }

  async displayMessageComposer(message?: IntercomMessage): Promise<void> {
    const { content } = message || {};
    if (window.Intercom) {
      if (content) {
        await window.Intercom('showNewMessage', content);
      } else {
        await window.Intercom('showNewMessage');
      }
    }
  }

  async displayHelpCenter(): Promise<void> {
    if (window.Intercom) {
      window.Intercom('show');
    }
  }

  async hideMessenger(): Promise<void> {
    if (window.Intercom) {
      await window.Intercom('hide');
    }
  }

  async displayLauncher(): Promise<void> {
    if (window.Intercom) {
      await window.Intercom('update', {
        hide_default_launcher: false,
      });
    }
  }

  async hideLauncher(): Promise<void> {
    if (window.Intercom) {
      await window.Intercom('update', {
        hide_default_launcher: true,
      });
    }
  }
}
