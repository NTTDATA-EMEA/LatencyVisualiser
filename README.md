# Latency Visualiser

An iOS app which connects to a web socket backend to do round-trip
calls and visualises the latency (somehow).

The app uses the Starscream library, hence cocoapods need to be
installed and the respective pod needs to be installed

For installation of cocpods run `sudo gem install cocoapods`. 
Then run the pod installation with `pod install` and make
sure you open the generated workspace with Xcode, not the project.
In the Pods, set the iOS version from 8.0 to 12.0 to suppress
warnings, but warnings can also be ignored.

