//
//  GameStatus.m
//  SnakeGame
//
//  Created by Zhou, Wenshan on 12/26/14.
//  Copyright (c) 2014 MicroStrategy. All rights reserved.
//

#import "GameStatus.h"

@implementation GameStatus
@synthesize mainStatus = _mainStatus;

-(id) init
{
    if (self = [super init])
    {
        _mainStatus = INITIAL;
    }
    return self;
}

@end
