//
//  PGImage.h
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/2/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGImage : NSObject
{
    NSString *_farm;
    NSString *_server;
    NSString *_secret;
}

@property (assign, nonatomic) float xOrigin;
@property (assign, nonatomic) float yOrigin;
@property (copy, nonatomic) NSString *photoID;

-(id)initWithFarm:(NSString *)farm server:(NSString *)server id:(NSString *)imageID andSecret:(NSString *)secret;
-(UIImage *)getImage:(NSString *)size;

@end
