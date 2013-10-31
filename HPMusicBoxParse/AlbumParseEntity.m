//
//  AlbumParseEntity.m
//  HPMusicBoxParse
//
//  Created by Hervé PEROTEAU on 30/10/2013.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

#import "AlbumParseEntity.h"
#import <Parse/PFObject+Subclass.h>

@implementation AlbumParseEntity

@dynamic artist, artistCleanName, title, year, satisfaction, satisfactionCumul, countParticipation;

+ (NSString *)parseClassName {
    
    return @"AlbumParseEntity";
}


@end
