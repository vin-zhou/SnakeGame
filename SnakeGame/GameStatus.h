//
//  GameStatus.h
//  SnakeGame
//
//  Created by Zhou, Wenshan on 12/26/14.
//  Copyright (c) 2014 MicroStrategy. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
    INITIAL = 0,
    NORMAL,
    PAUSE,
    RESTART
}MainStatus;

@interface GameStatus : NSObject

@property (nonatomic) MainStatus mainStatus;

@end
