declare module "@capacitor/core" {
  interface PluginRegistry {
    Intercom: IntercomPlugin;
  }
}

export interface IntercomIdentity {
  userId: string;
  email?: string;
}

export interface IntercomUser {
  email?: string;
  phone?: string;
  name?: string;
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

export interface IntercomPlugin {
  registerIdentifiedUser(options: IntercomIdentity): Promise<void>;
  registerUnidentifiedUser(): Promise<void>;
  updateUser(options: IntercomUser): Promise<void>;
  logout(): Promise<void>;
  logEvent(name: string, data: any): Promise<void>;
  displayMessenger(): Promise<void>;
  displayMessageComposer(): Promise<void>;
  displayHelpCenter(): Promise<void>;
  hideMessenger(): Promise<void>;
  displayLauncher(): Promise<void>;
  hideLauncher(): Promise<void>;
}