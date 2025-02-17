# News App

## 📌 Overview
App made using Flutter and News API to fetch the latest news from the Internet.

## 🚀 How to Set Up and Run the Project Locally

### Prerequisites
- Flutter 3
- Android Studio Laetst Version
- Git
- Java 17


### Installation Steps
1. Clone the repository
```
git clone https://github.com/nandanmagdum/News-App.git
```
2. Install packages
```
flutter pub get
```
3. Connect to Physical Device and run from the terminal
```
flutter run
```

### Key Design Decisions Made
1. Used Bloc State Management.
2. Used Hydrated Bloc for caching (storing last 5 results of the news)
3. Used url_launcher package for redirecting user to read detaild news from the internet

### Known Issues or Areas for Improvement
1. Please test this application in real physical device, storing the cache on ios Simulators or android Emulators may not work for caching .
2. API KEY has the limited requests of 50 requests in 12 hours, so this may stop the application giving 429 error status code.
Note: If this situation is arised, then please try with different API Keys (that are commented) in lib/core/api_constants.dart file to check it works correctly.
3. When clicked on the "Read more" button the user is redirected to the original sourse of news on the internet, it is opened on default browsers (chrome for android and safari for iOs).

To get your own API Key:
visit the follwing website and get the API key: 
NEWS API
```
https://newsapi.org/account
```

Flutter packages used:
1. flutter_bloc 
2. http
3. bloc
4. cached_network_image
5. url_launcher
6. hydrated_bloc:
7. path_provider
8. intl