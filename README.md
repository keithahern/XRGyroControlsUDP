# XRGyroControls
This is a replacement for the default controls used in the VisionOS xrOS Simulator. This will allow you to control the simulator camera with an actual VR headset once it is finished. Right now it is in POC stage and can control the simulator, but doesn't actually take input from another headset.

## Installation
1. Disable SIP
2. Disable library validation (`sudo defaults write /Library/Preferences/com.apple.security.libraryvalidation.plist DisableLibraryValidation -bool true`)
3. Install the latest Xcode beta, and install the VisionOS Simulator. Make sure that you install the Xcode beta to  `/Applications/Xcode-beta.app` or change the paths in the Copy Files stage of the build process and the application to launch in the schema.
4. Open `/Applications/Xcode-beta.app/Contents/Developer/Platforms/XROS.platform/Library/Developer/CoreSimulator/Profiles/UserInterface` and move the original XROS.simdeviceui to a safe place. You CANNOT just rename it, the simulator will search the entire folder and get confused if it finds both the original and modified version.
5. Clone the git repo and open it in Xcode
6. Launch the default schema. It should launch the simulator, you can tell it works if the toolbar is changed and the camera is slowly rising.

## UDP Streaming (in this fork)
The simulator will listen on port 11000 for incoming messages with the format: `Position:x,y,z;Rotation:x,y,z,w` where x,y,z,w are floats. The rotation is a quaternion.  This drives the camera only. No pointer support is added yet.
There is a Unity project for Magic Leap One to publish this position and rotation data, it should be pretty easy to roll your own.

