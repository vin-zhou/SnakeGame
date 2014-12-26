//
//  FKPoint.h
//  SnakeGame
//
//  Created by Zhou, Wenshan on 12/25/14.
//  Copyright (c) 2014 MicroStrategy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKPoint : NSObject


@property(nonatomic) int x;
@property(nonatomic) int y;

- (id) initWithX:(int)x y:(int)y;
@end
