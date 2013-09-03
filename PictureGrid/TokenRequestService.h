//
//  TokenRequestService.h
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/6/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTokenURL @"http://flickr.com/services/rest/?method=flickr.auth.getToken&api_key=900b6ebe1bb8da3eaa4799a2f004f609&frob=%@&api_sig=%@"
#define kMD5TokenString @"f4f8ffbdf70871f3api_key900b6ebe1bb8da3eaa4799a2f004f609frob%@methodflickr.auth.getToken"

@interface TokenRequestService : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableData *receivedData;
@property (copy, nonatomic) void (^block)(NSString *);

-(void)connectToServerUsingURL:(NSString *) url;
-(void)getToken:(void (^)(NSString *))block;

@end
