//
//  BaseViewController.h
//  Emoji+
//
//  Created by Dzmitry Zhuk on 3/23/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityIndicatorHelper.h"

@class Preferences;

@interface BaseViewController : UIViewController

@property (nonatomic, readonly) ActivityIndicatorHelper* _Nonnull loadingIndicator;

- (UIView * _Nullable)getBottomView;
- (CGFloat)getPaddingBetweenBottomViewAndKeyboard;

- (void)keyboardWillBeShown:(nonnull NSNotification *)notification;
- (void)keyboardWillBeHidden:(nonnull NSNotification *)notification;

- (void)setButton:(nonnull UIButton *)button enabled:(BOOL)enabled;
-(void)setViewBorder: (nonnull UIView *)view color:(UIColor *)color;
- (void)showAlertWithError:(nonnull NSError *)error;
- (void)showAlertWithErrorMessage:(nonnull NSString *)error;
- (void)showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message actionTitle:(nullable NSString *)actionTitle;
- (void)showAlertWithoutAction:(nullable NSString *)title message:(nullable NSString *)message;
- (void)showNoInternetConnectionAlert;
- (void)showNoInternetConnectionAlertWith:(void (^ __nonnull)(UIAlertAction* _Nonnull action))actionHandler;
- (void)showAlertWith:(nullable NSString *)title message:(nullable NSString *)message handler:(void (^ __nonnull)(UIAlertAction* _Nonnull action))actionHandler;
@end
