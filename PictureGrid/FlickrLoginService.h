//
//  FlickrLoginService.h
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/7/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FrobRequestService.h"
#import "TokenRequestService.h"
#import "UserIDService.h"
#import "UserInfoService.h"

@interface FlickrLoginService : NSObject

+(void)getFrob:(void (^)(NSString *))block;
+(void)getToken:(void (^)(NSString *))block;
+(void)getUserID:(void (^)(NSString *))block;
+(void)getUserInfo:(void (^)(NSDictionary *))block;

@end
