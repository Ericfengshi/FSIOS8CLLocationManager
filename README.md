FSIOS8CLLocationManager
===========

Base [stackoverflow](http://stackoverflow.com/questions/24062509/location-services-not-working-in-ios-8/26016645#26016645) build a demo,thanks answer [yinfeng](http://stackoverflow.com/users/1461907/yinfeng).The detailed progress can see [ViewController.m](http://github.com/Ericfengshi/FSIOS8CLLocationManager/blob/master/IOS8CLLocationManager/ViewController.m). 

Features
========

* Build in xcode 4.4.1
* Runs on iOS5,6,7,8.

Core code
---  

```objective-c
#ifdef __IPHONE_8_0
    NSUInteger code = [CLLocationManager authorizationStatus];
    if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
        // choose one request according to your business.
        if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
            [self.locationManager requestAlwaysAuthorization];
        } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
            [self.locationManager  requestWhenInUseAuthorization];
        } else {
            NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
        }
    }
#endif
    [self.locationManager startUpdatingLocation];
    
```
Image
---  
<img src="result.png" height=300>