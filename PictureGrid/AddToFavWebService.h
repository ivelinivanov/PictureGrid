//
//  AddToFavWebService.h
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/14/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kAddFavURL @"http://api.flickr.com/services/rest/?&method=flickr.favorites.add&api_key=900b6ebe1bb8da3eaa4799a2f004f609&auth_token=%@&frob=%@&api_sig=%@&photo_id=%@&format=json&nojsoncallback=1"

#define kMD5AddFavString @"f4f8ffbdf70871f3api_key900b6ebe1bb8da3eaa4799a2f004f609auth_token%@formatjsonfrob%@methodflickr.favorites.addnojsoncallback1photo_id%@"

@interface AddToFavWebService : NSObject

@property (strong, nonatomic) NSMutableData *receivedData;
@property (copy, nonatomic) void (^block)(NSString *);

-(void)connectToServerUsingURL:(NSString *) url;
-(void)addToFav:(void (^)(NSString *))block withPhotoID:(NSString *)photoID;

@end
