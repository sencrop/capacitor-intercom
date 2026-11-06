# @sencrop/capacitor-intercom

Intercom Plugin for Capacitor

## Install

```bash
pnpm add @sencrop/capacitor-intercom
pnpm exec cap sync
```

## Configuration

On iOS and Android, the plugin reads its keys from the Capacitor config, under `plugins.Intercom`:

```ts
// capacitor.config.ts
plugins: {
  Intercom: {
    appId: "<Intercom app ID>",
    ios_apiKey: "<Intercom iOS API key>",
    android_apiKey: "<Intercom Android API key>",
  },
},
```

On the web, `initialize({ app_id })` loads the Intercom Messenger widget with the given app ID; the native platforms ignore the settings passed to `initialize`.

## Push notifications

The plugin does not handle push notifications: the app wires them, on both platforms.

- **iOS**: Intercom needs the APNs device token. The plugin forwards it when the app posts it, as `Data`, with Capacitor's `capacitorDidRegisterForRemoteNotifications` notification, as the setup of `@capacitor/push-notifications` does. An app that posts another token there (an FCM token, for example) calls `Intercom.setDeviceToken(deviceToken)` itself in `application(_:didRegisterForRemoteNotificationsWithDeviceToken:)`.
- **Android**: the app's own `FirebaseMessagingService` sends the token to Intercom in `onNewToken` (`IntercomPushClient.sendTokenToIntercom`) and hands the Intercom messages over to it in `onMessageReceived` (`isIntercomPush`, then `handlePush`). `IntercomPushClient` comes from the SDK the plugin exposes (see [Android](#android)).

## Android

The plugin brings the Intercom Android SDK (`io.intercom.android:intercom-sdk-base`) and exposes it to the app (`api` dependency), so the app compiles against its classes, `IntercomPushClient` included. The app does not declare Intercom itself: a second Intercom artifact, such as `io.intercom.android:intercom-sdk`, would make Gradle mix two Intercom versions. The version is the plugin's default unless the app sets `intercomSdkVersion` in its `variables.gradle`, as with the other Capacitor plugins.

## API

<docgen-index>

- [`initialize(...)`](#initialize)
- [`loginIdentifiedUser(...)`](#loginidentifieduser)
- [`loginUnidentifiedUser()`](#loginunidentifieduser)
- [`updateUser(...)`](#updateuser)
- [`logout()`](#logout)
- [`logEvent(...)`](#logevent)
- [`displayMessenger()`](#displaymessenger)
- [`displayMessageComposer(...)`](#displaymessagecomposer)
- [`displayHelpCenter()`](#displayhelpcenter)
- [`displayArticle(...)`](#displayarticle)
- [`hideMessenger()`](#hidemessenger)
- [`displayLauncher()`](#displaylauncher)
- [`hideLauncher()`](#hidelauncher)
- [`setCustomAttributes(...)`](#setcustomattributes)
- [`displaySurvey(...)`](#displaysurvey)
- [Interfaces](#interfaces)
- [Type Aliases](#type-aliases)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### initialize(...)

```typescript
initialize(config: IntercomSettings) => void
```

| Param        | Type                                                          |
| ------------ | ------------------------------------------------------------- |
| **`config`** | <code><a href="#intercomsettings">IntercomSettings</a></code> |

---

### loginIdentifiedUser(...)

```typescript
loginIdentifiedUser(identity: IntercomIdentity) => Promise<void>
```

| Param          | Type                                                          |
| -------------- | ------------------------------------------------------------- |
| **`identity`** | <code><a href="#intercomidentity">IntercomIdentity</a></code> |

---

### loginUnidentifiedUser()

```typescript
loginUnidentifiedUser() => Promise<void>
```

---

### updateUser(...)

```typescript
updateUser(user: IntercomUser) => Promise<void>
```

| Param      | Type                                                  |
| ---------- | ----------------------------------------------------- |
| **`user`** | <code><a href="#intercomuser">IntercomUser</a></code> |

---

### logout()

```typescript
logout() => Promise<void>
```

---

### logEvent(...)

```typescript
logEvent(event: IntercomEvent) => Promise<void>
```

| Param       | Type                                                    |
| ----------- | ------------------------------------------------------- |
| **`event`** | <code><a href="#intercomevent">IntercomEvent</a></code> |

---

### displayMessenger()

```typescript
displayMessenger() => Promise<void>
```

---

### displayMessageComposer(...)

```typescript
displayMessageComposer(message: IntercomMessage) => Promise<void>
```

| Param         | Type                                                        |
| ------------- | ----------------------------------------------------------- |
| **`message`** | <code><a href="#intercommessage">IntercomMessage</a></code> |

---

### displayHelpCenter()

```typescript
displayHelpCenter() => Promise<void>
```

---

### displayArticle(...)

```typescript
displayArticle(article: IntercomArticle) => Promise<void>
```

| Param         | Type                                                        |
| ------------- | ----------------------------------------------------------- |
| **`article`** | <code><a href="#intercomarticle">IntercomArticle</a></code> |

---

### hideMessenger()

```typescript
hideMessenger() => Promise<void>
```

---

### displayLauncher()

```typescript
displayLauncher() => Promise<void>
```

---

### hideLauncher()

```typescript
hideLauncher() => Promise<void>
```

---

### setCustomAttributes(...)

```typescript
setCustomAttributes(payload: IntercomCustomAttributes) => Promise<void>
```

| Param         | Type                                                                          |
| ------------- | ----------------------------------------------------------------------------- |
| **`payload`** | <code><a href="#intercomcustomattributes">IntercomCustomAttributes</a></code> |

---

### displaySurvey(...)

```typescript
displaySurvey(survey: IntercomSurvey) => Promise<void>
```

| Param        | Type                                                      |
| ------------ | --------------------------------------------------------- |
| **`survey`** | <code><a href="#intercomsurvey">IntercomSurvey</a></code> |

---

### Interfaces

#### IntercomSettings

| Prop                           | Type                                                        |
| ------------------------------ | ----------------------------------------------------------- |
| **`app_id`**                   | <code>string</code>                                         |
| **`api_base`**                 | <code>string</code>                                         |
| **`alignment`**                | <code>string</code>                                         |
| **`custom_launcher_selector`** | <code>string</code>                                         |
| **`hide_default_launcher`**    | <code>boolean</code>                                        |
| **`horizontal_padding`**       | <code>number</code>                                         |
| **`session_duration`**         | <code>number</code>                                         |
| **`vertical_padding`**         | <code>number</code>                                         |
| **`action_color`**             | <code>string</code>                                         |
| **`background_color`**         | <code>string</code>                                         |
| **`email`**                    | <code>string</code>                                         |
| **`phone`**                    | <code>string</code>                                         |
| **`created_at`**               | <code>number</code>                                         |
| **`name`**                     | <code>string</code>                                         |
| **`user_id`**                  | <code>string</code>                                         |
| **`user_hash`**                | <code>string</code>                                         |
| **`unsubscribed_from_emails`** | <code>boolean</code>                                        |
| **`language_override`**        | <code>string</code>                                         |
| **`utm_campaign`**             | <code>string</code>                                         |
| **`utm_content`**              | <code>string</code>                                         |
| **`utm_medium`**               | <code>string</code>                                         |
| **`utm_source`**               | <code>string</code>                                         |
| **`utm_term`**                 | <code>string</code>                                         |
| **`company`**                  | <code><a href="#intercomcompany">IntercomCompany</a></code> |
| **`companies`**                | <code>IntercomCompany[]</code>                              |
| **`avatar`**                   | <code><a href="#intercomavatar">IntercomAvatar</a></code>   |

#### IntercomCompany

| Prop                    | Type                          |
| ----------------------- | ----------------------------- |
| **`name`**              | <code>string</code>           |
| **`id`**                | <code>string \| number</code> |
| **`company_id`**        | <code>string \| number</code> |
| **`created_at`**        | <code>number</code>           |
| **`remote_created_at`** | <code>number</code>           |
| **`plan`**              | <code>string</code>           |
| **`monthly_spend`**     | <code>number</code>           |
| **`user_count`**        | <code>number</code>           |
| **`size`**              | <code>number</code>           |
| **`website`**           | <code>string</code>           |
| **`industry`**          | <code>string</code>           |

#### IntercomAvatar

| Prop            | Type                  |
| --------------- | --------------------- |
| **`type`**      | <code>'avatar'</code> |
| **`image_url`** | <code>string</code>   |

#### IntercomIdentity

| Prop           | Type                |
| -------------- | ------------------- |
| **`userId`**   | <code>string</code> |
| **`email`**    | <code>string</code> |
| **`userHash`** | <code>string</code> |

#### IntercomUser

| Prop           | Type                |
| -------------- | ------------------- |
| **`email`**    | <code>string</code> |
| **`phone`**    | <code>string</code> |
| **`name`**     | <code>string</code> |
| **`language`** | <code>string</code> |

#### IntercomEvent

| Prop       | Type                |
| ---------- | ------------------- |
| **`name`** | <code>string</code> |
| **`data`** | <code>any</code>    |

#### IntercomMessage

| Prop          | Type                |
| ------------- | ------------------- |
| **`content`** | <code>string</code> |

#### IntercomArticle

| Prop     | Type                |
| -------- | ------------------- |
| **`id`** | <code>number</code> |

#### IntercomCustomAttributes

| Prop             | Type                                                                                 |
| ---------------- | ------------------------------------------------------------------------------------ |
| **`attributes`** | <code><a href="#record">Record</a>&lt;string, number \| string \| boolean&gt;</code> |

#### IntercomSurvey

| Prop     | Type                |
| -------- | ------------------- |
| **`id`** | <code>number</code> |

### Type Aliases

#### Record

Construct a type with a set of properties K of type T

<code>{
[P in K]: T;
}</code>

</docgen-api>
