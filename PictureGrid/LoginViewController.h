//
//  LoginViewController.h
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/6/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewControllerConstants.h"

@interface LoginViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

+(BOOL)isLoggedIn;

@end
