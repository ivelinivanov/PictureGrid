//
//  TokenRequestService.m
//  PictureGrid
//
//  Created by Ivelin Ivanov on 8/6/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "TokenRequestService.h"
#import "NSString+MD5.h"

@implementation TokenRequestService

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

-(void)getToken:(void (^)(NSString *))block
{
    NSString *frob = [[NSUserDefaults standardUserDefaults] objectForKey:@"frob"];
    
    NSString *stringToMD5 = [[NSString alloc] initWithFormat:kMD5TokenString, frob];
    
    NSString *url = [[NSString alloc] initWithFormat:kTokenURL,frob,[stringToMD5 MD5String]];
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
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.receivedData];
    parser.delegate = self;
    [parser parse];
}

#pragma mark - NSXMLParser Delegate Methods

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([string length] > 10)
    {
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"token"];
        self.block(string);
    }
}

@end
