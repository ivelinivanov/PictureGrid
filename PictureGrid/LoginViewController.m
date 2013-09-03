//
//  LoginViewController.m
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/6/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+MD5.h"
#import "FlickrLoginService.h"
#import "ProfileViewController.h"
#import "RevealViewController.h"

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonClicked)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self logIn];
}

-(IBAction)menuButtonClicked
{
    RevealViewController *revealController = (RevealViewController *)self.parentViewController.parentViewController;
    [revealController showViewController:revealController.leftViewController];
}

-(void)logIn
{
    if (![LoginViewController isLoggedIn])
    {
        [self.activityIndicator startAnimating];
        self.activityIndicator.hidesWhenStopped = YES;
        
        [FlickrLoginService getFrob:^(NSString *frob)
         {
             NSLog(@"%@",frob);
             
             NSString *stringForMD5 = [[NSString alloc] initWithFormat:kMD5String,frob];
             NSString *MD5String = [stringForMD5 MD5String];
             
             NSString *url = [[NSString alloc] initWithFormat:kWebViewURL,frob,MD5String];
             
             NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
             self.webView.delegate = self;
             
             NSHTTPCookie *cookie;
			 NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
             for (cookie in [storage cookies])
             {
                 [storage deleteCookie:cookie];
             }
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             [self.webView loadRequest:request];
             
         }];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"profile"] animated:NO];
    }

}

-(void)retreiveUserInformation
{
    [FlickrLoginService getUserID:^(NSString *userID)
     {
         NSLog(@"%@",userID);
         [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"userID"];
                  
         [FlickrLoginService getUserInfo:^(NSDictionary *resultDictionary)
          {
              NSLog(@"%@", resultDictionary);
              NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
              [defaults setObject:resultDictionary[@"name"] forKey:@"name"];
              [defaults setObject:resultDictionary[@"image"] forKey:@"image"];
              [defaults synchronize];
              
              [self performSegueWithIdentifier:@"toProfile" sender:self];
              
          }];
     }];
    
    [self.activityIndicator stopAnimating];
}

+(BOOL)isLoggedIn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL flag = YES;
    
    if (![defaults objectForKey:@"frob"])
    {
        flag = NO;
    }
    if (![defaults objectForKey:@"token"])
    {
        flag = NO;
    }
    if (![defaults objectForKey:@"image"])
    {
        flag = NO;
    }
    if (![defaults objectForKey:@"name"])
    {
        flag = NO;
    }
    if (![defaults objectForKey:@"userID"])
    {
        flag = NO;
    }
    
    if(flag)
    {
        return YES;
    }
    else
    {
        [defaults removeObjectForKey:@"frob"];
        [defaults removeObjectForKey:@"token"];
        [defaults removeObjectForKey:@"userID"];
        [defaults removeObjectForKey:@"name"];
        [defaults removeObjectForKey:@"image"];
        
        return NO;
    }
}

#pragma mark - WebView Delegate Methods

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
	NSString *url =[[request URL] absoluteString];
    
    if ([url isEqualToString:@"http://m.flickr.com/#/services/auth/"])
    {
        [FlickrLoginService getToken:^(NSString *token)
        {
            NSLog(@"%@", token);
            [self.activityIndicator startAnimating];
            self.activityIndicator.hidden = NO;
            
            self.webView.hidden = YES;
            
            [self retreiveUserInformation];
        }];
    }
    
    return YES;
}

@end
