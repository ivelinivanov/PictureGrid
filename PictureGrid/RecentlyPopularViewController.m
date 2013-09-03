//
//  RecentlyPopularViewController.m
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/13/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "RecentlyPopularViewController.h"

@interface RecentlyPopularViewController ()

@end

@implementation RecentlyPopularViewController

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
	// Do any additional setup after loading the view.
}

#pragma mark - ScrollView Delegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    
    if (bottomEdge >= scrollView.contentSize.height)
    {
        [self loadImages:kSequentialLoadQuantity];
    }
    
    [self retreiveAlivePictureGridCells];
    [self refreshImages];
}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self retreiveAlivePictureGridCells];
    [self refreshImages];
}


@end
