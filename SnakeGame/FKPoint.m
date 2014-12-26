//
//  FKPoint.m
//  SnakeGame
//
//  Created by Zhou, Wenshan on 12/25/14.
//  Copyright (c) 2014 MicroStrategy. All rights reserved.
//

#import "FKPoint.h"

@implementation FKPoint

- (id) initWithX:(int)x y:(int)y
{
    if (self = [super init])
    {
        self.x = x;
        self.y = y;
    }
    return self;
}
-(BOOL) isEqual:(id)object
{
    BOOL equalFlag = NO;
    if (object != nil && [object isMemberOfClass:FKPoint.class])
    {
        FKPoint* tmpObject = (FKPoint* ) object;
        if (self.x == tmpObject.x && self.y == tmpObject.y)
        {
            equalFlag = YES;
        }
    }
    
    return equalFlag;
}

@end
