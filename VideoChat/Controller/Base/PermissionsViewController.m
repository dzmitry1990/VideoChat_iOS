//
//  PermissionsViewController.m
//  Video Chat
//
//  Created by Dzmitry Zhuk on 5/8/17.
//  Copyright © 2017 Fam, Inc. All rights reserved.
//

#import "PermissionsViewController.h"
#import <UserNotifications/UserNotifications.h>

@import CoreLocation;
@import AVFoundation;

@interface PermissionsViewController ()<CLLocationManagerDelegate>
{
    BOOL launchedMatchViewController;
}

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation PermissionsViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    if ( self = [super initWithCoder:coder] ) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateButtonsBasedOnPermissions];

    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];

    
    
}
-(void) applicationWillEnterForeground {
    
    NSLog(@"applicationWillEnterForeground");

    [self updateButtonsBasedOnPermissions];
    [self launchMatchViewControllerIfAuthorizationFinished];
}

-(void)updateButtonsBasedOnPermissions {
    //check location permission
    BOOL locationEnabled=([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse);
    [self updateLocationButton: locationEnabled];
    //check camera permission
    AVAuthorizationStatus cameraAuthorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    [self updateCameraButton: cameraAuthorizationStatus == AVAuthorizationStatusAuthorized];
    //check microphone permission
    AVAuthorizationStatus microphoneAuthorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    [self updateMicrophoneButton: microphoneAuthorizationStatus == AVAuthorizationStatusAuthorized];
    
    [[UNUserNotificationCenter currentNotificationCenter]getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            [self updateNotificationButton:YES];
        } else {
            [self updateNotificationButton:NO];
        }
    }];
}

- (void)updateLocationButton:(BOOL) isEnabled {
    
}

- (void)updateCameraButton:(BOOL) isEnabled {
    
}

- (void)updateMicrophoneButton:(BOOL) isEnabled {
    
}

- (void)updateNotificationButton:(BOOL) isEnabled {
    
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

-(void)didTapLocationButton {
    
    
    //http://stackoverflow.com/questions/15153074/checking-location-service-permission-on-ios
    
    if(![CLLocationManager locationServicesEnabled])
    {
        
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Video Chat needs access to location"
                                              message:@"Please turn on location for your device"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Sure"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Ok action");
                                       
                                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"] options:nil completionHandler:nil];
                                       
                                   }];
        
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else {
        
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
    }
    
    
    
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    __weak typeof(self) weakSelf = self;
    
    NSLog(@"locationManager didChangeAuthorizationStatus %d",status);
    if(status==kCLAuthorizationStatusDenied)
    {
        NSLog(@"user denied location");
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Video Chat needs access to location"
                                              message:@"Please give Video Chat access to location in the Settings app"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Sure"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Ok action");
                                       
                                       
                                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

                                       
                                   }];
        
        
        [alertController addAction:okAction];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        });
        
    }
    //enabled
    else if(status==kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        NSLog(@"accepted location");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateLocationButton:YES];
            [weakSelf launchMatchViewControllerIfAuthorizationFinished];

        });
        
    }
    
}
-(void) didTapCameraButton {
    
    __weak typeof(self) weakSelf = self;
    
    //http://stackoverflow.com/questions/25803217/presenting-camera-permission-dialog-in-ios-8
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if(granted){ // Access has been granted ..do something
            
            NSLog(@"authorized camera");
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf updateCameraButton:YES];
                [weakSelf launchMatchViewControllerIfAuthorizationFinished];

            });
            
        } else { // Access denied ..do something
            
            NSLog(@"denied camera");
            
            
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Video Chat needs access to camera"
                                                  message:@"Please give Video Chat access to camera in the Settings app"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"Sure"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Ok action");
                                           
                                           
                                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                           
                                       }];
            
            
            [alertController addAction:okAction];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf presentViewController:alertController animated:YES completion:nil];

            });
            
        }
        
    }];
    
}
-(void)didTapMicrophoneButton {
    
    
    __weak typeof(self) weakSelf = self;
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        if(granted){ // Access has been granted ..do something
            
            NSLog(@"authorized microphone");
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf updateMicrophoneButton:YES];
                [weakSelf launchMatchViewControllerIfAuthorizationFinished];

            });
            
        } else { // Access denied ..do something
            
            NSLog(@"denied microphone");
            
            
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Video Chat needs access to microphone"
                                                  message:@"Please give Video Chat access to microphone in the Settings app"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"Sure"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Ok action");
                                           
                                           
                                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                           
                                       }];
            
            
            [alertController addAction:okAction];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf presentViewController:alertController animated:YES completion:nil];

            });
        }
        
        
        
    }];
    
    
}

-(void)didTapPushNotification {
    __weak typeof(self) weakSelf = self;
    
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            [self updateNotificationButton:YES];
        } else {
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Video Chat needs access to push notification"
                                                  message:@"Please give Video Chat access to push notification in the Settings app"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"Sure"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           
                                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                           
                                       }];
            
            
            [alertController addAction:okAction];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf presentViewController:alertController animated:YES completion:nil];
                
            });
        }
    }];
    
}

-(void)requestPushPermissions {

}

-(BOOL)userAuthorizedAllPermissions {
    
    return NO;
}

-(void)launchMatchViewControllerIfAuthorizationFinished {
    
    NSLog(@"launchedMatchViewController %@",launchedMatchViewController ? @"YES" : @"NO");
    if(launchedMatchViewController)
        return;
    
    if([self userAuthorizedAllPermissions])
    {
        launchedMatchViewController=YES;
        
        NSLog(@"dismissViewControllerAnimated");

        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
            
        });
    }
    
}
@end
