//
//  Game.h
//  Pong
//
//  Created by Brentton Garber on 3/23/14.
//  Copyright (c) 2014 Ahbiya Harris and Brent Garber. All rights reserved.
//
#define EASY 0
#define MEDIUM 1
#define HARD 2

#import <Foundation/Foundation.h>

@interface Game : NSObject

@property(nonatomic)int difficulty;
@property(nonatomic)int scoreToWin;

+(Game*)sharedGame;

@end
