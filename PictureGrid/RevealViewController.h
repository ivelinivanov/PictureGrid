//
//  RevealViewController.h
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/6/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "PKRevealController.h"

@interface RevealViewController : PKRevealController

@property (strong, nonatomic) UINavigationController *navigation;

@property (strong, nonatomic) UIViewController *pictureGrid;
@property (strong, nonatomic) UIViewController *login;
@property (strong, nonatomic) UIViewController *myPhotos;
@property (strong, nonatomic) UIViewController *favorites;

@end
