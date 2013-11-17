//
//  Damage.m
//  io
//
//  Created by Jaime Gonzalez Garcia on 17/11/13.
//  Copyright (c) 2013 Jaime Gonzalez Garcia. All rights reserved.
//

#import "Damage.h"

@implementation Damage

- (id) initFromMass:(CGFloat)mass;
{
    self = [super init];
    self.damage = mass;
    self.type = @"collision";
    return self;
}

@end
