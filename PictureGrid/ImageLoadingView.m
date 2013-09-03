//
//  ImageLoadingView.m
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/2/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "ImageLoadingView.h"

@implementation ImageLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)init
{
    self = [[[NSBundle mainBundle]loadNibNamed:[NSString stringWithFormat:@"%@",NSStringFromClass([self class])] owner:self options:nil]lastObject];
    if (self)
    {
        
    }
    
    return self;
}

@end
