//
//  PongViewController.h
//  Pong
//
//  Created by Ahbiya Harris on 3/10/14.
//  Copyright (c) 2014 Ahbiya Harris and Brent Garber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

int userScore;
int aiScore;
int ballSpeedX;
int ballSpeedY;
int aiMoveSpeed;
bool aiWillLose;

@interface PongViewController : UIViewController
{
    IBOutlet UIImageView *ball;
    IBOutlet UIButton *startButton;
    IBOutlet UIButton *exitButton;
    
    IBOutlet UIImageView *userPaddle;
    IBOutlet UIImageView *aiPaddle;
    
    IBOutlet UILabel *userScoreText;
    
    IBOutlet UILabel *aiScoreText;
    
    IBOutlet UILabel *winOrLoseLabel;
    
    NSTimer* timer;
}

-(IBAction)startButton:(id)sender;
-(void)gameLoop;
-(void)reset:(BOOL)newGame;



@end

