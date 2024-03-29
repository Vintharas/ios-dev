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
@property (strong, nonatomic) SKEmitterNode* propulsion;




@end


@implementation Io

- (id) init;
{
    self = [super initWithColor:[SKColor grayColor]
                           size:CGSizeMake(15,15)];
    self.speedX = @50;
    self.speedY = @50;
    self.name = @"io";
    
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
    self.physicsBody.mass = 1;
    
    /*
     When you run it now, the spaceship is no longer affected by gravity, so it runs as it did before. Later, making the physics body static also means that the spaceship’s velocity is unaffected by collisions.
     
     Rocks should now fall from the top of the scene. When a rock hits the ship, the rock bounces off the ship. No actions were added to move the rocks. Rocks fall and collide with the ship entirely due to the physics subsystem.
     
     The rocks are small and move quickly, so the code specifies precise collisions to ensure that all collisions are detected.
     
     If you let the app run for a while, the frame rate starts to drop, even though the node count remains very low. This is because the node code only shows the visible nodes in the scene. However, when rocks fall through the bottom of the scene, they continue to exist in the scene, which means that physics is still being simulated on them. Eventually there are so many nodes being processed that Sprite Kit slows down.
     */
    self.propulsion = [self newPropulsionEmitter];
    SKAction* flip = [SKAction rotateByAngle:M_PI duration:0];
    [self.propulsion runAction:flip];
    self.propulsion.position = CGPointMake(0.0, -25.0);
    [self addChild:self.propulsion];
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
    
    SKAction *moveIo = [SKAction sequence:@[
                            [SKAction moveBy:direction duration:1.0] // need to play with this duration in the future
                        ]];
    [self runAction:moveIo];
    
    CGFloat angle = atan2f(normdy, normdx) + M_PI_2;
    SKAction *rotatePropulsion = [SKAction group:@[
                                                      [SKAction rotateToAngle:angle duration:0.5],
                                                      [SKAction moveToX:-25.0*normdx duration:0.5],
                                                      [SKAction moveToY:-25.0*normdy duration:0.5]
                                                      ]];
    
    [self.propulsion runAction:rotatePropulsion];
}

- (void)takeDamage:(Damage *)damage
{
    // take damage and animate
    // 1. reduce hp
    
    // 2. animation
    if ([damage.type isEqualToString:@"collision"]){
        SKAction *damageByCollision = [SKAction sequence:@[
                                       [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:0.1 duration:0.5],
                                       [SKAction colorizeWithColor:[SKColor grayColor] colorBlendFactor:0.1 duration:0.5]
                                       ]];
        SKAction *tremble = [SKAction sequence:@[
                                                 [SKAction moveByX:4 y:0 duration:0.1],
                                                 [SKAction moveByX:-8 y:0 duration:0.2],
                                                 [SKAction moveByX:4 y:0 duration:0.1]]];
        SKAction *repeatTremble = [SKAction repeatAction:tremble count:2];
        SKAction *repeatDamageByCollision = [SKAction repeatAction:damageByCollision count:4];
        [self runAction:[SKAction group:@[repeatTremble, repeatDamageByCollision]]];
    }
}

@end
