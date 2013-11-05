//
//  io.h
//  io - io the cute spaceship
//
//  Created by Jaime Gonzalez Garcia on 10/15/13.
//  Copyright (c) 2013 Jaime Gonzalez Garcia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Io : SKSpriteNode

@property CGPoint realPosition;

- (void)moveTo:(CGPoint)point;

@end
