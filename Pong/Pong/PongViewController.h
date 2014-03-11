//
//  PongViewController.h
//  Pong
//
//  Created by Ahbiya Harris on 3/10/14.
//  Copyright (c) 2014 Ahbiya Harris and Brent Garber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PongViewController : UIViewController
{
    IBOutlet UIImageView *ball;
    
    IBOutlet UIImageView *userPaddle;
    IBOutlet UIImageView *aiPaddle;
    
    IBOutlet UILabel *userScoreText;
    
    IBOutlet UILabel *aiScoreText;
    
    IBOutlet UILabel *winOrLoseLabel;
    
    CGPoint ballVelocity;
    
    NSInteger gameState;
    
    NSInteger userScoreValue;
    NSInteger aiScoreValue;
    
}

@property (nonatomic, retain) IBOutlet UIImageView *ball;

@property (nonatomic, retain)IBOutlet UIImageView *userPaddle;
@property (nonatomic, retain)IBOutlet UIImageView *aiPaddle;

@property (nonatomic, retain)IBOutlet UILabel *userScoreText;

@property (nonatomic, retain)IBOutlet UILabel *aiScoreText;

@property (nonatomic, retain)IBOutlet UILabel *winOrLoseLabel;

@property(nonatomic)CGPoint ballVelocity;

@property(nonatomic)NSInteger gameState;

-(void)reset:(BOOL)newGame;



@end

