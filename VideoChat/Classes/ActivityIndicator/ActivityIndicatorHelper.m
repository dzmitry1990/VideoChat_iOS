//
//  ActivityIndicatorHelper.m
//  ColorCall
//
//  Created by Dzmitry Zhuk on 4/9/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

#import "ActivityIndicatorHelper.h"
#import "MBProgressHUD.h"

@interface ActivityIndicatorHelper() {
    MBProgressHUD *hud;
}

@end

@implementation ActivityIndicatorHelper

- (id)initWithController:(UIViewController *)controller {
    self = [[ActivityIndicatorHelper alloc] init];

    hud = [[MBProgressHUD alloc] initWithView:controller.view];
    hud.label.text = @"Loading…";
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = NO;

    [controller.view addSubview:hud];

    self.visibility = NO;

    return self;
}

- (void)setVisibility:(BOOL)visibility {
    _visibility = visibility;

    if ( _visibility ) {
        [hud bringSubviewToFront:hud.superview];
        [hud showAnimated:NO];
    } else {
        [hud hideAnimated:YES];
    }

    [UIApplication sharedApplication].networkActivityIndicatorVisible = _visibility;
}
@end
