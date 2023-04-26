// Type definitions for non-npm package Intercom Web API 2.8
// Project: https://docs.intercom.io/
//            configure-intercom-for-your-product-or-site/
//            customize-the-intercom-messenger/the-intercom-javascript-api
// Definitions by: Andrew Fong <https://github.com/fongandrew>
//                 Samer Albahra <https://github.com/salbahra>
//                 Onat Yigit Mercan <https://github.com/onatm>
//                 Chia-Lun Wu <https://github.com/bingo4508>
// Definitions: https://github.com/DefinitelyTyped/DefinitelyTyped
export interface IntercomSettings {
  // Messenger attributes
  app_id?: string | undefined;
  api_base?: string | undefined;
  alignment?: string | undefined;
  custom_launcher_selector?: string | undefined;
  hide_default_launcher?: boolean | undefined;
  horizontal_padding?: number | undefined;
  session_duration?: number | undefined;
  vertical_padding?: number | undefined;
  action_color?: string | undefined;
  background_color?: string | undefined;

  // Data attributes
  email?: string | undefined;
  phone?: string | undefined;
  created_at?: number | undefined;
  name?: string | undefined;
  user_id?: string | undefined;
  user_hash?: string | undefined;
  unsubscribed_from_emails?: boolean | undefined;
  language_override?: string | undefined;
  utm_campaign?: string | undefined;
  utm_content?: string | undefined;
  utm_medium?: string | undefined;
  utm_source?: string | undefined;
  utm_term?: string | undefined;
  company?: IntercomCompany | undefined;
  companies?: IntercomCompany[] | undefined;
  avatar?: IntercomAvatar | undefined;

  // Custom attributes
  [custom_attribute: string]: IntercomCompany | IntercomCompany[] | IntercomAvatar | IntercomCustomAttribute;
}

interface IntercomCompany {
  name: string;
  id?: string | number | undefined;
  company_id?: string | number | undefined;
  created_at?: number | undefined;
  remote_created_at?: number | undefined;
  plan?: string | undefined;
  monthly_spend?: number | undefined;
  user_count?: number | undefined;
  size?: number | undefined;
  website?: string | undefined;
  industry?: string | undefined;
  [custom_attribute: string]: IntercomCustomAttribute;
}

interface IntercomAvatar {
  type: 'avatar';
  image_url: string;
}

type IntercomCustomAttribute = string | number | boolean | null | undefined;

interface IntercomCommandSignature {
  boot: (settings: IntercomSettings) => void;
  shutdown: () => void;
  update: (settings?: IntercomSettings) => void;
  hide: () => void;
  show: () => void;
  showMessages: () => void;
  showNewMessage: (prepopulateMessage?: string) => void;
  onHide: (callback: () => void) => void;
  onShow: (callback: () => void) => void;
  onUnreadCountChange: (callback: (unreadCount: number) => void) => void;
  onActivatorClick: (callback: () => void) => void;
  trackEvent: (tag?: string, metadata?: any) => void;
  getVisitorId: () => string;
  startTour: (tourId: number) => void;
  showArticle: (articleId: number) => void;
  startSurvey: (surveyId: number) => void;
  reattach_activator: () => void;
}

type IntercomCommand = keyof IntercomCommandSignature;

export interface Intercom {
  <Command extends IntercomCommand>(
    command: Command,
    ...params: Parameters<IntercomCommandSignature[Command]>
  ): ReturnType<IntercomCommandSignature[Command]>;
  booted: boolean;
}

///// ENDOF: Definitions: https://github.com/DefinitelyTyped/DefinitelyTyped

export interface IntercomIdentity {
  userId: string;
  email?: string;
  userHash?: string;
}

export interface IntercomUser {
  email?: string;
  phone?: string;
  name?: string;
  language?: string;
}

export interface IntercomEvent {
  name: string;
  data?: any;
}

export interface IntercomMessage {
  content?: string;
}

export interface IntercomArticle {
  id: number;
}

export interface IntercomSurvey {
  id: number;
}

export interface IntercomCustomAttributes {
  attributes: Record<string, number | string | boolean>;
}

export interface IntercomPlugin {
  initialize(config: IntercomSettings): void;
  loginIdentifiedUser(identity: IntercomIdentity): Promise<void>;
  loginUnidentifiedUser(): Promise<void>;
  updateUser(user: IntercomUser): Promise<void>;
  logout(): Promise<void>;
  logEvent(event: IntercomEvent): Promise<void>;
  displayMessenger(): Promise<void>;
  displayMessageComposer(message: IntercomMessage): Promise<void>;
  displayHelpCenter(): Promise<void>;
  displayArticle(article: IntercomArticle): Promise<void>;
  hideMessenger(): Promise<void>;
  displayLauncher(): Promise<void>;
  hideLauncher(): Promise<void>;
  setCustomAttributes(payload: IntercomCustomAttributes): Promise<void>;
  displaySurvey(survey: IntercomSurvey): Promise<void>;
}
