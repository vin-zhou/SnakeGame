//
//  ViewController.m
//  SnakeGame
//
//  Created by Zhou, Wenshan on 12/25/14.
//  Copyright (c) 2014 MicroStrategy. All rights reserved.
//

#import "ViewController.h"
#import "SnakeMainView.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet SnakeMainView *snakeView;
@property (strong, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation ViewController
@synthesize snakeView = _snakeView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
  
    // interact
    self.view.userInteractionEnabled = YES;
    self.view.multipleTouchEnabled = YES;
    for (int i = 0; i < 4; i++)
    {
        UISwipeGestureRecognizer* gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        gesture. numberOfTouchesRequired = 1; // each handle one direction
        gesture.direction = 1 << i;
        [self.view addGestureRecognizer:gesture];
    }
    
}

- (void) handleSwipe:(UISwipeGestureRecognizer*) gesture
{
    NSUInteger direction = gesture.direction;
    switch (direction)
    {
        case UISwipeGestureRecognizerDirectionUp:
            if (self.snakeView.orient != DOWN)
            {
                self.snakeView.orient = UP;
            }
            break;
        case UISwipeGestureRecognizerDirectionDown:
            if (self.snakeView.orient != UP)
            {
                self.snakeView.orient = DOWN;
            }
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            if (self.snakeView.orient != RIGHT)
            {
                self.snakeView.orient = LEFT;
            }
            break;
        case UISwipeGestureRecognizerDirectionRight:
            if(self.snakeView.orient != LEFT)
            {
                self.snakeView.orient = RIGHT;
            }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onStart:(id)sender
{
    if (self.snakeView.gameStatus.mainStatus == INITIAL || self.snakeView.gameStatus.mainStatus == PAUSE)
    {
        self.snakeView.gameStatus.mainStatus = NORMAL;
        self.startButton.titleLabel.text = @"Pause";
    }
    else if(self.snakeView.gameStatus.mainStatus == NORMAL)
    {
        self.snakeView.gameStatus.mainStatus = PAUSE;
         self.startButton.titleLabel.text = @"Start";
    }
    
}

- (IBAction)onPause:(id)sender
{
    self.snakeView.gameStatus.mainStatus = PAUSE;
}

- (IBAction)onRestart:(id)sender
{
     self.snakeView.gameStatus.mainStatus = RESTART;
}
@end
