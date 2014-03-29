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
    if(paused == true) return;
    
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
    exitButton.hidden = NO;
    pauseButton.hidden = YES;
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
    startButton.hidden = NO;
    exitButton.hidden = NO;
    pauseButton.hidden = YES;
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
    
    ballSpeedX = (arc4random() %game.difficulty+1) +2;
    ballSpeedX = ballSpeedX-3;
    
    ballSpeedY = (arc4random() %game.difficulty+1) +2;
    ballSpeedX = ballSpeedX-3;
    
    if (ballSpeedX == 0) {
        ballSpeedX = 2;
    }
    if (ballSpeedY== 0) {
        ballSpeedY = 2;
    }
}

-(void)moveUserPaddle:(CGPoint)touchedLocation
{
    if (touchedLocation.x > self.view.bounds.size.height)
        userPaddle.center = CGPointMake(userPaddle.center.x, touchedLocation.y);
    
    if (touchedLocation.x < self.view.bounds.size.height)
        userPaddle.center = CGPointMake(userPaddle.center.x, touchedLocation.y);
    
    if(userPaddle.center.y < topBorder)
        userPaddle.center = CGPointMake(userPaddle.center.x, topBorder);
    
    if (userPaddle.center.y > bottomBorder)
        userPaddle.center = CGPointMake(userPaddle.center.x, bottomBorder);
    
}


-(void)moveAIPaddle
{
    int aispeed = aiMoveSpeed;
    float distance = abs(ball.center.y - aiPaddle.center.y);
    
    // Prevent the ball from shaking from too fast of a movement
    if(distance < aispeed) aispeed = distance;
    
    // Determine the movement direction
    if(ball.center.y < aiPaddle.center.y) aispeed *= -1;
    
    if(aiPaddle.center.y < topBorder)
        aiPaddle.center = CGPointMake(aiPaddle.center.x, topBorder);
    else if (aiPaddle.center.y > bottomBorder)
        aiPaddle.center = CGPointMake(aiPaddle.center.x, bottomBorder);
    else
        aiPaddle.center = CGPointMake(aiPaddle.center.x, aiPaddle.center.y + aispeed);
}

-(void)ProposeAiWillLoose
{
    Game *game = [Game sharedGame];
    int probability = 30 + (game.difficulty * 5);
    aiWillLose = (bool)((arc4random() % 100) > probability);
}

-(void)testWallCollision:(UIImageView*) object
{
    if (object.center.y > (topBorder-object.bounds.size.width))
        ballSpeedY = 0-ballSpeedY;
    if(object.center.y < (bottomBorder+object.bounds.size.width))
        ballSpeedY = 0-ballSpeedY;
    
}

-(void)testPaddleCollision:(UIImageView*) object
{
    if(CGRectIntersectsRect(object.frame, userPaddle.frame))
    {
        ballSpeedX = (arc4random() % 5)+2;
        ballSpeedX = 0-ballSpeedX;
        userHitCount++;
        [self ProposeAiWillLoose];
    }
    
    if(CGRectIntersectsRect(object.frame, aiPaddle.frame))
    {
        ballSpeedX = (arc4random() %5)+2;
    }
}



-(void)reset:(BOOL)newGame
{
    
    if(newGame)
    {
        startButton.hidden = YES;
        exitButton.hidden = NO;
        winOrLoseLabel.hidden = NO;
        pauseButton.hidden = YES;
        
        if (userHitCount>0)
            totalScore += userHitCount * 100;
        else
            totalScore +=userScore*100;
        
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
    pauseButton.hidden = NO;
    [self setBallSpeed];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(gameLoop) userInfo:Nil repeats:YES];
}

- (void)viewDidLoad
{
    userScore = 0;
    totalScore = 0;
    userHitCount = 0;
    aiScore = 0;
    paused = false;
    pauseButton.hidden = YES;
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    
}

- (IBAction)pauseButtonClicked:(id)sender {
    paused = !paused;
    if(paused)
    {
        [pauseButton setTitle: @"UnPause" forState: UIControlStateNormal];
        winOrLoseLabel.text = @"PAUSED";
        exitButton.hidden = NO;
        winOrLoseLabel.hidden = NO;
    }
    else {
        [pauseButton setTitle: @"Pause" forState: UIControlStateNormal];
        exitButton.hidden = YES;
        winOrLoseLabel.hidden = YES;
    }
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


