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
        userPaddle.center = [self correctObjectLocation:userPaddle.bounds newLocation:yLocation];
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
        if (ball.center.x > self.screenBounds.size.width || ball.center.x < self.screenBounds.origin.x)
        {
            ballVelocity.x -= ballVelocity.x * 2;
            
        }
        
        if (ball.center.y > self.screenBounds.size.height || ball.center.y < self.screenBounds.origin.y)
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
            [self ProposeAiWillLoose];
        }
        
        /*
         *  AI is extremely stupid at the momenent.
         *  Make it smarter. Currently this code is executed in sequence.
         *  Need to find a way to have this running as the ball is moving 
         *  Instead
         */
        int aispeed = 0;
        float distance = abs(ball.center.y - aiPaddle.center.y);
        
        // Calculate the balls new speed
        if(ball.center.x < self.screenBounds.size.width*3/4) aispeed = 1;
        if(ball.center.x < self.screenBounds.size.width/2) aispeed *= 2;
        if(ball.center.x < self.screenBounds.size.width/4) aispeed *= 4;
        
        // If we want the ai to loose, set the speed to 1 for slower response to the ball
        if(self.aiWillLoose && aispeed > 1) aispeed = 1;
        
        // Prevent the ball from shaking from too fast of a movement
        if(distance < aispeed) aispeed = distance;
        
        // Determine the movement direction
        if(ball.center.y < aiPaddle.center.y) aispeed *= -1;
        
        // Create our new point
        CGPoint aiLocation = CGPointMake(aiPaddle.center.x, aiPaddle.center.y + aispeed);
        
        aiPaddle.center = [self correctObjectLocation:aiPaddle.bounds newLocation:aiLocation];
        
        
        
        /*
         *  Score logic, updating the score and restarting the game
         *
         */
        if(ball.center.x <= 0)
        {
            userScoreValue++;
            [self reset:(userScoreValue >= scoreToWin)];
            [self ProposeAiWillLoose];
        }
        
        if(ball.center.x > self.screenBounds.size.width)
        {
            aiScoreValue++;
            [self reset:(aiScoreValue >= scoreToWin)];
        }
    }
}

-(CGPoint) correctObjectLocation:(CGRect)obj newLocation:(CGPoint) location {
    float x = obj.size.width/2;
    float y = obj.size.height/2;
    
    if(location.x+x > self.screenBounds.size.width) location.x = self.screenBounds.size.width - x;
    if(location.y+y > self.screenBounds.size.height) location.y = self.screenBounds.size.height - y;
    
    if(location.x-x < self.screenBounds.origin.x) location.x = self.screenBounds.origin.x + x;
    if(location.y-y < self.screenBounds.origin.y) location.y = self.screenBounds.origin.y + y;
    
    return location;
}

-(void)reset:(BOOL)newGame
{
    self.gameState = gameStatePaused;
    
    ball.center = CGPointMake(241, 159);
    
    userScoreText.hidden = NO;
    aiScoreText.hidden = NO;
    
    userScoreText.text = [NSString stringWithFormat:@"%ld", (long)userScoreValue];
    aiScoreText.text = [NSString stringWithFormat:@"%ld", (long)aiScoreValue];
    
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

-(void)ProposeAiWillLoose {
    
    self.aiWillLoose = (bool)((arc4random() % 100) > 90);
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
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.screenBounds = CGRectMake(0, 26, self.view.bounds.size.height, self.view.bounds.size.width - 26);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


