//
//  LoadingView.m
//  PictureGrid
//
//  Created by Ivelin Ivanov on 7/31/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

-(id)init
{
    self = [[[NSBundle mainBundle]loadNibNamed:[NSString stringWithFormat:@"%@",NSStringFromClass([self class])] owner:self options:nil]lastObject];
    if (self)
    {
        
    }
    
    return self;
}

@end
