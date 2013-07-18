//
//  ArtistParseEntity.h
//  HPMusicBoxParse
//
//  Created by Hervé PEROTEAU on 17/07/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ArtistParseEntity : PFObject<PFSubclassing>

@property (retain) NSString *name;
@property (retain) NSString *twitterAccount;

+ (NSString *)parseClassName;

@end
