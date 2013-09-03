//
//  CheckInWebServiceWorker.m
//  i4Square
//
//  Created by Ivelin Ivanov on 7/26/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "ImageSearchServiceWorker.h"

@implementation ImageSearchServiceWorker


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

-(void)getImages:(void (^)(NSMutableArray *))block amount:(int)amount
{
    self.block = block;
    NSString *url = [[NSString alloc] initWithFormat:kSearchQueryURL, amount];
   
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
                                                    message:@"Something went wrong with retreiving pictures. Please try again."
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
    
    NSArray *array = [resultDict valueForKeyPath:@"photos.photo"];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *currentImage in array)
    {
        PGImage *image = [[PGImage alloc] initWithFarm:currentImage[@"farm"] server:currentImage[@"server"] id:currentImage[@"id"] andSecret:currentImage[@"secret"]];
        [resultArray addObject:image];        
    }
    
    self.block(resultArray);
}


@end
