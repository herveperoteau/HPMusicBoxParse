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

static BOOL initOK = NO;

@implementation HPMusicBoxParse

+(void) initializeApplicationId:(NSString *)appId clientKey:(NSString *)clientKey {

    initOK = YES;
    
    [ArtistParseEntity registerSubclass];
    [Parse setApplicationId:appId clientKey:clientKey];
}

+(void) getArtistByName:(NSString *)name
             completion:(void (^)(ArtistParseEntity *artist, NSError *error)) completion {
    
    NSAssert(initOK, @"Lib HPMusicBoxParse not initialized ???");
    
    NSString *cleanName = [HPMusicHelper cleanArtistName:name];
    
    PFQuery *query = [ArtistParseEntity query];
    
    [query whereKey:@"cleanName" equalTo:cleanName];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
    
        ArtistParseEntity *result = nil;

        if (results != nil && [results count] > 0) {
            
            result = results[0];
        }
                
        if ( result==nil && error==nil ) {
            
            // creation de l'artist dans Parse
            result = [ArtistParseEntity object];
            result.cleanName = cleanName;
            result.twitterAccount = @"";
            
            [result saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (completion) {
                    
                    completion (result, error);
                }
            }];
            
            return;
        }
        
        if (completion) {
            
            completion(result, error);
        }
    }];
}


@end
