# @sencrop/capacitor-intercom

Intercom Plugin for Capacitor

## Install

```bash
npm install @sencrop/capacitor-intercom
npx cap sync
```

## API

<docgen-index>

* [`initialize(...)`](#initialize)
* [`registerIdentifiedUser(...)`](#registeridentifieduser)
* [`registerUnidentifiedUser()`](#registerunidentifieduser)
* [`updateUser(...)`](#updateuser)
* [`logout()`](#logout)
* [`logEvent(...)`](#logevent)
* [`displayMessenger()`](#displaymessenger)
* [`displayMessageComposer(...)`](#displaymessagecomposer)
* [`displayHelpCenter()`](#displayhelpcenter)
* [`hideMessenger()`](#hidemessenger)
* [`displayLauncher()`](#displaylauncher)
* [`hideLauncher()`](#hidelauncher)
* [`setCustomAttributes(...)`](#setcustomattributes)
* [Interfaces](#interfaces)

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

--------------------


### registerIdentifiedUser(...)

```typescript
registerIdentifiedUser(identity: IntercomIdentity) => any
```

| Param          | Type                                                          |
| -------------- | ------------------------------------------------------------- |
| **`identity`** | <code><a href="#intercomidentity">IntercomIdentity</a></code> |

**Returns:** <code>any</code>

--------------------


### registerUnidentifiedUser()

```typescript
registerUnidentifiedUser() => any
```

**Returns:** <code>any</code>

--------------------


### updateUser(...)

```typescript
updateUser(user: IntercomUser) => any
```

| Param      | Type                                                  |
| ---------- | ----------------------------------------------------- |
| **`user`** | <code><a href="#intercomuser">IntercomUser</a></code> |

**Returns:** <code>any</code>

--------------------


### logout()

```typescript
logout() => any
```

**Returns:** <code>any</code>

--------------------


### logEvent(...)

```typescript
logEvent(event: IntercomEvent) => any
```

| Param       | Type                                                    |
| ----------- | ------------------------------------------------------- |
| **`event`** | <code><a href="#intercomevent">IntercomEvent</a></code> |

**Returns:** <code>any</code>

--------------------


### displayMessenger()

```typescript
displayMessenger() => any
```

**Returns:** <code>any</code>

--------------------


### displayMessageComposer(...)

```typescript
displayMessageComposer(message: IntercomMessage) => any
```

| Param         | Type                                                        |
| ------------- | ----------------------------------------------------------- |
| **`message`** | <code><a href="#intercommessage">IntercomMessage</a></code> |

**Returns:** <code>any</code>

--------------------


### displayHelpCenter()

```typescript
displayHelpCenter() => any
```

**Returns:** <code>any</code>

--------------------


### hideMessenger()

```typescript
hideMessenger() => any
```

**Returns:** <code>any</code>

--------------------


### displayLauncher()

```typescript
displayLauncher() => any
```

**Returns:** <code>any</code>

--------------------


### hideLauncher()

```typescript
hideLauncher() => any
```

**Returns:** <code>any</code>

--------------------


### setCustomAttributes(...)

```typescript
setCustomAttributes(payload: IntercomCustomAttributes) => any
```

| Param         | Type                                                                          |
| ------------- | ----------------------------------------------------------------------------- |
| **`payload`** | <code><a href="#intercomcustomattributes">IntercomCustomAttributes</a></code> |

**Returns:** <code>any</code>

--------------------


### Interfaces


#### IntercomSettings

| Prop                           | Type                                                                                                                                                                                      |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`app_id`**                   | <code>string</code>                                                                                                                                                                       |
| **`alignment`**                | <code>string</code>                                                                                                                                                                       |
| **`custom_launcher_selector`** | <code>string</code>                                                                                                                                                                       |
| **`hide_default_launcher`**    | <code>boolean</code>                                                                                                                                                                      |
| **`horizontal_padding`**       | <code>number</code>                                                                                                                                                                       |
| **`session_duration`**         | <code>number</code>                                                                                                                                                                       |
| **`vertical_padding`**         | <code>number</code>                                                                                                                                                                       |
| **`action_color`**             | <code>string</code>                                                                                                                                                                       |
| **`background_color`**         | <code>string</code>                                                                                                                                                                       |
| **`email`**                    | <code>string</code>                                                                                                                                                                       |
| **`phone`**                    | <code>string</code>                                                                                                                                                                       |
| **`created_at`**               | <code>number</code>                                                                                                                                                                       |
| **`name`**                     | <code>string</code>                                                                                                                                                                       |
| **`user_id`**                  | <code>string</code>                                                                                                                                                                       |
| **`user_hash`**                | <code>string</code>                                                                                                                                                                       |
| **`unsubscribed_from_emails`** | <code>boolean</code>                                                                                                                                                                      |
| **`language_override`**        | <code>string</code>                                                                                                                                                                       |
| **`utm_campaign`**             | <code>string</code>                                                                                                                                                                       |
| **`utm_content`**              | <code>string</code>                                                                                                                                                                       |
| **`utm_medium`**               | <code>string</code>                                                                                                                                                                       |
| **`utm_source`**               | <code>string</code>                                                                                                                                                                       |
| **`utm_term`**                 | <code>string</code>                                                                                                                                                                       |
| **`company`**                  | <code>{ id: string \| number; name: string; created_at?: number; plan?: string; monthly_spend?: number; user_count?: number; size?: number; website?: string; industry?: string; }</code> |


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


#### IntercomCustomAttributes

| Prop             | Type             |
| ---------------- | ---------------- |
| **`attributes`** | <code>any</code> |

</docgen-api>
