//
//  PongViewController.m
//  Pong
//
//  Created by Ahbiya Harris on 3/10/14.
//  Copyright (c) 2014 Ahbiya Harris and Brent Garber. All rights reserved.
//

#import "PongViewController.h"
#define gameStateRunning 1
#define gameStatePaused 2
#define ballSpeedX 2
#define ballSpeedY 2
#define aiMoveSpeed 3.25
#define scoreToWin 9

@interface PongViewController ()

@end

@implementation PongViewController
@synthesize userPaddle, aiPaddle, ball;

@synthesize userScoreText;

@synthesize aiScoreText;
@synthesize winOrLoseLabel,ballVelocity,gameState;


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    //start the game
    self.gameState = gameStateRunning;
    if (location.x > self.view.bounds.size.height)
    {
        CGPoint yLocation = CGPointMake(userPaddle.center.x, location.y);
        userPaddle.center = yLocation;
    }
}

-(void) gameLoop
{
    if(gameState == gameStateRunning)
    {
        //Hide all the labels
        userScoreText.hidden = YES;
        aiScoreText.hidden = YES;
        winOrLoseLabel.hidden = YES;
        
        
        // Move the ball
        ball.center = CGPointMake(ball.center.x+ballVelocity.x, ball.center.y + ballVelocity.y);
        
        
        //Collision detection
        if (ball.center.x > self.view.bounds.size.width || ball.center.x < 0)
        {
            ballVelocity.x -= ballVelocity.x * 2;
            
        }
        
        if (ball.center.y > self.view.bounds.size.height || ball.center.y < 0)
        {
            ballVelocity.y -= ballVelocity.y * 2;

            
        }
        
        if(CGRectIntersectsRect(ball.frame, userPaddle.frame))
        {
            CGRect frame = ball.frame;
            frame.origin.x = userPaddle.frame.origin.x - frame.size.height;
            ball.frame = frame;
            ballVelocity.x -= ballVelocity.x * 2;
        }
        
        if(CGRectIntersectsRect(ball.frame, aiPaddle.frame))
        {
            CGRect frame = ball.frame;
            frame.origin.x = CGRectGetMaxX(aiPaddle.frame);
            ball.frame = frame;
            ballVelocity.x -= ballVelocity.x * 2;
        }
        
        /*
         *  AI is extremely stupid at the momenent.
         *  Make it smarter. Currently this code is executed in sequence.
         *  Need to find a way to have this running as the ball is moving 
         *  Instead
         */
        
        if(ball.center.x <= self.aiPaddle.center.x)
        {
            if(ball.center.y < aiPaddle.center.y)
            {
                CGPoint aiLocation = CGPointMake(aiPaddle.center.x, aiPaddle.center.y - aiMoveSpeed*4);
                aiPaddle.center = aiLocation;
            }
        }
        if(ball.center.x >= self.aiPaddle.center.x)
        {
            if(ball.center.y > aiPaddle.center.y)
            {
                CGPoint aiLocation = CGPointMake(aiPaddle.center.x, aiPaddle.center.y + aiMoveSpeed*4);
                aiPaddle.center = aiLocation;
            }
        }
        
        
        
        /*
         *  Score logic, updating the score and restarting the game
         *
         */
        if(ball.center.x <= 0)
        {
            userScoreValue++;
            [self reset:(userScoreValue >= scoreToWin)];
        }
        
        if(ball.center.x > self.view.bounds.size.width)
        {
            aiScoreValue++;
            [self reset:(aiScoreValue >= scoreToWin)];
        }
    }
}

-(void)reset:(BOOL)newGame
{
    self.gameState = gameStatePaused;
    
    ball.center = CGPointMake(241, 159);
    
    userScoreText.hidden = NO;
    aiScoreText.hidden = NO;
    
    userScoreText.text = [NSString stringWithFormat:@"%d", userScoreValue];
    aiScoreText.text = [NSString stringWithFormat:@"%d", aiScoreValue];
    
    if(newGame)
    {
        winOrLoseLabel.hidden = NO;
        
        if(aiScoreValue > userScoreValue)
        {
            winOrLoseLabel.text = @"Game Over!";
            
        }
        else
        {
            winOrLoseLabel.text = @"You Win!";
        }
        
        userScoreValue = 0;
        aiScoreValue = 0;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.gameState = gameStatePaused;
    ballVelocity = CGPointMake(ballSpeedX, ballSpeedY);
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(gameLoop) userInfo:Nil repeats:YES];
    
    winOrLoseLabel.hidden = YES;
    
    [winOrLoseLabel setFont:[UIFont fontWithName:@"kongtext" size:50]];
    
    [userScoreText setFont:[UIFont fontWithName:@"kongtext" size:50]];
    [aiScoreText setFont:[UIFont fontWithName:@"kongtext" size:50]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)dealloc
//{
//    [super dealloc];
//    
//    [ball release];
//    [userPaddle release];
//    [aiPaddle release];
//    [userScoreText release];
//    [aiScoreText release];
//    [winOrLoseLabel release];
//    
//    
//}

@end


