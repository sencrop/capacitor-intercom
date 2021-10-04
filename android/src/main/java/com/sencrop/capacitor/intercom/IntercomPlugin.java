package com.sencrop.capacitor.intercom;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import io.intercom.android.sdk.Intercom;
import io.intercom.android.sdk.UserAttributes;
import io.intercom.android.sdk.helpcenter.api.HelpCenterArticleSearchResult;
import io.intercom.android.sdk.helpcenter.api.SearchRequestCallback;
import io.intercom.android.sdk.identity.Registration;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.json.JSONArray;
import org.json.JSONObject;

@CapacitorPlugin(name = "Intercom")
public class IntercomPlugin extends Plugin {

    @PluginMethod
    public void initialize(PluginCall call) {
        // get config
        String apiKey = getConfig().getString("android_apiKey", "ADD_IN_CAPACITOR_CONFIG_JSON");
        String appId = getConfig().getString("appId", "ADD_IN_CAPACITOR_CONFIG_JSON");

        // init intercom sdk
        Intercom.initialize(this.getActivity().getApplication(), apiKey, appId);
        Intercom.client().handlePushMessage();
        call.resolve();
    }

    @PluginMethod
    public void registerIdentifiedUser(PluginCall call) {
        String email = call.getString("email");
        String userId = call.getString("userId");
        String userHash = call.getString("userHash");

        Registration registration = Registration.create();

        if (email != null && email.length() > 0) {
            registration = registration.withEmail(email);
        }
        if (userId != null && userId.length() > 0) {
            registration = registration.withUserId(userId);
        }

        Intercom.client().registerIdentifiedUser(registration);

        if (userHash != null && userHash.length() > 0) {
            Intercom.client().setUserHash(userHash);
        }
        call.resolve();
    }

    @PluginMethod
    public void registerUnidentifiedUser(PluginCall call) {
        Intercom.client().registerUnidentifiedUser();
        call.resolve();
    }

    @PluginMethod
    public void updateUser(PluginCall call) {
        String email = call.getString("email");
        String phone = call.getString("phone");
        String name = call.getString("name");
        String language = call.getString("language");

        UserAttributes userAttributes = new UserAttributes.Builder()
            .withName(name)
            .withEmail(email)
            .withPhone(phone)
            .withLanguageOverride(language)
            .build();
        Intercom.client().updateUser(userAttributes);
        call.resolve();
    }

    @PluginMethod
    public void setCustomAttributes(PluginCall call) {
        Map<String, Object> attributes = mapFromJSON(call.getObject("attributes"));

        UserAttributes.Builder userAttributesBuilder = new UserAttributes.Builder();

        for (Map.Entry<String, Object> attribute : attributes.entrySet()) {
            String key = attribute.getKey();
            Object value = attribute.getValue();
            userAttributesBuilder = userAttributesBuilder.withCustomAttribute(key, value);
        }

        UserAttributes userAttributes = userAttributesBuilder.build();
        Intercom.client().updateUser(userAttributes);
        call.resolve();
    }

    @PluginMethod
    public void logout(PluginCall call) {
        Intercom.client().logout();
        call.resolve();
    }

    @PluginMethod
    public void logEvent(PluginCall call) {
        String eventName = call.getString("name");
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
        Intercom.client().displayMessenger();
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
        Intercom.client().displayHelpCenter();
        call.resolve();
    }

    @PluginMethod
    public void searchHelpCenter(PluginCall call) {
        String searchTerm = call.getString("searchTerm");

        Intercom.client().searchHelpCenter(searchTerm, new SearchRequestCallback() {
            @Override
            public void onFailure() {
                call.reject("Intercom searchHelpCenter unknown error");
            }

            @Override
            public void onError(int i) {
                call.reject("Intercom searchHelpCenter error. Http code : " + i);
            }

            @Override
            public void onComplete(List<HelpCenterArticleSearchResult> list) {
                JSObject ret = new JSObject();
                ret.put("results", list);
                call.resolve(ret);
            }
        });
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
        String articleId = call.getString("id");
        Intercom.client().displayArticle(articleId);
        call.resolve();
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
}
