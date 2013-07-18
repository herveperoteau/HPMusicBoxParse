//
//  HPMusicBoxParse.h
//  HPMusicBoxParse
//
//  Created by Hervé PEROTEAU on 17/07/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "ArtistParseEntity.h"

@interface HPMusicBoxParse : NSObject

+(void) initializeApplicationId:(NSString *)appId
                      clientKey:(NSString *)clientKey;

+(void) getArtistByName:(NSString *)name
             completion:(void (^)(ArtistParseEntity *artist, NSError *error)) completion;

@end
