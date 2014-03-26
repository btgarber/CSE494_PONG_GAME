//
//  MainMenuViewController.h
//  Pong
//
//  Created by Brentton Garber on 3/23/14.
//  Copyright (c) 2014 Ahbiya Harris and Brent Garber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PongViewController.h"
#import "Game.h"

@interface MainMenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *hiScoreLabel;

@end
