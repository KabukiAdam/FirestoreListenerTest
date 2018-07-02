# FirestoreListenerTest
Test performance of Firestore listener for large data sets


## Installation
1. Install cocopods using `pod install`
2. Add `GoogleService-Info.plist` containing your Firestore app config to Xcode project

## Use
- __Add Large Data Set__ button will create 3000 documents in Firestore.  Log view will show when each document has been created in cloud.
- __Create Listener (All)__ button creates a listener for all documents and logs the time taken to receive the intial listener update.
- __Create Listener (100)__ button is the same as above but puts a limit(100) on the results.
- __Get Documents (All)__ button performs a direct query returning all documents and logs the time take to complete.
- __Get Documents (100)__ button is the same as above but puts a limit(100) on the results.
