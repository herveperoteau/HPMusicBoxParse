//
//  HPMusicBoxParseTests.m
//  HPMusicBoxParseTests
//
//  Created by Hervé PEROTEAU on 17/07/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HPMusicBoxParse.h"

#define APPID      @"WrptsUZpYHx4gR0Nh1GCNdKrEeYFxAHMv7re1raR"
#define CLIENTKEY  @"vWPYADVo1oBErKFC4uP2r4Oflk0QPFfyWLb854Lq"

@interface HPMusicBoxParseTests : XCTestCase

@end

@implementation HPMusicBoxParseTests {
    
    dispatch_semaphore_t semaphore;
}

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    semaphore = dispatch_semaphore_create(0);

    [HPMusicBoxParse initializeApplicationId:APPID clientKey:CLIENTKEY];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

-(void) testGetRihanna {

    NSString *name = @"Rihanna";
    
    [HPMusicBoxParse getArtistByName:name completion:^(ArtistParseEntity *artist, NSError *error) {

        XCTAssertNil(error, @"%@", [error localizedDescription]);
        XCTAssertNotNil(artist, @"%@ Not exist and not created ???", name);
        
        NSLog(@"Artist=%@ Twitter=%@", artist.cleanName, artist.twitterAccount);
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

-(void) testGetTheStrokes {
    
    NSString *name = @"The Strokes";
    
    [HPMusicBoxParse getArtistByName:name completion:^(ArtistParseEntity *artist, NSError *error) {
        
        XCTAssertNil(error, @"%@", [error localizedDescription]);
        XCTAssertNotNil(artist, @"%@ Not exist and not created ???", name);
        
        NSLog(@"Artist=%@ Twitter=%@", artist.cleanName, artist.twitterAccount);
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}


@end
