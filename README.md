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
       // ios 8 or later
        SEL requestAlwaysAuthorizationSEL = NSSelectorFromString(@"requestAlwaysAuthorization");
        if ([self.locationManager respondsToSelector:requestAlwaysAuthorizationSEL]) {
            [self.locationManager performSelector:requestAlwaysAuthorizationSEL];
        }
        
        [self.locationManager startUpdatingLocation];
```
Image
---  
<img src="result.png" height=300>