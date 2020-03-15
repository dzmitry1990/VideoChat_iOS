//
//  ActivityIndicatorHelper.h
//  ColorCall
//
//  Created by Dzmitry Zhuk on 4/9/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityIndicatorHelper : NSObject
- (id)initWithController:(UIViewController *)controller;
@property (nonatomic, assign) BOOL visibility;
@end
