//
//  CheckInWebService.m
//  i4Square
//
//  Created by Ivelin Ivanov on 7/26/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "ImageSearchService.h"

@implementation ImageSearchService

-(void)getImages:(void (^)(NSMutableArray *))block amount:(int)amount
{
    ImageSearchServiceWorker *serviceWorker = [[ImageSearchServiceWorker alloc] init];
    [serviceWorker getImages:block amount:amount];
}

@end
