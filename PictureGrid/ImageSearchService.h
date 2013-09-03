//
//  CheckInWebService.h
//  i4Square
//
//  Created by Ivelin Ivanov on 7/26/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageSearchServiceWorker.h"

@interface ImageSearchService : NSObject

-(void)getImages:(void (^)(NSMutableArray *))block amount:(int)amount;

@end
