//
//  FavoritesViewController.h
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/8/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "PictureGridViewController.h"

@interface FavoritesViewController : PictureGridViewController

@property (strong, nonatomic) NSMutableArray *images;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet LoadingView *loadingView;

@end
