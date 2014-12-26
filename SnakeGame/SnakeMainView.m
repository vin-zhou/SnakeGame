//
//  SnakeMainView.m
//  SnakeGame
//
//  Created by Zhou, Wenshan on 12/25/14.
//  Copyright (c) 2014 MicroStrategy. All rights reserved.
//

#import "SnakeMainView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "FKPoint.h"

@interface SnakeMainView()
{
    NSMutableArray* snakeData; // the end data represent the snake head
    FKPoint* foodPos;
    NSTimer* timer;
    UIColor* bgColor;
    UIImage* cherryImage; // the image of food
    UIAlertView* overAlert;
    // system sound
    SystemSoundID gu;
    SystemSoundID crash;
    
}
@end

@implementation SnakeMainView

@synthesize orient;
@synthesize gameStatus = _gameStatus;


-(void) removeObservers
{
    [self.gameStatus removeObserver:self forKeyPath:@"mainStatus"];
}
- (void)setGameStatus:(GameStatus *)gameStatus
{
    if (self.gameStatus != gameStatus)
    {
        [self removeObservers];
        _gameStatus = gameStatus;
        [self.gameStatus addObserver:self forKeyPath:@"mainStatus" options:NSKeyValueObservingOptionOld context:nil];
    }
}

-(instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initResources];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initResources];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self initResources];
    }
    return self;
}



- (void) initResources
{
//    CGPoint startPoint = CGPointMake(0, 0);
//    self.bounds =  CGRectMake(startPoint.x, startPoint.y, WIDTH * BLOCK_SIZE, HEIGHT * BLOCK_SIZE);
//    self.center = CGPointMake(startPoint.x + WIDTH * BLOCK_SIZE * 0.5, startPoint.y + HEIGHT * BLOCK_SIZE * 0.5);
    cherryImage = [UIImage imageNamed:@"cherry.png"];
    bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grass.png"]];
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef guURLRef = CFBundleCopyResourceURL(mainBundle, CFSTR("gu"), CFSTR("mp3") , NULL);
    CFURLRef crashURLRef = CFBundleCopyResourceURL(mainBundle, CFSTR("crash"), CFSTR("wav") , NULL);
    //        NSURL* guURL = [[NSBundle mainBundle] URLForResource:@"gu" withExtension:@"mp3"];
    //        NSURL* crashURL = [[NSBundle mainBundle] URLForResource:@"crash" withExtension:@"mp3"];
    // load the sound
    AudioServicesCreateSystemSoundID(guURLRef, &gu);
    AudioServicesCreateSystemSoundID(crashURLRef, &crash);
    overAlert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"You lost the game." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    self.gameStatus = [[GameStatus alloc] init];
    
    self.layer.borderWidth = 3;
    self.layer.borderColor = [[UIColor redColor] CGColor];
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
}

-(void)dealloc
{
    [self clearGame];
}

- (void) clearGame
{
    snakeData = nil;
    if (timer != nil)
    {
        [timer invalidate];
    }
}
- (void) continueGame
{
   timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(move) userInfo:nil repeats:YES];
}

- (void) pauseGame
{
   [timer invalidate];
}

- (void) reStartGame
{
    [self clearGame];
    snakeData = [NSMutableArray arrayWithObjects:
                 [[FKPoint alloc] initWithX: 1 y:0],
                 [[FKPoint alloc] initWithX: 2 y:0],
                 [[FKPoint alloc] initWithX: 3 y:0],
                 [[FKPoint alloc] initWithX: 4 y:0],
                 [[FKPoint alloc] initWithX: 5 y:0],
                 nil];
    orient = RIGHT;
    [self continueGame];
}

// move handler
- (void) move
{
    FKPoint* first = [snakeData lastObject];
    FKPoint* head = [[FKPoint alloc]initWithX: first.x y:first.y];
    switch (orient)
    {
        case DOWN:
            head.y += 1;
            break;
        case LEFT:
            head.x -= 1;
            break;
        case RIGHT:
            head.x += 1;
            break;
        case UP:
            head.y -= 1;
            break;
        default:
            break;
    }
    // if game over
    if (head.x < 0 || head.x > WIDTH - 1 || head.y < 0 || head.y > HEIGHT - 1 || [snakeData containsObject:head])
    {
        AudioServicesPlaySystemSound(crash);
        [overAlert show];
        self.gameStatus.mainStatus = INITIAL;
        [self pauseGame];
        return;
    }
    // if meet with the food
    if ([head isEqual:foodPos])
    {
        AudioServicesPlaySystemSound(gu);
        [snakeData addObject:foodPos];
        foodPos = nil;
    }
    else // just move
    {
        [snakeData removeObjectAtIndex:0]; // remove the last one
        [snakeData addObject:head]; // add the new one
    }
    if (foodPos == nil)
    {
        while (true)
        {
            FKPoint* newFoodPos = [[FKPoint alloc]initWithX: arc4random() %WIDTH y:arc4random() % HEIGHT];
            if (![snakeData containsObject:newFoodPos])
            {
                foodPos = newFoodPos;
                break;
            }
        }
    }
    [self setNeedsDisplay];
}

// draw snake head
- (void) drawHeadInRect:(CGRect) rect context:(CGContextRef) ctx
{
    CGContextBeginPath(ctx);
    CGFloat startAngle;
    switch (orient)
    {
        case UP:
            startAngle = M_PI * 7 / 4;
            break;
        case DOWN:
            startAngle = M_PI * 3 / 4;
            break;
        case LEFT:
            startAngle = M_PI * 5 / 4;
            break;
        case RIGHT:
            startAngle = M_PI * 1 / 4;
            break;
        default:
            break;
    }
    CGContextAddArc(ctx, CGRectGetMidX(rect), CGRectGetMidY(rect), BLOCK_SIZE / 2, startAngle, M_PI * 1.5 + startAngle, 0);
    CGContextAddLineToPoint(ctx, CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
}

// draw snake
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [bgColor CGColor]);
    // draw background
    CGContextFillRect(ctx, CGRectMake(0, 0, WIDTH * BLOCK_SIZE, HEIGHT * BLOCK_SIZE));
    // draw title
    [@"Crazy snake" drawAtPoint:CGPointMake(50, 20) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                    [UIFont fontWithName:@"Heiti SC" size:40], NSFontAttributeName,
                                                                    [UIColor colorWithRed:1 green:0 blue:1 alpha:.4], NSForegroundColorAttributeName,
                                                                    nil]];
    // draw snake body
    CGContextSetRGBFillColor(ctx, 1, 1, 0, 1);
    for (int i = 0; i < snakeData.count; i++)
    {
        FKPoint* cp = [snakeData objectAtIndex:i];
        CGRect rect = CGRectMake(cp.x * BLOCK_SIZE, cp.y * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE);
        if (i < 4) // for tie
        {
            CGFloat inset = 4 - i;
            CGContextFillEllipseInRect(ctx, CGRectInset(rect, inset, inset));
        }
        else if (i == snakeData.count - 1)
        {
            [self drawHeadInRect:rect context:ctx];
        }
        else
        {
            CGContextFillEllipseInRect(ctx, rect);
        }
    }
    // draw food
    [cherryImage drawAtPoint:CGPointMake(foodPos.x * BLOCK_SIZE, foodPos.y * BLOCK_SIZE)];
}

// status machine
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([object isKindOfClass:[GameStatus class]])
    {
        MainStatus newStatus = ((GameStatus*)object).mainStatus;
        if ([keyPath isEqualToString:@"mainStatus"])
        {
            MainStatus oldStatus = [change[@"old"] intValue];
            
            if (oldStatus == INITIAL && newStatus == NORMAL) // begin game
            {
                [self reStartGame];
            }
            else if(newStatus == RESTART) // reStart game
            {
                [self reStartGame];
                self.gameStatus.mainStatus = NORMAL;
            }
            else if(oldStatus == NORMAL && newStatus == PAUSE) // pause game
            {
                [self pauseGame];
            }
            else if(oldStatus == PAUSE && newStatus == NORMAL) // continue game
            {
                [self continueGame];
            }
            
        }
    }
    
}


@end
