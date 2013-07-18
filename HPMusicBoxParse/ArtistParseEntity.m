//
//  ArtistParseEntity.m
//  HPMusicBoxParse
//
//  Created by Hervé PEROTEAU on 17/07/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

#import "ArtistParseEntity.h"
#import <Parse/PFObject+Subclass.h>

@implementation ArtistParseEntity

@dynamic name, twitterAccount;

+ (NSString *)parseClassName {

    return @"ArtistParseEntity";
}



@end
