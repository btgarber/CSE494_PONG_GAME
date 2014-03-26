//
//  PongViewController.m
//  Pong
//
//  Created by Ahbiya Harris on 3/10/14.
//  Copyright (c) 2014 Ahbiya Harris and Brent Garber. All rights reserved.
//

#import "PongViewController.h"

#define userScoreRegion 0
#define aiScoreRegion 567
#define topBorder 43
#define bottomBorder 278


@interface PongViewController ()

@end

@implementation PongViewController

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    [self moveUserPaddle:location];
}

-(void) gameLoop
{
    
    [self calculateAIPaddleSpeed];

    [self moveAIPaddle];
    
    //checks for collision
    [self testPaddleCollision:ball];
    
    //Moves the ball
    [self moveBall];
    
    [self testWallCollision:ball];
    
    if(ball.center.x < userScoreRegion)
        [self userScored];
    
    if(ball.center.x > aiScoreRegion)
        [self aiScored];

}

-(void)updateHighScore
{
    
    Game *game = [Game sharedGame];
    if (totalScore > [game.highScore intValue])
    {
        PFObject *highScore = [PFObject objectWithClassName:@"HiScore"];
        
        [highScore setObjectId: [game getDeviceIdentifier]];
        [highScore setObject:[NSNumber numberWithInt: totalScore] forKey:@"currentHiScore"];
        [highScore saveInBackground];
    }
}

-(void)userScored
{
    Game* game = [Game sharedGame];
    userScore++;
    userScoreText.text = [NSString stringWithFormat:@"%i", userScore];
    
    [timer invalidate];
    timer = nil;
    startButton.hidden = NO;
    ball.center = CGPointMake(278, 150);
    aiPaddle.center = CGPointMake(10, 140);
    [self reset:(userScore == game.scoreToWin)];
}

-(void)aiScored
{
    Game* game = [Game sharedGame];
    aiScore++;
    aiScoreText.text = [NSString stringWithFormat:@"%i", aiScore];
    
    [timer invalidate];
    timer = nil;
    startButton.hidden =NO;
    ball.center = CGPointMake(278, 150);
    aiPaddle.center = CGPointMake(10, 140);
    
    
    [self reset:(aiScore == game.scoreToWin)];
}

-(void)calculateAIPaddleSpeed
{
    if(ball.center.x < self.view.bounds.size.width*3/4)
        aiMoveSpeed = 1;
    if(ball.center.x < self.view.bounds.size.width/2)
        aiMoveSpeed *= 2;
    if(ball.center.x < self.view.bounds.size.width/4)
        aiMoveSpeed *= 4;
    if(aiWillLose && aiMoveSpeed > 1)
        aiMoveSpeed = 1;
}

-(void)moveBall
{
    ball.center = CGPointMake(ball.center.x+ballSpeedX, ball.center.y + ballSpeedY);
}

-(void)setBallSpeed
{
    Game* game = [Game sharedGame];
    
    ballSpeedX = arc4random() %game.difficulty;
    ballSpeedX = ballSpeedX-4;
    
    ballSpeedY = arc4random() %game.difficulty;
    ballSpeedX = ballSpeedX-4;
    
    if (ballSpeedX == 0) {
        ballSpeedX = 1;
    }
    if (ballSpeedY== 0) {
        ballSpeedY = 1;
    }
}

-(void)moveUserPaddle:(CGPoint)touchedLocation
{
    if (touchedLocation.x > self.view.bounds.size.height)
        userPaddle.center = CGPointMake(userPaddle.center.x, touchedLocation.y);
    
    if (touchedLocation.x < self.view.bounds.size.height)
        userPaddle.center = CGPointMake(userPaddle.center.x, touchedLocation.y);
    
    if(userPaddle.center.y <topBorder)
        userPaddle.center = CGPointMake(userPaddle.center.x, topBorder);
    
    if (userPaddle.center.y > bottomBorder)
        userPaddle.center = CGPointMake(userPaddle.center.x, bottomBorder);
    
}


-(void)moveAIPaddle
{
    if(aiPaddle.center.y > ball.center.y)
        aiPaddle.center = CGPointMake(aiPaddle.center.x, aiPaddle.center.y - aiMoveSpeed);
    
    if(aiPaddle.center.y < ball.center.y)
        aiPaddle.center = CGPointMake(aiPaddle.center.x, aiPaddle.center.y + aiMoveSpeed);
    
    if(aiPaddle.center.y < topBorder)
        aiPaddle.center = CGPointMake(aiPaddle.center.x, topBorder);
    
    if (aiPaddle.center.y > bottomBorder)
        aiPaddle.center = CGPointMake(aiPaddle.center.x, bottomBorder);
    
}

-(void)ProposeAiWillLoose
{
    Game *game = [Game sharedGame];
    int probability = 40 + (game.difficulty * 5);
    aiWillLose = (bool)((arc4random() % 100) > probability);
}

-(void)testWallCollision:(UIImageView*) object
{
    if (object.center.y > (topBorder-object.bounds.size.width))
        ballSpeedY = 0-ballSpeedY;
    if(object.center.y < (bottomBorder+object.bounds.size.width))
        ballSpeedY = 0 - ballSpeedY;
    
}

-(void)testPaddleCollision:(UIImageView*) object
{
    if(CGRectIntersectsRect(object.frame, userPaddle.frame))
    {
        ballSpeedX = arc4random() % 5;
        ballSpeedX = 0-ballSpeedX;
        userHitCount++;
    }
    
    if(CGRectIntersectsRect(object.frame, aiPaddle.frame))
    {
        ballSpeedX = arc4random() %5;
    }
}



-(void)reset:(BOOL)newGame
{
    
    if(newGame)
    {
        startButton.hidden = YES;
        exitButton.hidden = NO;
        winOrLoseLabel.hidden = NO;
        
        totalScore += userHitCount * 100;
        
        if(aiScore > userScore)
        {
            winOrLoseLabel.text = @"You Lose!";
            
        }
        else
        {
            winOrLoseLabel.text = @"You Win!";
        }
        [self updateHighScore];
        
        userScore = 0;
        aiScore = 0;
    }
}



-(IBAction)startButton:(id)sender
{
    startButton.hidden = YES;
    exitButton.hidden = YES;
    [self setBallSpeed];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(gameLoop) userInfo:Nil repeats:YES];
}




- (void)viewDidLoad
{
    userScore = 0;
    totalScore = 0;
    userHitCount = 0;
    aiScore = 0;
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end


