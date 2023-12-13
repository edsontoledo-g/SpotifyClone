# SpotifyClone
This is a Spotify Clone App using SwiftUI and Unidirectional Flow Pattern

## Installation
This project was built using the new Observation Framework so you need Xcode 15 or later.

This app point to the [Spotify API](https://developer.spotify.com/). To connect yourself to this API you need a client id and client secret key. To generate them, go to https://developer.spotify.com/ and log in in your account. Create a new app in the [Dashboard](https://developer.spotify.com/dashboard) and once you have created it you should get the credentials mentioned above.

To keep these keys safe and easy to use in the project, I used Xcode environment variables to read these values. To create these env variables open this porject in Xcode. In the toolbar click on the scheme and select "Edit Scheme...". Then, on the window that opened, select the "Run" section and "Arguments" tab. In "Environment Variables" section create both your client id and client secret keys with these names: `SPOTIFY_CLIENT_ID` `SPOTIFY_CLIENT_SECRET`.

That's all. Now when you run the app, the project should read these keys from the environment variables and you should be able to use this app

