//
//  ViewController.h
//  IOS8CLLocationManager
//
//  Created by fengs on 14-12-28.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>


@interface ViewController : UIViewController<CLLocationManagerDelegate,UIAlertViewDelegate>{
    UIAlertView *alertView;
}
@property(nonatomic,retain) CLLocationManager *locationManager;
@property(nonatomic,retain) UITextView *resultTextView;
@property(nonatomic,retain) UIButton *locationBtn;
@end
