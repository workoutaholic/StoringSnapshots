Taking snapshots and storing them securely on a device.

To run you should be able to clone and run on any iOS device with a front facing camera.

When the "Take Photos" button is clicked the PhotoManager uses the front facing camera to take 10 photos with a delay of 0.5 seconds between shots.

As each image is taken the CameraManagerDelegate (the ViewController) gets back an image which it sends to the EncryptionManager which encrypts each image (Data) using the RNCryptor pod.  The password used to encrypt is stored in the iOS KeyChain.

The ViewController then creates a new instance of AuthSecurityImage which saves the encrypted data leveraging Core Data.

*** Further Considerations ***

User experience could be improved with additional handling of scenarios where the user does not grant access to use the camera.

Right now the password for encrypting the photos is stored right in the EncryptionManager.  I would think the most secure way to handle this would be to get the password from a remote server (probably a good reason to look into iCloud keyChains :) but I haven't gotten there quite yet...
