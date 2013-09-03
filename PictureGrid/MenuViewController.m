//
//  MenuViewController.m
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/6/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "MenuViewController.h"
#import "RevealViewController.h"
#import "PictureGridViewController.h"
#import "LoginViewController.h"

@interface MenuViewController ()
{
    NSArray *menuOptions;
//    UINavigationController *pictureGridNavigationController;
//    UINavigationController *loginNavigationController;
}

@end

@implementation MenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    menuOptions = @[@"Recently Popular", @"Account", @"My Photos", @"Favorites"];
    
    [self.tableView reloadData];
    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [menuOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = menuOptions[indexPath.row];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RevealViewController *revealController = (RevealViewController *)self.parentViewController;
    
    switch (indexPath.row)
    {
        case 0:
            revealController.navigation.viewControllers = [NSArray arrayWithObject:revealController.pictureGrid];
            break;
        case 1:
            revealController.navigation.viewControllers =  [NSArray arrayWithObject:revealController.login];
            break;
        case 2:
            if ([LoginViewController isLoggedIn])
            {
                revealController.navigation.viewControllers =  [NSArray arrayWithObject:revealController.myPhotos];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You are not logged in!"
                                                                message:@"You will be redirected to login page"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                revealController.myPhotos = [storyboard instantiateViewControllerWithIdentifier:@"myPhotos"];
                revealController.favorites = [storyboard instantiateViewControllerWithIdentifier:@"favorites"];
                revealController.navigation.viewControllers = [NSArray arrayWithObject:revealController.login];
            }
            break;
        case 3:
            if ([LoginViewController isLoggedIn])
            {
                revealController.navigation.viewControllers = [NSArray arrayWithObject: revealController.favorites];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You are not logged in!"
                                                                message:@"You will be redirected to login page"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                revealController.myPhotos = [storyboard instantiateViewControllerWithIdentifier:@"myPhotos"];
                revealController.favorites = [storyboard instantiateViewControllerWithIdentifier:@"favorites"];
                revealController.navigation.viewControllers = [NSArray arrayWithObject: revealController.login];
            }            
            break;
        default:
            break;
    }
    
    
    [revealController showViewController:revealController.frontViewController];
}

@end
