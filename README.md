Taking snapshots and storing them securely on a device...in theory.

To run you should be able to clone and run on any iOS device with a front facing camera.

The camera currently will take one photo when the button is tapped and stores it to the user's Library.

*** Further Considerations ***

...the rest of the project really...

I was debating between

1) storing images directly to a file on the phone and trying to make the directory and/or file password encrypted so that it could not be accessed unless authorized by the application...

2) storing the images in CoreData then encrypting access to the fetchRequest.

I started down the path of using Core Data because it seems more centralized to the app versus more accessible across the phone in general.
