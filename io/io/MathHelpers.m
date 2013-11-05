//
//  MathHelpers.m
//  io
//
//  Created by Jaime Gonzalez Garcia on 05/11/13.
//  Copyright (c) 2013 Jaime Gonzalez Garcia. All rights reserved.
//

#import "MathHelpers.h"

@implementation MathHelpers


+ (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

+ (float)randomFloatWithMaxValueOf:(float)number {
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * number);
}

@end
