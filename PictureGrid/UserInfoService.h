//
//  UserInfoService.h
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/7/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kUserInfoURL @"http://api.flickr.com/services/rest/?&method=flickr.people.getInfo&api_key=900b6ebe1bb8da3eaa4799a2f004f609&auth_token=%@&frob=%@&api_sig=%@&user_id=%@&format=json&nojsoncallback=1"

#define kMD5InfoString @"f4f8ffbdf70871f3api_key900b6ebe1bb8da3eaa4799a2f004f609auth_token%@formatjsonfrob%@methodflickr.people.getInfonojsoncallback1user_id%@"

@interface UserInfoService : NSObject

@property (strong, nonatomic) NSMutableData *receivedData;
@property (copy, nonatomic) void (^block)(NSDictionary *);

-(void)connectToServerUsingURL:(NSString *) url;
-(void)getUserInfo:(void (^)(NSDictionary *))block;

@end
