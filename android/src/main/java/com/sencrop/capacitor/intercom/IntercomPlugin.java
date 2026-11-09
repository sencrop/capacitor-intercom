package com.sencrop.capacitor.intercom;

import android.app.Application;

import androidx.annotation.NonNull;

import com.getcapacitor.CapConfig;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginConfig;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

import io.intercom.android.sdk.Intercom;
import io.intercom.android.sdk.IntercomContent;
import io.intercom.android.sdk.IntercomError;
import io.intercom.android.sdk.IntercomSpace;
import io.intercom.android.sdk.IntercomStatusCallback;
import io.intercom.android.sdk.UserAttributes;
import io.intercom.android.sdk.identity.Registration;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

@CapacitorPlugin(name = "Intercom")
public class IntercomPlugin extends Plugin {

    private static boolean initialized;

    /**
     * Initializes Intercom with the keys of the Capacitor config. Call it from {@code
     * Application.onCreate()}: Android can open an Intercom activity, from a tapped notification or
     * when it restores the app, before the WebView calls {@code initialize()}, and Intercom then
     * crashes the app.
     */
    public static synchronized void initialize(@NonNull Application application) {
        if (initialized) {
            return;
        }
        PluginConfig config = CapConfig.loadDefault(application).getPluginConfiguration("Intercom");
        Intercom.initialize(
                application,
                config.getString("android_apiKey", "ADD_IN_CAPACITOR_CONFIG_JSON"),
                config.getString("appId", "ADD_IN_CAPACITOR_CONFIG_JSON"));
        initialized = true;
    }

    private static Map<String, Object> mapFromJSON(JSONObject jsonObject) {
        if (jsonObject == null) {
            return null;
        }
        Map<String, Object> map = new HashMap<>();
        Iterator<String> keysIter = jsonObject.keys();
        while (keysIter.hasNext()) {
            String key = keysIter.next();
            Object value = getObject(jsonObject.opt(key));
            if (value != null) {
                map.put(key, value);
            }
        }
        return map;
    }

    private static Object getObject(Object value) {
        if (value instanceof JSONObject) {
            value = mapFromJSON((JSONObject) value);
        } else if (value instanceof JSONArray) {
            value = listFromJSON((JSONArray) value);
        }
        return value;
    }

    private static List<Object> listFromJSON(JSONArray jsonArray) {
        List<Object> list = new ArrayList<>();
        for (int i = 0, count = jsonArray.length(); i < count; i++) {
            Object value = getObject(jsonArray.opt(i));
            if (value != null) {
                list.add(value);
            }
        }
        return list;
    }

    private static boolean isEmpty(String value) {
        return value == null || value.isEmpty();
    }

    // the TypeScript API types the id as a number, which call.getString() reads as null
    private static String getId(PluginCall call) {
        Object id = call.getData().opt("id");
        if (id instanceof Integer || id instanceof Long) {
            return String.valueOf(id);
        }
        if (id instanceof String && !((String) id).isEmpty()) {
            return (String) id;
        }
        return null;
    }

    @PluginMethod
    public void initialize(PluginCall call) {
        try {
            initialize(getActivity().getApplication());
            call.resolve();
        } catch (Exception e) {
            call.reject("[Intercom SDK] Could not initialize the Intercom plugin", e);
        }
    }

    @PluginMethod
    public void loginIdentifiedUser(PluginCall call) {
        String email = call.getString("email");
        String userId = call.getString("userId");
        String userHash = call.getString("userHash");

        if (isEmpty(email) && isEmpty(userId)) {
            call.reject("[Intercom SDK] You must supply an email, userId or both");
            return;
        }

        if (!isEmpty(userHash)) {
            Intercom.client().setUserHash(userHash);
        }

        Registration registration = Registration.create();

        if (!isEmpty(email)) {
            registration = registration.withEmail(email);
        }
        if (!isEmpty(userId)) {
            registration = registration.withUserId(userId);
        }

        Intercom.client()
                .loginIdentifiedUser(
                        registration,
                        new IntercomStatusCallback() {
                            @Override
                            public void onSuccess() {
                                call.resolve();
                            }

                            @Override
                            public void onFailure(@NonNull IntercomError intercomError) {
                                call.reject(
                                        "[Intercom SDK] Error while login user: "
                                                + intercomError.getErrorMessage());
                            }
                        });
    }

    @PluginMethod
    public void loginUnidentifiedUser(PluginCall call) {
        Intercom.client()
                .loginUnidentifiedUser(
                        new IntercomStatusCallback() {
                            @Override
                            public void onSuccess() {
                                call.resolve();
                            }

                            @Override
                            public void onFailure(@NonNull IntercomError intercomError) {
                                call.reject(
                                        "[Intercom SDK] Error while login unidentified user: "
                                                + intercomError.getErrorMessage());
                            }
                        });
    }

    @PluginMethod
    public void updateUser(PluginCall call) {
        String email = call.getString("email");
        String phone = call.getString("phone");
        String name = call.getString("name");
        String language = call.getString("language");

        UserAttributes.Builder builder = new UserAttributes.Builder();
        if (email != null) {
            builder = builder.withEmail(email);
        }
        if (phone != null) {
            builder = builder.withPhone(phone);
        }
        if (name != null) {
            builder = builder.withName(name);
        }
        if (language != null) {
            builder = builder.withLanguageOverride(language);
        }
        UserAttributes userAttributes = builder.build();
        Intercom.client()
                .updateUser(
                        userAttributes,
                        new IntercomStatusCallback() {
                            @Override
                            public void onSuccess() {
                                call.resolve();
                            }

                            @Override
                            public void onFailure(@NonNull IntercomError intercomError) {
                                call.reject(
                                        "[Intercom SDK] Error while updating user: "
                                                + intercomError.getErrorMessage());
                            }
                        });
    }

    @PluginMethod
    public void setCustomAttributes(PluginCall call) {
        Map<String, Object> attributes = mapFromJSON(call.getObject("attributes"));
        if (attributes == null) {
            call.reject("[Intercom SDK] You must supply the attributes to set");
            return;
        }

        UserAttributes.Builder userAttributesBuilder = new UserAttributes.Builder();

        for (Map.Entry<String, Object> attribute : attributes.entrySet()) {
            String key = attribute.getKey();
            Object value = attribute.getValue();
            userAttributesBuilder = userAttributesBuilder.withCustomAttribute(key, value);
        }

        UserAttributes userAttributes = userAttributesBuilder.build();
        Intercom.client()
                .updateUser(
                        userAttributes,
                        new IntercomStatusCallback() {
                            @Override
                            public void onSuccess() {
                                call.resolve();
                            }

                            @Override
                            public void onFailure(@NonNull IntercomError intercomError) {
                                call.reject(
                                        "[Intercom SDK] Error while setting custom attribute(s): "
                                                + intercomError.getErrorMessage());
                            }
                        });
    }

    @PluginMethod
    public void logout(PluginCall call) {
        Intercom.client().logout();
        call.resolve();
    }

    @PluginMethod
    public void logEvent(PluginCall call) {
        String eventName = call.getString("name");
        if (isEmpty(eventName)) {
            call.reject("[Intercom SDK] You must supply an event name");
            return;
        }
        Map<String, Object> metaData = mapFromJSON(call.getObject("data"));

        if (metaData == null) {
            Intercom.client().logEvent(eventName);
        } else {
            Intercom.client().logEvent(eventName, metaData);
        }

        call.resolve();
    }

    @PluginMethod
    public void displayMessenger(PluginCall call) {
        Intercom.client().present();
        call.resolve();
    }

    @PluginMethod
    public void displayMessageComposer(PluginCall call) {
        String messageContent = call.getString("content");
        if (messageContent == null) {
            Intercom.client().displayMessageComposer();
        } else {
            Intercom.client().displayMessageComposer(messageContent);
        }
        call.resolve();
    }

    @PluginMethod
    public void displayHelpCenter(PluginCall call) {
        Intercom.client().present(IntercomSpace.HelpCenter);
        call.resolve();
    }

    @PluginMethod
    public void hideMessenger(PluginCall call) {
        Intercom.client().hideIntercom();
        call.resolve();
    }

    @PluginMethod
    public void displayLauncher(PluginCall call) {
        Intercom.client().setLauncherVisibility(Intercom.VISIBLE);
        call.resolve();
    }

    @PluginMethod
    public void hideLauncher(PluginCall call) {
        Intercom.client().setLauncherVisibility(Intercom.GONE);
        call.resolve();
    }

    @PluginMethod
    public void displayArticle(PluginCall call) {
        String articleId = getId(call);
        if (articleId == null) {
            call.reject("[Intercom SDK] You must supply an articleId to display it");
            return;
        }
        Intercom.client().presentContent(new IntercomContent.Article(articleId));
        call.resolve();
    }

    @PluginMethod
    public void displaySurvey(PluginCall call) {
        String surveyId = getId(call);
        if (surveyId == null) {
            call.reject("[Intercom SDK] You must supply a surveyId to display it");
            return;
        }
        Intercom.client().presentContent(new IntercomContent.Survey(surveyId));
        call.resolve();
    }
}
