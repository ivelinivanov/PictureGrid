//
//  UserInfoService.m
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/7/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "UserInfoService.h"
#import "NSString+MD5.h"

@implementation UserInfoService

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

-(void)getUserInfo:(void (^)(NSDictionary *))block
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *frob = [[NSUserDefaults standardUserDefaults] objectForKey:@"frob"];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    
    NSString *signature = [[NSString alloc] initWithFormat:kMD5InfoString, token, frob, userID];
    
    NSString *url = [[NSString alloc] initWithFormat:kUserInfoURL, token, frob, [signature MD5String], userID];

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
                                                    message:@"Something went wrong with retreiving user info. Please try again."
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
    NSString *fullName = [resultDict valueForKeyPath:@"person.realname._content"];
    
    NSString *imageURL = [[NSString alloc] initWithFormat:@"http://farm%@.staticflickr.com/%@/buddyicons/%@.jpg",[resultDict valueForKeyPath:@"person.iconfarm"], [resultDict valueForKeyPath:@"person.iconserver"], [resultDict valueForKeyPath:@"person.nsid"]];
    

    NSDictionary *responseDict = @{@"name" : fullName,
                                   @"image" : imageURL };
    
    self.block(responseDict);
}


@end
