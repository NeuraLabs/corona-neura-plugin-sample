# Welcome

|                      | &nbsp;
| -------------------- | ---------------------------------------------------------------
| __Type__             | [Library](http://docs.coronalabs.com/api/type/Library.html)
| __Corona Store__     | [Neura](https://store.coronalabs.com/plugin/neura)
| __Sample Code__      | [View Sample on GitHub](https://github.com/NeuraLabs/corona-plugin-neura-sample)
| __Platforms__        | Android

## Overview

[Neura](http://www.theneura.com) increases user engagement and grows revenue. Neura uses artifical intelligence (AI) on data from multiple sources. We run this data through our machine learning algorithms to create insights on your user. We use these insights to trigger specific features in your app, provide your user with data on their behavior that they may otherwise not be aware of, and combine our insights with your own dataset to create even deeper insights on your users.

### Corona Store Activation

In order to use this plugin, you must activate the plugin at the [Corona Store](http://store.coronalabs.com/plugin/neura).

### SDK

When you build using the Corona Simulator, the server automatically takes care of integrating the plugin into your project.

All you need to do is add an entry into a `plugins` table of your `build.settings`. The following is an example of a minimal `build.settings` file:

``````
settings =
{
	plugins =
	{
		-- key is the name passed to Lua's 'require()'
		["plugin.neura"] =
		{
			-- required
			publisherId = "com.neura",
		},
	},
}
``````

### Syntax

```lua
local neura = require "plugin.neura"
```

### Register your app with Neura

#### Register the app

If you haven't already, [create an app](https://dev.theneura.com/console/app/new) and fill the required information.

#### Declare permissions

Here you decide which pieces of user data you want Neura to provide you with, and declare the value you'll provide to the user in exchange for that data. Want to be alerted whenever 'userStartedDriving' is triggered? This is the place to ask for that.

During the authentication process, you will pass these permission requests and value propositions to Neura, and we'll ask your users to approve them when they sign in.

### Connect to Neura

```lua
local function generalNeuraListener(event)
    print("Neura event: " .. event.name)
end

local firebaseParams = {
    apiKey = "FIREBASE_API_KEY",
    applicationId = "FIREBASE_APP_ID",
    gcmSenderId = "FIREBASE_GCM_SENDER_ID"
}
neura.connect({
    appUid = "APP_UID", 
    appSecret = "APP_SECRET",
    firebase = firebaseParams},
    generalNeuraListener) 
```

### Authenticate with Neura

After connecting with `neura.connect`, you can initiate the Neura authentication screen.

```lua
local function authenticateListener(event)
    if event.type == "Success" then
        neura.registerFirebaseToken()
        
        local events = { ... }
        for i, v in ipairs(events) do
            neura.subscribeToEvent(v, "Identifier_"..v)
        end
    else
        print("Neura authentication failed!")
    end
end

neura.authenticate(authenticateListener)
```

### Receiving events from Neura

There are 2 options where you can receive events from Neura.

You'll need to define which way you want to receive the event, and declare it in the "TECH INFO" section when [creating an application](https://dev.theneura.com/console/app/new).

1. [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging/): Neura will send you an event to a service you declared on your manifest. If you don't have a server side, this is the only way you can receive an event.
2. **Webhook**: Neura will send an event to the url specified, and you will have to decide what to do with the event.


