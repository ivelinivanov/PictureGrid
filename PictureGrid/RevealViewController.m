//
//  RevealViewController.m
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/6/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "RevealViewController.h"

@implementation RevealViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    self.navigation = [storyboard instantiateViewControllerWithIdentifier:@"navigationController"];
    self.frontViewController = self.navigation;
    
    self.pictureGrid = [storyboard instantiateViewControllerWithIdentifier:@"pictureGrid"];
    self.navigation.viewControllers = [NSArray arrayWithObject:self.pictureGrid];
    
    self.login = [storyboard instantiateViewControllerWithIdentifier:@"login"];
    
    self.myPhotos = [storyboard instantiateViewControllerWithIdentifier:@"myPhotos"];
    
    self.favorites = [storyboard instantiateViewControllerWithIdentifier:@"favorites"];
    
    self.leftViewController = [storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    
    [self setMinimumWidth:220  maximumWidth:220 forViewController:self.leftViewController];
}

@end
