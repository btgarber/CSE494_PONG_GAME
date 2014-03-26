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
        self.scoreToWin = 5;
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


@end
