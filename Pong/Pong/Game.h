//
//  Game.h
//  Pong
//
//  Created by Brentton Garber on 3/23/14.
//  Copyright (c) 2014 Ahbiya Harris and Brent Garber. All rights reserved.
//
#define EASY 1
#define MEDIUM 2
#define HARD 3

#import <Foundation/Foundation.h>

@interface Game : NSObject

@property(nonatomic)int difficulty;
@property(nonatomic)int scoreToWin;
@property(nonatomic)NSNumber* highScore;


-(NSString*) getDeviceIdentifier;
-(void) setDeviceIdentifier:(NSString*) ident;
+(Game*)sharedGame;

@end
