//
//  SpaceshipScene.h
//  JumpingIntoSpriteKit
//
//  Created by Jaime Gonzalez Garcia on 10/8/13.
//  Copyright (c) 2013 Jaime Gonzalez Garcia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static const uint32_t rockCategory     =  0x1 << 0;
static const uint32_t shipCategory        =  0x1 << 1;

@interface SpaceshipScene : SKScene <SKPhysicsContactDelegate>

@end
