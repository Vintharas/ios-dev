//
//  Background.h
//  io
//
//  Created by Jaime Gonzalez Garcia on 03/11/13.
//  Copyright (c) 2013 Jaime Gonzalez Garcia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Background : SKSpriteNode

@property CGPoint viewPointOffset;

- (void) setViewPointX:(CGFloat)x;
- (void) setViewPointY:(CGFloat)y;

@end
