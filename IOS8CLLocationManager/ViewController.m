//
//  ViewController.m
//  IOS8CLLocationManager https://github.com/Ericfengshi/FSIOS8CLLocationManager
//
//  Created by fengs on 14-12-28.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController{
    CGFloat longitude;
    CGFloat latitude;
    int seconds;
    NSTimer *timer;
    BOOL isLocation;
}
@synthesize locationManager = _locationManager;
@synthesize resultTextView = _resultTextView;
@synthesize locationBtn = _locationBtn;

-(void)dealloc{
    
    if (alertView) {
        [alertView release];
    }
    [_resultTextView release];
    [_locationBtn release];
    [super dealloc];
}

- (void)viewDidUnload
{
    self.resultTextView = nil;
    self.locationBtn = nil;
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"获取地理位置";
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 30, 60, 40)] autorelease];
    label.text = @"location:";
    label.font = [UIFont systemFontOfSize:13];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    
    UITextView * resultTextView= [[[UITextView alloc] initWithFrame:CGRectMake(60, 30, 140, 40)] autorelease];
    resultTextView.userInteractionEnabled = NO;
    resultTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    resultTextView.layer.cornerRadius = 10.0f;
    resultTextView.layer.borderWidth = 1.0f;
    self.resultTextView = resultTextView;
    [self.view addSubview:self.resultTextView];
    
    UIButton *locationBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    locationBtn.frame = CGRectMake(210, 30, 100, 40);
    [locationBtn setTitle: @"location" forState: UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(location:) forControlEvents:UIControlEventTouchUpInside];
    self.locationBtn = locationBtn;
    [self.view addSubview:self.locationBtn];
    
    // 实例化一个位置管理器
    CLLocationManager *cllocationManager = [[CLLocationManager alloc] init];
    self.locationManager = cllocationManager;
    [cllocationManager release];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)location:(id)sender {
    if(![CLLocationManager locationServicesEnabled]){
        [self alert:@"定位需开启定位服务:设置 > 隐私 > 位置 > 定位服务" autoDismiss:YES];
    }else{
        if([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending){
            NSUInteger code = [CLLocationManager authorizationStatus];
            if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
                // choose one request according to your business.
                if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                    //[self.locationManager requestAlwaysAuthorization];
                    //requestAlwaysAuthorization(self.locationManager); //#define
                    SEL requestAlwaysAuthorizationSEL = NSSelectorFromString(@"requestAlwaysAuthorization");
                    if ([self.locationManager respondsToSelector:requestAlwaysAuthorizationSEL]) {
                        [self.locationManager performSelector:requestAlwaysAuthorizationSEL];
                    }
                    isLocation = YES;
                    [self.locationManager startUpdatingLocation];
                    // 开始计时
                    [self startTime];
                    [self alert:@"正在获取位置信息..." autoDismiss:NO];
                    
                } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                    //[self.locationManager requestWhenInUseAuthorization];
                } else {
                    NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
                }
                return;
            }
            
            if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
                
                NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
                NSString *appName = [infoDict objectForKey:@"CFBundleDisplayName"];
                NSString *message = [NSString stringWithFormat:@"请开启本应用定位:设置 > 隐私 > 位置 > 定位服务 下 %@",appName];
                
                [self alert:message autoDismiss:YES];

            }else{
                isLocation = YES;
                [self.locationManager startUpdatingLocation];
                // 开始计时
                [self startTime];
                [self alert:@"正在获取位置信息..." autoDismiss:NO];
            }
        }else{
            [self.locationManager startUpdatingLocation];
            if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
                
                NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
                NSString *appName = [infoDict objectForKey:@"CFBundleDisplayName"];
                NSString *message = [NSString stringWithFormat:@"请开启本应用定位:设置 > 隐私 > 位置 > 定位服务 下 %@",appName];
                
                [self alert:message autoDismiss:YES];
            }else{
                isLocation = YES;
                
                [self startTime];
                [self alert:@"正在获取位置信息..." autoDismiss:NO];
            }
        }
    }
}

// 计时开始
-(void)startTime
{
    seconds = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(showRunTime)
                                           userInfo:nil
                                            repeats:YES];
}

// 10s内获取地理位置否则结束
- (void)showRunTime{
    
    seconds++;
    if (seconds == 10)
    {
        seconds = 0;
        [timer invalidate];
        [self dismissAlertAnimation];
        isLocation = NO;
        
        [self setResultTextView];
    }
}

-(void)setResultTextView{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.resultTextView.text = [NSString stringWithFormat:@"longitude:%f\nlatitude:%f",longitude,latitude];
            longitude = 0;
            latitude = 0;
        });
    });
}

#pragma mark -
#pragma mark - CLLocationManagerDelegate

// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D cc;
    // 获取经纬度
    cc.longitude = newLocation.coordinate.longitude;
    cc.latitude = newLocation.coordinate.latitude;
    if (cc.latitude>0 && cc.longitude>0 && isLocation) {

        longitude = cc.longitude;
        latitude = cc.latitude;
        
        isLocation = NO;
        seconds = 0;
        [timer invalidate];
        [self dismissAlertAnimation];
        
        [self setResultTextView];
        
        // 停止位置更新
        [manager stopUpdatingLocation];
    }
    
//    // ios坐标（google）转换为 百度坐标
//    CLLocationCoordinate2D cc2;
//    if (cc.latitude>0 && cc.longitude>0) {
//        cc2 = BMKCoorDictionaryDecode(BMKBaiduCoorForWgs84(cc));
//        longitude = cc2.longitude;
//        latitude = cc2.latitude;
//    }
}

#pragma mark -
#pragma mark - UIAlertView

-(void)alert:(NSString *)message autoDismiss:(BOOL)autoDismiss
{
    if (alertView) {
        [alertView release];
    }

    alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alertView  show];
    
    if (autoDismiss) {
        [NSTimer scheduledTimerWithTimeInterval:3.0f
                                         target:self
                                       selector:@selector(dismissAlertAnimation:)
                                       userInfo:nil
                                        repeats:NO];
    }else{
        UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125.0, 80.0, 30.0, 30.0)];
        aiView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        aiView.color = [UIColor grayColor];
        //check if os version is 7 or above. ios7.0及以上UIAlertView弃用了addSubview方法
        if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending) {
            [alertView setValue:aiView forKey:@"accessoryView"];
        }else{
            [alertView addSubview:aiView];
        }
        [aiView startAnimating];
        [aiView release];
    }
}

-(void)dismissAlertAnimation:(NSTimer*)Timer
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)dismissAlertAnimation{
    
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

@end
