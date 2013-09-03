//
//  FlickrLoginService.m
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/7/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "FlickrLoginService.h"

@implementation FlickrLoginService

+(void)getFrob:(void (^)(NSString *))block
{
    FrobRequestService *service = [[FrobRequestService alloc] init];
    [service getFrob:block];
}

+(void)getToken:(void (^)(NSString *))block
{
    TokenRequestService *service = [[TokenRequestService alloc] init];
    [service getToken:block];
}

+(void)getUserID:(void (^)(NSString *))block
{
    UserIDService *service = [[UserIDService alloc] init];
    [service getUserID:block];
}

+(void)getUserInfo:(void (^)(NSDictionary *))block
{
    UserInfoService *service = [[UserInfoService alloc] init];
    [service getUserInfo:block];
}

@end
