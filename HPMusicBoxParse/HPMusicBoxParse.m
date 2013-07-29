//
//  HPMusicBoxParse.m
//  HPMusicBoxParse
//
//  Created by Hervé PEROTEAU on 17/07/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

#import "HPMusicBoxParse.h"
#import <Parse/Parse.h>
#import "ArtistParseEntity.h"
#import "HPMusicHelper.h"

#define APPID      @"WrptsUZpYHx4gR0Nh1GCNdKrEeYFxAHMv7re1raR"
#define CLIENTKEY  @"vWPYADVo1oBErKFC4uP2r4Oflk0QPFfyWLb854Lq"

static NSOperationQueue *myQueueQueryOneByOne;

@implementation HPMusicBoxParse

+(void) getArtistByName:(NSString *)name
             completion:(void (^)(ArtistParseEntity *artist, NSError *error)) completion {
    
    [HPMusicBoxParse initializeIfNeeded];
    
    [myQueueQueryOneByOne addOperationWithBlock:^{
        
        NSLog(@"%@.getArtistByName: startOperation getArtistByName %@", self.class, name);
        
        NSString *cleanName = [HPMusicHelper cleanArtistName:name];
        
        PFQuery *query = [ArtistParseEntity query];
        
        [query whereKey:@"cleanName" equalTo:cleanName];
        
        NSError *error = nil;
        
        NSArray *results = [query findObjects:&error];
        
        ArtistParseEntity *result = nil;
            
        if (results != nil && [results count] > 0) {
                
            result = results[0];
        }
            
        if ( result==nil && error==nil ) {
                
            // creation de l'artist dans Parse
            
            NSLog(@"%@.getArtistByName start createParseEntity %@", self.class, cleanName);
            
            result = [ArtistParseEntity object];
            result.cleanName = cleanName;
            result.twitterAccount = @"";
            
            NSLog(@"%@.getArtistByName save ParseEntity %@", self.class, cleanName);
            [result save:&error];
            NSLog(@"%@.getArtistByName save ended error=%@", self.class, error);

        }
        
        if (completion) {
            
            NSLog(@"%@.getArtistByName completion(%@, %@)", self.class, result, error);
            completion(result, error);
        }
    }];

}

#pragma mark - Initialisation

+(void) initializeIfNeeded {
    
    if (myQueueQueryOneByOne == nil) {
        
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            
            myQueueQueryOneByOne = [[NSOperationQueue alloc] init];
            myQueueQueryOneByOne.name = @"MusicBoxParseQueueQueryOneByOne";
            myQueueQueryOneByOne.maxConcurrentOperationCount = 1;
            
            [HPMusicBoxParse initializeApplicationId:APPID clientKey:CLIENTKEY];
        });
    }
}

+(void) initializeApplicationId:(NSString *)appId clientKey:(NSString *)clientKey {
    
    [ArtistParseEntity registerSubclass];
    [Parse setApplicationId:appId clientKey:clientKey];
}



@end
