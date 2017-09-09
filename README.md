Taking snapshots and storing them securely on a device...in theory.

To run you should be able to clone and run on any iOS device with a front facing camera.

When the "Take Photos" button is clicked the front facing camera will take 10 photos with a delay of 0.5 seconds between shots.  The images are then persisted in Core Data right now.

*** Further Considerations ***

 I am looking at how to store the images in a KeyChain directly where before I was thinking I could control access to them in Core Data but realize that DB isn't secure itself given that it could be backed up or copied and possibly accessed by other applications.

User experience could be improved with additional handling of scenarios where the user does not grant access to use the camera.

Understanding the process flow.  There will likely be a scenario where this process is kicked off to initialize the images associated with the user...which would be stored in the keychain.  After that I would assume this process would be kicked off again to re-authenticate but instead of storing the images (or in addition to storing them) it would also need to run a verification module.
