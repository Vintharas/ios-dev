//
//  Star.m
//  io
//
//  Created by Jaime Gonzalez Garcia on 10/31/13.
//  Copyright (c) 2013 Jaime Gonzalez Garcia. All rights reserved.
//

#import "Star.h"

@interface Star()

  @property (strong, nonatomic) NSNumber* distance;

@end

@implementation Star

- (id) initWithPosition:(CGPoint)position;
{
    CGSize starSize = CGSizeMake(5, 5);
    float randomDuration = arc4random_uniform(15);
    float randomAlpha = [self randomFloatWithMaxValueOf:1.0];
    SKColor *color = [SKColor colorWithRed:1 green:1 blue:1 alpha:randomAlpha];
    self = [super initWithColor:color size:starSize];

    SKAction *blink = [SKAction sequence:@[
                                           [SKAction fadeOutWithDuration:randomDuration],
                                           [SKAction fadeInWithDuration:randomDuration]]];
    SKAction *blinkForever = [SKAction repeatActionForever:blink];
    self.position = position;
    [self runAction:blinkForever];
    return self;
}


- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

- (float)randomFloatWithMaxValueOf:(float)number {
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * number);
}

@end
