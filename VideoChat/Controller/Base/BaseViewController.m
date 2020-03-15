//
//  BaseViewController.m
//  Emoji+
//
//  Created by Dzmitry Zhuk on 3/23/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController {
    BOOL isContentOffsetInitialized;
    CGPoint originalScrollViewContentOffset;
}

@synthesize loadingIndicator;

- (instancetype)initWithCoder:(NSCoder *)coder {
    if ( self = [super initWithCoder:coder] ) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController != nil) {
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
    }
    
    loadingIndicator = [[ActivityIndicatorHelper alloc] initWithController:self];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self unregisterFromKeyboardNotifications];
    
    [super viewWillDisappear:animated];
}

-(void)setViewBorder: (nonnull UIView *)view color:(UIColor *)color {
    view.layer.borderColor = color.CGColor;
}

- (void)setButton:(nonnull UIButton *)button enabled:(BOOL)enabled {
    button.enabled = enabled;
    button.alpha = enabled ? 1.0f : .5f;
}

- (void)showAlertWithError:(NSError *)error {
    NSString *message = error.localizedDescription;
    if ( error.localizedFailureReason ) {
        message = [message stringByAppendingString:error.localizedFailureReason];
    }

    [self showAlertWithErrorMessage:message];
}

- (void)showAlertWithErrorMessage:(nonnull NSString *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:error preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];

    [self runInMainThread:^{
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message actionTitle:(nullable NSString *)actionTitle {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    if ( !actionTitle ) { actionTitle = @"OK"; }
    UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];

    [self runInMainThread:^{
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)showAlertWithoutAction:(nullable NSString *)title message:(nullable NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self runInMainThread:^{
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)showNoInternetConnectionAlert {
    [self showAlertWithTitle:@"Sorry" message:@"You have no Internet Connection." actionTitle:nil];
}

- (void)showNoInternetConnectionAlertWith:(void (^ __nonnull)(UIAlertAction* _Nonnull action))actionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"You have no Internet Connection."
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:actionHandler];
    [alert addAction:action];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                             [self.navigationController popViewControllerAnimated:YES];
                                                         }];
    [alert addAction:cancelAction];

    [self runInMainThread:^{
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)showAlertWith:(nullable NSString *)title message:(nullable NSString *)message handler:(void (^ __nonnull)(UIAlertAction* _Nonnull action))actionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:actionHandler];
    [alert addAction:action];
    
    [self runInMainThread:^{
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)runInMainThread:(dispatch_block_t) block {
    dispatch_async(dispatch_get_main_queue(), block);
}

#pragma mark - Handle keyboard
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)unregisterFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillBeShown:(NSNotification *)notification {
    UIScrollView *scrollView = [self getViewAsScrollView];
    UIView *bottomView = [self getBottomView];

    if ( !scrollView || !bottomView ) {
        if (scrollView != nil) {
            originalScrollViewContentOffset = scrollView.contentOffset;
        }
        
        return;
    }

    if ( !isContentOffsetInitialized ) {
        isContentOffsetInitialized = YES;
        originalScrollViewContentOffset = scrollView.contentOffset;
    }

    NSDictionary *info = [notification userInfo];

    CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    CGRect visibleRect = scrollView.frame;
    visibleRect.size.height -= kbSize.height;
    //TODO: Check negative scroll view content offset

    CGFloat padding = [self getPaddingBetweenBottomViewAndKeyboard];
    CGFloat y = bottomView.frame.origin.y + bottomView.frame.size.height + padding;
    if ( !CGRectContainsPoint(visibleRect, CGPointMake(.0f, y)) ) {
        CGFloat scrollY = y - visibleRect.size.height;
        [scrollView setContentOffset:CGPointMake(.0f, scrollY) animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    UIScrollView *scrollView = [self getViewAsScrollView];
    [scrollView setContentOffset:originalScrollViewContentOffset animated:YES];
}

- (UIScrollView *)getViewAsScrollView {
return [self.view isKindOfClass:[UIScrollView class]] ? (UIScrollView *)self.view : nil;
}

- (UIView *)getBottomView {
    return nil;
}

- (CGFloat)getPaddingBetweenBottomViewAndKeyboard {
    return 8;
}

@end
