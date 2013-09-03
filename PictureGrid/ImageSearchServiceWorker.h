//
//  CheckInWebServiceWorker.h
//  i4Square
//
//  Created by Ivelin Ivanov on 7/26/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageSearchServiceConstants.h"
#import "PGImage.h"

@interface ImageSearchServiceWorker : NSObject

@property (strong, nonatomic) NSMutableData *receivedData;
@property (copy, nonatomic) void (^block)(NSMutableArray *);

-(void)connectToServerUsingURL:(NSString *) url;
-(void)getImages:(void (^)(NSMutableArray *))block amount:(int)amount;

@end
