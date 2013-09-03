//
//  ViewController.h
//  PictureGrid
//
//  Created by Ivelin Ivanov on 7/29/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageSearchService.h"
#import "PictureGridConstants.h"
#import "PictureGridCell.h"
#import "LoadingView.h"
#import "PGImage.h"
#import "DetailPictureViewController.h"

@class PictureGridViewController;

@interface PictureGridViewController : UIViewController <UIScrollViewDelegate>
{
    double xOrigin;
    double yOrigin;
    int imageColumnCounter;
    int imageRowCounter;
    int imagePerRow;
    NSMutableArray *reusableCells;
    PGImage *selectedImage;
}

@property (strong, nonatomic) NSMutableArray *images;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet LoadingView *loadingView;

-(IBAction)menuButtonClicked;
-(void)rearangeImagesForOrientation;
-(void)resetCoordinates;
-(PictureGridCell *)getReusableCell;
-(void)incrementCoordinates;
-(void)addImage:(PGImage *)image;
-(CGPoint)getContentOffsetForNewOrientation:(NSUInteger) maximumImagesPerRow;
-(void)setScrollViewBounds:(CGPoint)newOffset imagesPerRow:(NSUInteger)maximumImagesPerRow;
-(void)repositionImages:(NSUInteger) maximumImagesPerRow;
-(void)refreshImages;
-(void)retreiveAlivePictureGridCells;
-(void)showLoadingAnimation;
-(void)hideLoadingAnimation;
-(void)imageClicked:(UIGestureRecognizer *)sender;
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
-(void)loadImages:(int)amount;

@end
