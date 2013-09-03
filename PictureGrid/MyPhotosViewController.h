//
//  MyPhotosViewController.h
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/8/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "PictureGridConstants.h"
#import "PictureGridViewController.h"

@interface MyPhotosViewController : PictureGridViewController

@property (strong, nonatomic) NSMutableArray *images;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet LoadingView *loadingView;

@end
