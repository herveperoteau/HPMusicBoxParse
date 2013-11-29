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

#pragma mark - Artists (twitter)

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

#pragma mark - Albums satisfactions

+(void) saveSatisfactionAlbumTitle:(NSString *)title
                              Year:(NSString *)year
                        ArtistName:(NSString *)artistName
                      Satisfaction:(NSNumber *)satisfaction
              PreviousSatisfaction:(NSNumber *)previousSatisfaction
                        completion:(void (^)(AlbumParseEntity *album, NSError *error)) completion {
    
    [HPMusicBoxParse initializeIfNeeded];

    [myQueueQueryOneByOne addOperationWithBlock:^{
        
        NSLog(@"%@.saveSatisfactionAlbumTitle: startOperation album (Title:%@, Year:%@, Artist:%@, Satisfaction:%@ Previous=%@)", self.class, title, year, artistName, satisfaction, previousSatisfaction);
    
        NSError *error = nil;
        AlbumParseEntity *result = nil;

        NSString *cleanName = [HPMusicHelper cleanArtistName:artistName];
        
//        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"title = '%@' AND artistCleanName = '%@'",
//                                  title, cleanName];
//        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"title = '%@'",
//                                  title];
//        
//        PFQuery *query = [PFQuery queryWithClassName:@"AlbumParseEntity" predicate:predicate];
        
        PFQuery *query = [PFQuery queryWithClassName:@"AlbumParseEntity"];
        
        [query whereKey:@"title" equalTo:title];
        [query whereKey:@"artistCleanName" equalTo:cleanName];
        
        NSArray *results = [query findObjects:&error];
        
        NSLog(@"Nb result = %d", results.count);
        
        if (results != nil && [results count] > 0) {
            
            if (results.count > 1) {
                
                NSLog(@"Bizarre, %d albums avec title='%@' AND artistCleanName = '%@' !!!",
                      results.count, title, cleanName);
            }
            
            result = results[0];
        }
        
        if ( error==nil ) {
            
            // Update/Creation de l'album dans Parse
            if (result == nil) {
            
                NSLog(@"%@.saveSatisfactionAlbumTitle: create parse entity ...", self.class);
            
                result = [AlbumParseEntity object];
                
                result.title = title;
                result.year = (year?year:@"");
                result.artist = artistName;
                result.artistCleanName = cleanName;
            }
            
            NSInteger countParticipation = result.countParticipation.integerValue;
            unsigned long long cumul = result.satisfactionCumul.unsignedLongLongValue;
            
            if (previousSatisfaction == nil || previousSatisfaction.integerValue == 0) {
                
                countParticipation++;
            }

            cumul = cumul - previousSatisfaction.integerValue + satisfaction.integerValue;
            
            result.countParticipation = [NSNumber numberWithInteger:countParticipation];
            result.satisfactionCumul = [NSNumber numberWithUnsignedLongLong:cumul];
            result.satisfaction = [NSNumber numberWithInteger:(cumul/countParticipation)];
            
            NSLog(@"%@.saveSatisfactionAlbumTitle count=%@ cumul=%@ satisfaction=%@", self.class,
                  result.countParticipation, result.satisfactionCumul, result.satisfaction);
            
            [result save:&error];
        }
    
        if (completion) {
            
            NSLog(@"%@.saveSatisfactionAlbumTitle completion(%@, %@)", self.class, result, error);
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
    [AlbumParseEntity registerSubclass];
    
    [Parse setApplicationId:appId clientKey:clientKey];
}



@end
