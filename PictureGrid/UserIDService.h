//
//  UserIDService.h
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/6/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kUserIdURL @"http://api.flickr.com/services/rest/?&method=flickr.tags.getListUser&api_key=900b6ebe1bb8da3eaa4799a2f004f609&auth_token=%@&frob=%@&api_sig=%@&format=json&nojsoncallback=1"

#define kMD5IDString @"f4f8ffbdf70871f3api_key900b6ebe1bb8da3eaa4799a2f004f609auth_token%@formatjsonfrob%@methodflickr.tags.getListUsernojsoncallback1"

@interface UserIDService : NSObject

@property (strong, nonatomic) NSMutableData *receivedData;
@property (copy, nonatomic) void (^block)(NSString *);

-(void)connectToServerUsingURL:(NSString *) url;
-(void)getUserID:(void (^)(NSString *))block;

@end
