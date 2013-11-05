//
//  io.m
//  io
//
//  Created by Jaime Gonzalez Garcia on 10/15/13.
//  Copyright (c) 2013 Jaime Gonzalez Garcia. All rights reserved.
//

#import "Io.h"

@interface Io()

@property (strong, nonatomic) NSNumber* speedX;
@property (strong, nonatomic) NSNumber* speedY;

@end


@implementation Io

- (id) init;
{
    self = [super initWithColor:[SKColor grayColor]
                           size:CGSizeMake(15,15)];
    self.speedX = @10;
    self.speedY = @10;
    
    [self completeIo];
    return self;
}


- (void)completeIo
{
    
    /*
     This method creates the spaceship’s hull and adds to it a short animation. Note that a new kind of action was introduced. A repeating action continuously repeats the action passed to it. In this case, the sequence repeats indefinitely.
     */
    
    SKSpriteNode *light1 = [self newLight];
    light1.position = CGPointMake(-6.0, 3.0);
    [self addChild:light1];
    
    SKSpriteNode *light2 = [self newLight];
    light2.position = CGPointMake(6.0, 3.0);
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
                                                         size:CGSizeMake(2,2)];
    
    SKAction *blink = [SKAction sequence:@[
                                           [SKAction fadeOutWithDuration:1.0],
                                           [SKAction fadeInWithDuration:1.0]]];
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

- (void)moveTo:(CGPoint)destination
{
    // calculate direction in which to move based on position
    // of Io and the target point
    CGFloat dx = (destination.x - self.position.x);
    CGFloat dy = (destination.y - self.position.y);
    
    CGFloat normdx = dx/sqrt((pow(dx,2) + pow(dy,2)));
    CGFloat normdy = dy/sqrt((pow(dx,2) + pow(dy,2)));
    
    CGVector direction = CGVectorMake(normdx*[self.speedX floatValue], normdy*[self.speedY floatValue]);
    
    self.realPosition = CGPointMake(self.realPosition.x + direction.dx, self.realPosition.y + direction.dy);
    
//    SKAction *action = [SKAction sequence:@[
//                            [SKAction moveBy:direction duration:1.0] // need to play with this duration in the future
//                        ]];
//    
//    
//    [self runAction:action];
}



@end
