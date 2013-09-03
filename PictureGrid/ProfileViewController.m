//
//  ProfileViewController.m
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/7/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "ProfileViewController.h"
#import "RevealViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.nameLabel.text = [defaults objectForKey:@"name"];
    
    NSString *imageUrl = [defaults objectForKey:@"image"];
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    self.profileImage.image = [UIImage imageWithData:imageData];
    
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    UIBarButtonItem *logOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(logOutButtonPressed)];
    self.navigationItem.rightBarButtonItem = logOutButton;
}

-(IBAction)menuButtonPressed
{
    RevealViewController *revealController = (RevealViewController *)self.parentViewController.parentViewController;
    [revealController showViewController:revealController.leftViewController];
}

-(IBAction)logOutButtonPressed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You are about to log out!"
                                                    message:@"Are you sure?"
                                                   delegate:self
                                          cancelButtonTitle:@"Yes"
                                          otherButtonTitles:@"No", nil];
    [alert show];
   
}

#pragma mark - AlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults removeObjectForKey:@"frob"];
        [defaults removeObjectForKey:@"token"];
        [defaults removeObjectForKey:@"userID"];
        [defaults removeObjectForKey:@"name"];
        [defaults removeObjectForKey:@"image"];
        [defaults synchronize];
        
        [self performSegueWithIdentifier:@"toLogin" sender:self];
    }
}

@end
