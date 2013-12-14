//
//  AlbumParseEntity.h
//  HPMusicBoxParse
//
//  Created by Hervé PEROTEAU on 30/10/2013.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AlbumParseEntity : PFObject<PFSubclassing>

@property (retain) NSString *artist;
@property (retain) NSString *artistCleanName;
@property (retain) NSString *title;
@property (retain) NSString *titleClean;
@property (retain) NSString *year;
@property (retain) NSNumber *satisfaction;
@property (retain) NSNumber *satisfactionCumul;
@property (retain) NSNumber *countParticipation;

+ (NSString *)parseClassName;

@end
