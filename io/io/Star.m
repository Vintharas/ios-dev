//
//  Star.m
//  io
//
//  Created by Jaime Gonzalez Garcia on 10/31/13.
//  Copyright (c) 2013 Jaime Gonzalez Garcia. All rights reserved.
//

#import "Star.h"
#import "MathHelpers.h"

@interface Star()

  @property (strong, nonatomic) NSNumber* distance;

@end

@implementation Star

- (id) initWithPosition:(CGPoint)position;
{
    CGSize starSize = CGSizeMake(5, 5);
    float randomDuration = arc4random_uniform(15);
    float randomAlpha = [MathHelpers randomFloatBetween:0.4 and:1.0];
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

@end
