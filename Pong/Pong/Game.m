//
//  Settings.m
//  Pong
//
//  Created by Brentton Garber on 3/23/14.
//  Copyright (c) 2014 Ahbiya Harris and Brent Garber. All rights reserved.
//

#import "Game.h"

@implementation Game

static Game* theGame = nil;

-(id)init
{
    if((self = [super init]) != nil)
    {
        self.difficulty = EASY;
        self.scoreToWin = 10;
        self.highScore = 0;
    }
    return self;
}

+(Game*)sharedGame {
    if(theGame == nil) {
        theGame = [[Game alloc] init];
    }
    return theGame;
}



-(NSString*) getDeviceIdentifier
{
    NSString *path = [@"~/Documents/ident.dat" stringByStandardizingPath];
    NSString *ident = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        ident = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return ident;
}

-(void) setDeviceIdentifier:(NSString*) ident
{
    NSString *path = [@"~/Documents/ident.dat" stringByStandardizingPath];
    NSData *data = [ident dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToFile:path atomically:YES];
}


@end
