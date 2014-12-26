//
//  SnakeMainView.h
//  SnakeGame
//
//  Created by Zhou, Wenshan on 12/25/14.
//  Copyright (c) 2014 MicroStrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GameStatus.h"

// number of blocks
#define WIDTH 15
#define HEIGHT 22
// block size
#define BLOCK_SIZE 20

typedef enum
{
    DOWN = 0,
    LEFT,
    RIGHT,
    UP
    
}Orient;


@interface SnakeMainView : UIView

@property(nonatomic, assign) Orient orient;
@property(nonatomic, retain) GameStatus* gameStatus;

- (void) initResources;
- (void) continueGame;
- (void) pauseGame;
- (void) reStartGame;
@end
