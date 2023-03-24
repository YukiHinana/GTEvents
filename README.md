# Mobile APP
1. Follow the tutorial to setup Flutter installation [Flutter Installation Tutorial](https://docs.flutter.dev/get-started/install)
2. Install dependencies of the project by running
    ```bash
    flutter pub get
    ```
   in `/frontend` subdirectory of the repo

3. Open the project in the editor of your choice and run
4. In this sprint, we will skip the login page. Click "Skip" to proceed.
5. Click "+" to add an event. Slide to the left or right to delete an event.
6. We only target mobile platform, while it runs on web / desktop. We only test and validate for mobile

# Backend
Run `./gradlew -DDB_PASSWORD={yourDatabasePassword} -DDB_USERNAME={yourDatabaseUsername} 
-DDB_NAME={yourDatabaseName} -DIAM_KEY={yourIAMKey} -DIAM_KEY_SECRET={yourIAMKeySecret} bootRun`