//
//  ViewController.m
//  PictureGrid
//
//  Created by Ivelin Ivanov on 7/29/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "PictureGridViewController.h"
#import "RevealViewController.h"

@implementation PictureGridViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self resetCoordinates];
    self.images = [[NSMutableArray alloc] init];
    reusableCells = [[NSMutableArray alloc] init];
    imagePerRow = kMaximumImagesForPortrait;
    [self loadImages:kInitialLoadQuantity];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonClicked)];
    self.navigationItem.leftBarButtonItem = menuButton;
}

-(IBAction)menuButtonClicked
{
    RevealViewController *revealController = (RevealViewController *)self.parentViewController.parentViewController;
    [revealController showViewController:revealController.leftViewController];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.scrollView.delegate = self;
    [self rearangeImagesForOrientation];
}



-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self rearangeImagesForOrientation];
}

#pragma mark - Image Positioning & Loading Methods

-(void)rearangeImagesForOrientation
{
    UIDevice *device = [UIDevice currentDevice];
    
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            [self repositionImages:kMaximumImagesForPortrait];
            break;
        case UIDeviceOrientationLandscapeLeft:
            [self repositionImages:[[UIScreen mainScreen] bounds].size.height == kPixelBoundaryForLandscape ? kMaximumImagesForLandscape : kMaximumImagesForSmallLandscape];
            break;
        case UIDeviceOrientationLandscapeRight:
            [self repositionImages:[[UIScreen mainScreen] bounds].size.height == kPixelBoundaryForLandscape ? kMaximumImagesForLandscape : kMaximumImagesForSmallLandscape];
        default:
            break;
    }
}

-(void)resetCoordinates
{
    imageColumnCounter = 0;
    imageRowCounter = 0;
    xOrigin = 0.0;
    yOrigin = 0.0;
}

-(PictureGridCell *)getReusableCell
{
    if ([reusableCells count] != 0)
    {
        PictureGridCell *reusableCell = [reusableCells lastObject];
        [reusableCells removeLastObject];
        reusableCell.image = nil;
        reusableCell.tag = 0;
        
        return reusableCell;
    }
    else
    {
        PictureGridCell *cell = [[PictureGridCell alloc] init];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
        recognizer.numberOfTapsRequired = 1;
        recognizer.numberOfTouchesRequired = 1;
        recognizer.delegate = cell;
        
        [cell addGestureRecognizer: recognizer];
       
        return cell;
    }
}

-(void)incrementCoordinates
{
    imageColumnCounter++;
    xOrigin += kImageSize + kImageOffset;
    
    if(imageColumnCounter == imagePerRow)
    {
        yOrigin += kImageSize + kImageOffset;
        xOrigin = 0;
        imageRowCounter ++;
        imageColumnCounter = 0;
    }
}

-(void)addImage:(PGImage *)image
{
    
    CGRect cellFrame = CGRectMake(xOrigin, yOrigin, kImageSize, kImageSize);
    
    image.xOrigin = cellFrame.origin.x;
    image.yOrigin = cellFrame.origin.y;

    [self incrementCoordinates];

     
    [self.images addObject:image];
    
    if (CGRectIntersectsRect(cellFrame, self.scrollView.bounds))
    {
        PictureGridCell *cell = [self getReusableCell];
        cell.frame = cellFrame;
        cell.contentMode = UIViewContentModeScaleAspectFit;
        cell.tag = [self.images count];
        
        [self.scrollView addSubview:cell];
        [self.scrollView setNeedsDisplay];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long)NULL), ^(void)
                       {
                           UIImage *cellImage = [image getImage:@"s"];
                           
                           dispatch_async(dispatch_get_main_queue(),^(void)
                                          {
                                              cell.image = cellImage;
                                          });
                       });
    }
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, (imageColumnCounter == 0 ? yOrigin : yOrigin + kImageOffset + kImageSize) + kLoadingBarHeight);
}

-(CGPoint)getContentOffsetForNewOrientation:(NSUInteger) maximumImagesPerRow
{
    //calculate new contentOffset
    CGPoint currentOffset = [self.scrollView contentOffset];
    
    float currentRow = roundf(currentOffset.y / kImageSize);
    float numberOfPictures = roundf(currentRow * imagePerRow);
    float rowToLocate = roundf((numberOfPictures / maximumImagesPerRow));
    float yOffsetToLocateTo = rowToLocate * (kImageSize + kImageOffset);
    
    CGFloat maximumYOffset = self.scrollView.contentSize.height - self.view.frame.size.height;
    
    CGPoint newOffset = currentOffset;
    newOffset.y = yOffsetToLocateTo;
    
    if(newOffset.y > maximumYOffset)
    {
        newOffset.y -= 2 * (kImageOffset + kImageSize);
    }
    
    return newOffset;
}

-(void)setScrollViewBounds:(CGPoint)newOffset imagesPerRow:(NSUInteger)maximumImagesPerRow
{
    if (maximumImagesPerRow == kMaximumImagesForPortrait)
    {
        self.scrollView.bounds = CGRectMake(newOffset.x,newOffset.y,kBoundsWidth,kBoundsHeight);
    }
    else
    {
        self.scrollView.bounds = CGRectMake(newOffset.x,newOffset.y,kBoundsHeight,kBoundsWidth);
    }
}

-(void)repositionImages:(NSUInteger) maximumImagesPerRow
{
    if (imagePerRow != maximumImagesPerRow)
    {        
        CGPoint newOffset = [self getContentOffsetForNewOrientation:maximumImagesPerRow];
        [self setScrollViewBounds:newOffset imagesPerRow:maximumImagesPerRow];
        
        [self resetCoordinates];
        
        CGRect newFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.scrollView.frame = newFrame;
        
        imagePerRow = maximumImagesPerRow;
        
        for (PGImage *image in self.images)
        {
            CGRect cellFrame = CGRectMake(xOrigin, yOrigin, kImageSize, kImageSize);
            
            [self incrementCoordinates];
            
            image.xOrigin = cellFrame.origin.x;
            image.yOrigin = cellFrame.origin.y;
        }
        
        
        self.scrollView.contentOffset = newOffset;
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, (imageColumnCounter == 0 ? yOrigin : yOrigin + kImageOffset + kImageSize) + kLoadingBarHeight);
        
        [self retreiveAlivePictureGridCells];
        [self refreshImages];
    }
}

-(void)refreshImages
{
    for (int i = 0; i < [self.images count]; i++)
    {
        PGImage *image = self.images[i];
        CGRect rect = CGRectMake(image.xOrigin, image.yOrigin, kImageSize, kImageSize);
        
        if(CGRectIntersectsRect(rect, self.scrollView.bounds))
        {
            if (![self.scrollView viewWithTag:i + 1])
            {
                PictureGridCell *cell = [self getReusableCell];
                
                cell.frame = rect;
                cell.contentMode = UIViewContentModeScaleAspectFit;
                cell.tag = i + 1;
                
                [self.scrollView addSubview:cell];
                [self.scrollView setNeedsDisplay];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long)NULL), ^(void)
                               {
                                   UIImage *cellImage = [image getImage:@"s"];
                                   dispatch_async(dispatch_get_main_queue(),^(void)
                                                  {
                                                      cell.image = cellImage;
                                                  });
                               });
                
            }
            else
            {
                PictureGridCell *cell = (PictureGridCell *)[self.scrollView viewWithTag:i + 1];
                cell.frame = rect;
            }
        }
    }
    
    NSLog(@"Now you have %d reusable cells!", [reusableCells count]);
}

-(void)loadImages:(int)amount
{
    [self showLoadingAnimation];
    
    ImageSearchService *service = [[ImageSearchService alloc] init];
    
    [service getImages:^(NSMutableArray *resultArray)
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
     } amount:amount];
    
}

-(void)retreiveAlivePictureGridCells
{
    for (UIView *view in [self.scrollView subviews])
    {
        if([view isKindOfClass:[PictureGridCell class]])
        {
            if (!CGRectIntersectsRect(view.frame, self.scrollView.bounds))
            {
                [view removeFromSuperview];
                view.tag = 0;
                [reusableCells addObject:view];
            }
        }
    }
    
    NSLog(@"You now have %d reusable cells!", [reusableCells count]);
}


#pragma mark - Show / Hide Loading Animation Methods

-(void)showLoadingAnimation
{
    [self.loadingView.activityIndicator startAnimating];
    self.loadingView.activityIndicator.hidden = NO;
    self.loadingView.hidden = NO;
}

-(void)hideLoadingAnimation
{
    [self.loadingView.activityIndicator stopAnimating];
    self.loadingView.activityIndicator.hidden = YES;
    self.loadingView.hidden = YES;
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



#pragma mark - IBAction Methods

-(void)imageClicked:(UIGestureRecognizer *)sender
{    
    PictureGridCell *cell = (PictureGridCell *)sender.delegate;
    selectedImage = self.images[cell.tag - 1];

    [self performSegueWithIdentifier:@"toDetailView" sender:self];

}

#pragma mark - Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailPictureViewController *detailView = (DetailPictureViewController *)[segue destinationViewController];
    detailView.image = selectedImage;
}

@end
