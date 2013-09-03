//
//  DetailPictureViewController.m
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/7/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "DetailPictureViewController.h"
#import "AddToFavWebService.h"
#import "RemoveFromFav.h"
#import "RecentlyPopularViewController.h"
#import "RevealViewController.h"
#import "FavoritesViewController.h"
#import "MyPhotosViewController.h"

@interface DetailPictureViewController ()

@end

@implementation DetailPictureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonPressed:)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"♥" style:UIBarButtonItemStylePlain target:self action:@selector(likeButtonPressed:)];
    
    if(![[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[MyPhotosViewController class]])
    {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:shareButton, addButton, nil];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = shareButton;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidesWhenStopped = YES;
    
    __block UIImage *largeImage;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void)
                   {
                       dispatch_async(dispatch_get_main_queue(),^(void)
                                      {
                                          largeImage = [self.image getImage:@"z"];
                                      });
                       dispatch_async(dispatch_get_main_queue(),^(void)
                                      {
                                          self.imageView.image = largeImage;
                                          [self.activityIndicator stopAnimating];
                                      });
                   });
}

-(IBAction)likeButtonPressed:(id)sender
{
    AddToFavWebService *service = [[AddToFavWebService alloc] init];
    [service addToFav:^(NSString *result)
     {
         if([result isEqualToString:@"ok"])
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                             message:@"Picture added to favorites"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
             [alert show];
         }
         else if ([result isEqualToString:@"owned"])
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                             message:@"You can't add pictures you own to your favorites!"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
             [alert show];
         }
         else if ([result isEqualToString:@"inFavorites"])
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Picture is already in favorites!"
                                                             message:@"Do you want it removed?"
                                                            delegate:self
                                                   cancelButtonTitle:@"Yes"
                                                   otherButtonTitles:@"No", nil];
             [alert show];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"Can't add picture to favorites!"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
             [alert show];
         }
         
     } withPhotoID: self.image.photoID];
}

- (IBAction)shareButtonPressed:(id)sender
{
    NSArray *activityItems = @[self.imageView.image];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
    activityController.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        RemoveFromFav *service = [[RemoveFromFav alloc] init];
        [service removeFromFav:^(BOOL result)
         {
             if(result)
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                                 message:@"Picture removed from favorites!"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles: nil];
                 [alert show];
                 
                 [self.navigationController popToRootViewControllerAnimated:YES];
             }
         }withPhotoID:self.image.photoID];
    }
}

@end
