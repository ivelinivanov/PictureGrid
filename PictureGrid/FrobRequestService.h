//
//  FrobRequestService.h
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/6/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kFrobQueryURL @"http://flickr.com/services/rest/?method=flickr.auth.getFrob&api_key=900b6ebe1bb8da3eaa4799a2f004f609&api_sig=6247380f2cd5f1e35ee1530c763120d5"

@interface FrobRequestService : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableData *receivedData;
@property (copy, nonatomic) void (^block)(NSString *);

-(void)connectToServerUsingURL:(NSString *) url;
-(void)getFrob:(void (^)(NSString *))block;

@end
