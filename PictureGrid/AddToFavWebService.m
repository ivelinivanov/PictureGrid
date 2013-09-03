//
//  AddToFavWebService.m
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/14/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "AddToFavWebService.h"
#import "NSString+MD5.h"

@implementation AddToFavWebService

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

-(void)addToFav:(void (^)(NSString *))block withPhotoID:(NSString *)photoID
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *frob = [[NSUserDefaults standardUserDefaults] objectForKey:@"frob"];
    
    NSString *signature = [[NSString alloc] initWithFormat:kMD5AddFavString, token, frob, photoID];
    
    NSString *url = [[NSString alloc] initWithFormat:kAddFavURL, token, frob, [signature MD5String], photoID];
    
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
    NSLog(@"%@",resultDict);
    
    if([resultDict[@"stat"] isEqualToString:@"ok"])
    {
        self.block(@"ok");
    }
    else
    {
        if ([resultDict[@"code"] intValue] == 2)
        {
            self.block(@"owned");
        }
        else if ([resultDict[@"code"] intValue] == 3)
        {
            self.block(@"inFavorites");
        }
        else
        {
            self.block(@"error");
        }
    }
}

@end
