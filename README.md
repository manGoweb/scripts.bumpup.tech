# scripts.bumpup.tech
#### Build number management in the cloud!
BumpUp! provides a way to manage your build numbers always up-to-date and and in sync with other team member or your CI. Generate your API key and follow instructions on how to integrate with your iOS or Android app. Obviously that is not all, our API is open, you can integrate BumpUp into any system or procedure.

## Installing BumpUp!

### Xcode
1) Go to your project folder in terminal
2) Launch `bash <(curl -sSL 'goo.gl/wghTYC') ./SomeFolder/Info.plist` where `./SomeFolder/Info.plist` is path to your Info.plist file
3) Follow the instructions in your install script
4) Once you are done, in Xcode, go to your targets Build Phases, create New Run Script Phase with `./bumpup.sh` in it.
5) Build and see your version number update

#### Optionals / Ideas
* You can create multiple bumpup.sh files if you have multitarget environments by passing the filename after the info.plist path `bash <(curl -sSL 'goo.gl/wghTYC') ./SomeFolder/Info.plist my-target1.sh`
* You can name the build phase BumpUp! to make the settings more readable.


