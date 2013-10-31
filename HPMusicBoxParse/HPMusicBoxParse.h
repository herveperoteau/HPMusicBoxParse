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
#import "AlbumParseEntity.h"

@interface HPMusicBoxParse : NSObject

+(void) getArtistByName:(NSString *)name
             completion:(void (^)(ArtistParseEntity *artist, NSError *error)) completion;

+(void) saveSatisfactionAlbumTitle:(NSString *)title
                              Year:(NSString *)year
                        ArtistName:(NSString *)artistName
                      Satisfaction:(NSNumber *)satisfaction
              PreviousSatisfaction:(NSNumber *)previousSatisfaction
                        completion:(void (^)(AlbumParseEntity *album, NSError *error)) completion;


@end
