//
//  FavoritesWebService.m
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/8/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "FavoritesWebService.h"
#import "NSString+MD5.h"

@implementation FavoritesWebService

-(id)init
{
    if(self = [super init])
    {
        self.receivedData = [NSMutableData data];
        return self;
    }
    else
    {
        return nil;
    }
}

#pragma mark - Get Results Method

-(void)getPhotos:(void (^)(NSMutableArray *))block
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *frob = [[NSUserDefaults standardUserDefaults] objectForKey:@"frob"];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    
    NSString *signature = [[NSString alloc] initWithFormat:kMD5FavoritesString, token, frob, userID];
    
    NSString *url = [[NSString alloc] initWithFormat:kFavoritesURL, token, frob, [signature MD5String], userID];
    
    self.block = block;
    
    [self connectToServerUsingURL:url];
}

#pragma mark - Connection Methods

-(void)connectToServerUsingURL:(NSString *)url
{
    NSURL* urlPath = [NSURL URLWithString:url];
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:urlPath];
    [NSURLConnection connectionWithRequest:req delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.receivedData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                    message:@"Something went wrong with retreiving frob. Please try again."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    
    NSDictionary* resultDict = [NSJSONSerialization JSONObjectWithData:self.receivedData
                                                               options:kNilOptions
                                                                 error:&error];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:[[resultDict valueForKeyPath:@"photos.total"] intValue]];
    NSArray *images = [resultDict valueForKeyPath:@"photos.photo"];
    for (NSDictionary *image in images)
    {
        PGImage *img = [[PGImage alloc] initWithFarm:image[@"farm"] server:image[@"server"] id:image[@"id"] andSecret:image[@"secret"]];
        [resultArray addObject:img];
    }
    
    self.block(resultArray);
}


@end
