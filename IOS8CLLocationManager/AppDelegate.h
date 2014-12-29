//
//  AppDelegate.h
//  IOS8CLLocationManager
//
//  Created by fengs on 14-12-28.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UINavigationController *_nav;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
