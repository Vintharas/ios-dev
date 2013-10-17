//
//  io.m
//  io
//
//  Created by Jaime Gonzalez Garcia on 10/15/13.
//  Copyright (c) 2013 Jaime Gonzalez Garcia. All rights reserved.
//

#import "Io.h"

@implementation Io

- (id) init;
{
    self = [super initWithColor:[SKColor grayColor]
                           size:CGSizeMake(50,50)];
    
    [self completeIo];
    return self;
}


- (void)completeIo
{
    
//    SKAction *hover = [SKAction sequence:@[
//                                           [SKAction waitForDuration:1.0],
//                                           [SKAction moveByX:100 y:50.0 duration:1.0],
//                                           [SKAction waitForDuration:1.0],
//                                           [SKAction moveByX:-100.0 y:-50 duration:1.0]]];
//    [self runAction: [SKAction repeatActionForever:hover]];
    
    /*
     This method creates the spaceship’s hull and adds to it a short animation. Note that a new kind of action was introduced. A repeating action continuously repeats the action passed to it. In this case, the sequence repeats indefinitely.
     */
    
    SKSpriteNode *light1 = [self newLight];
    light1.position = CGPointMake(-20.0, 6.0);
    [self addChild:light1];
    
    SKSpriteNode *light2 = [self newLight];
    light2.position = CGPointMake(20.0, 6.0);
    [self addChild:light2];
    
    /*
     When building complex nodes that have children, it is a good idea to isolate the code used to create the node behind a construction method or even a subclass. This makes it easier to change the sprite’s composition and behavior without requiring changes to clients that use the sprite.
     */
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.dynamic = NO;
    
    /*
     When you run it now, the spaceship is no longer affected by gravity, so it runs as it did before. Later, making the physics body static also means that the spaceship’s velocity is unaffected by collisions.
     
     Rocks should now fall from the top of the scene. When a rock hits the ship, the rock bounces off the ship. No actions were added to move the rocks. Rocks fall and collide with the ship entirely due to the physics subsystem.
     
     The rocks are small and move quickly, so the code specifies precise collisions to ensure that all collisions are detected.
     
     If you let the app run for a while, the frame rate starts to drop, even though the node count remains very low. This is because the node code only shows the visible nodes in the scene. However, when rocks fall through the bottom of the scene, they continue to exist in the scene, which means that physics is still being simulated on them. Eventually there are so many nodes being processed that Sprite Kit slows down.
     */
    SKEmitterNode* propulsion = [self newPropulsionEmitter];
    SKAction* flip = [SKAction rotateByAngle:M_PI duration:0];
    [propulsion runAction:flip];
    propulsion.position = CGPointMake(0.0, -25.0);
    [self addChild:propulsion];
}

- (SKSpriteNode *)newLight
{
    SKSpriteNode *light = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor]
                                                         size:CGSizeMake(8,8)];
    
    SKAction *blink = [SKAction sequence:@[
                                           [SKAction fadeOutWithDuration:0.5],
                                           [SKAction fadeInWithDuration:0.5]]];
    // it would be could for him to blink some times
    // io a girl or a boy?
    SKAction *blinkForever = [SKAction repeatActionForever:blink];
    [light runAction:blinkForever];
    
    return light;
}

- (SKEmitterNode *)newPropulsionEmitter
{
    NSString *propulsionPath = [[NSBundle mainBundle] pathForResource:@"propulsion" ofType:@"sks"];
    SKEmitterNode *propulsion = [NSKeyedUnarchiver unarchiveObjectWithFile:propulsionPath];
    return propulsion;
}



@end