//
//  MyPhotosViewController.m
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/8/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "MyPhotosViewController.h"
#import "RevealViewController.h"
#import "LoginViewController.h"
#import "MyPhotosWebService.h"
#import "RevealViewController.h"
#import "PGImage.h"
#import "PictureGridCell.h"
#import "DetailPictureViewController.h"

@implementation MyPhotosViewController


- (void)viewDidLoad
{
    // Do any additional setup after loading the view.
    [self resetCoordinates];
    self.images = [[NSMutableArray alloc] init];
    reusableCells = [[NSMutableArray alloc] init];
    imagePerRow = UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]) ? kMaximumImagesForLandscape : kMaximumImagesForPortrait;
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonClicked)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    [self loadImages];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scrollView.delegate = self;
    
    [self rearangeImagesForOrientation];
}

-(void)loadImages
{
    [self showLoadingAnimation];
    
        MyPhotosWebService *service = [[MyPhotosWebService alloc] init];
        [service getPhotos:^(NSMutableArray *resultArray)
         {
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                      (unsigned long)NULL), ^(void)
                            {
                                for (PGImage *currentImage in resultArray)
                                {
                                    dispatch_async(dispatch_get_main_queue(),^(void)
                                                   {
                                                       [self addImage:currentImage];
                                                   });
                                }
                                dispatch_async(dispatch_get_main_queue(),^(void)
                                               {
                                                   [self hideLoadingAnimation];
                                               });
                            });
         }];
}

#pragma mark - ScrollView Delegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self retreiveAlivePictureGridCells];
    [self refreshImages];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y < -50)
    {
        NSLog(@"Drag");
        [self.images removeAllObjects];
        
        for (UIView *view in self.scrollView.subviews)
        {
            if ([view isKindOfClass:[PictureGridCell class]])
            {
                [reusableCells addObject:view];
            }
        }
        
        [self resetCoordinates];
        [self loadImages];
    }
}


#pragma mark - IBAction Methods

-(void)imageClicked:(UIGestureRecognizer *)sender
{
    PictureGridCell *cell = (PictureGridCell *)sender.delegate;
    selectedImage = self.images[cell.tag - 1];
    
    [self performSegueWithIdentifier:@"fromPhotosToDetail" sender:self];
    
}

@end
