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

export interface IntercomSettings {
  app_id: string;
  custom_launcher_selector?: string;
  alignment?: string;
  vertical_padding?: number;
  horizontal_padding?: number;
  hide_default_launcher?: boolean;
  session_duration?: number;
  action_color?: string;
  background_color?: string;
}

export interface IntercomEvent {
  name: string;
  data?: any;
}

export interface IntercomMessage {
  content?: string;
}

export interface IntercomCustomAttributes {
  attributes: Record<string, number | string | boolean>;
}

export interface IntercomPlugin {
  initialize(config: IntercomSettings): void;
  registerIdentifiedUser(identity: IntercomIdentity): Promise<void>;
  registerUnidentifiedUser(): Promise<void>;
  updateUser(user: IntercomUser): Promise<void>;
  logout(): Promise<void>;
  logEvent(event: IntercomEvent): Promise<void>;
  displayMessenger(): Promise<void>;
  displayMessageComposer(message: IntercomMessage): Promise<void>;
  displayHelpCenter(): Promise<void>;
  hideMessenger(): Promise<void>;
  displayLauncher(): Promise<void>;
  hideLauncher(): Promise<void>;
  setCustomAttributes(payload: IntercomCustomAttributes): Promise<void>;
}
