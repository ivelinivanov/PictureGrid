//
//  FavoritesWebService.h
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/8/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGImage.h"

#define kFavoritesURL @"http://api.flickr.com/services/rest/?&method=flickr.favorites.getPublicList&api_key=900b6ebe1bb8da3eaa4799a2f004f609&auth_token=%@&frob=%@&api_sig=%@&user_id=%@&format=json&nojsoncallback=1"

#define kMD5FavoritesString @"f4f8ffbdf70871f3api_key900b6ebe1bb8da3eaa4799a2f004f609auth_token%@formatjsonfrob%@methodflickr.favorites.getPublicListnojsoncallback1user_id%@"


@interface FavoritesWebService : NSObject

@property (strong, nonatomic) NSMutableData *receivedData;
@property (copy, nonatomic) void (^block)(NSMutableArray *);

-(void)connectToServerUsingURL:(NSString *) url;
-(void)getPhotos:(void (^)(NSMutableArray *))block;

@end

