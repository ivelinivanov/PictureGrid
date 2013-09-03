//
//  PGImage.m
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/2/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "PGImage.h"

@implementation PGImage

-(id)initWithFarm:(NSString *)farm server:(NSString *)server id:(NSString *)imageID andSecret:(NSString *)secret
{
    self = [super init];
    if(self)
    {
        _farm = farm;
        _server = server;
        _photoID = imageID;
        _secret = secret;
    }
    
    return self;
}

-(UIImage *)getImage:(NSString *)size
{
    NSString *url = [[NSString alloc] initWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_%@.jpg", _farm,_server,self.photoID,_secret,size];
    NSURL *imageURL = [NSURL URLWithString: url];
    NSData *data = [[NSData alloc] initWithContentsOfURL: imageURL];
    UIImage *image = [UIImage imageWithData: data];
    
    return image;
}

@end
