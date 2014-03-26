//
//  MainMenuViewController.m
//  Pong
//
//  Created by Brentton Garber on 3/23/14.
//  Copyright (c) 2014 Ahbiya Harris and Brent Garber. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    PFQuery *query = [PFQuery queryWithClassName:@"HiScore"]; // 1
    [query getObjectInBackgroundWithId:@"Up2R1jeuwa" block:^(PFObject  *score, NSError *error) { //2
        // Do something with the returned PFObject in the gameScore variable.
        Game *game = [Game sharedGame];
        game.highScore = [score objectForKey:@"currentHiScore"];
        NSLog(@"%@", game.highScore);
        
        self.hiScoreLabel.text = [NSString stringWithFormat:@"%@", game.highScore];
        
        //Sets the label "balanceLabel" the the users current balance.
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)difficultyChanged:(id)sender {
    UISegmentedControl *ctrl = (UISegmentedControl*) sender;
    [[Game sharedGame] setDifficulty: (int)ctrl.selectedSegmentIndex];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
