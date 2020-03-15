//
//  PermissionsViewController.h
//  Cheetah
//
//  Created by Dzmitry Zhuk on 5/8/17.
//  Copyright © 2017 Fam, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PermissionsViewController : BaseViewController
-(void)didTapLocationButton;
-(void) didTapCameraButton;
-(void)didTapMicrophoneButton;
-(void)didTapPushNotification;
- (void)updateLocationButton:(BOOL) isEnabled ;
- (void)updateCameraButton:(BOOL) isEnabled;
- (void)updateMicrophoneButton:(BOOL) isEnabled;
- (void)updateNotificationButton:(BOOL) isEnabled;
@end
