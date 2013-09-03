//
//  DetailPictureViewController.h
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/7/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGImage.h"


@interface DetailPictureViewController : UIViewController <UIAlertViewDelegate>

@property (strong,nonatomic) PGImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

-(IBAction)shareButtonPressed:(id)sender;

@end
