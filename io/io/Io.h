//
//  io.h
//  io - io the cute spaceship
//
//  Created by Jaime Gonzalez Garcia on 10/15/13.
//  Copyright (c) 2013 Jaime Gonzalez Garcia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Damage.h"

@interface Io : SKSpriteNode

- (void)moveTo:(CGPoint)point;
- (void)takeDamage:(Damage*)damage;

@end
