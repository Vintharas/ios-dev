//
//  SpaceshipScene.m
//  JumpingIntoSpriteKit
//
//  Created by Jaime Gonzalez Garcia on 10/8/13.
//  Copyright (c) 2013 Jaime Gonzalez Garcia. All rights reserved.
//

#import "SpaceshipScene.h"
#import "Io.h"
#import "Background.h"
#import "Star.h"
#include <stdlib.h>


@interface SpaceshipScene ()

@property BOOL contentCreated;
@property CGPoint viewPoint;
@property CGPoint previousIoPosition;


@property (strong, nonatomic) Io* io;
@property (strong, nonatomic) Background* background;


@end

@implementation SpaceshipScene
- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    // Add background
    [self addBackground];
    
    // Add a space ship
    [self addIo];
    
    // Update view point to ios position
    // Since the coordinate system is in the bottom left by default
    // we can define the starting view point as Io's position
    self.viewPoint = self.io.realPosition;
    self.background.viewPointOffset = self.viewPoint;
    
    // Add some rocks
    SKAction *makeRocks = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(addRock) onTarget:self],
                                                [SKAction waitForDuration:0.10 withRange:0.15]
                                                ]];
    [self runAction: [SKAction repeatActionForever:makeRocks]];
    /*
     The scene is also a node, so it can run actions too. In this case, a custom action calls a method on the scene to create a rock. The sequence creates a rock, then waits for a random period of time. By repeating this action, the scene continuously spawns new rocks.
     */
}

- (void)addBackground;
{
    // this is just going to be used to tie all background elements together
    self.background = [[Background alloc] initWithColor:[UIColor blackColor] size:CGSizeMake(1000, 2000)];

    
    // add starts
    for (int i = 0; i < 50; i++) {
        CGPoint randomPosition =
            CGPointMake(skRand(self.background.size.width),
                        skRand(self.background.size.height));
        Star* star = [[Star alloc] initWithPosition:randomPosition];
        [self.background addChild:star];
    }
    
    [self addChild:self.background];
}

- (void) addIo;
{
    self.io = [[Io alloc] init];
    self.io.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-150);
    self.io.realPosition = self.io.position;
    [self addChild:self.io];
}

static inline CGFloat skRand(CGFloat maxBound)
{
    return arc4random_uniform(maxBound);
}

- (void)addRock
{
    CGSize rockSize = CGSizeMake(2,2);
    SKSpriteNode *rock = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:rockSize];
    rock.position = CGPointMake(skRand(self.size.width), self.size.height-50);
    rock.name = @"rock";
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    rock.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:rock];
}

-(void)didSimulatePhysics // This gets executed after running physics
{
    [self enumerateChildNodesWithName:@"rock" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0)
            [node removeFromParent];
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* 
     
     Called when a touch begins 
     
     Need to add support for other gestures like touch and hold
     */
    
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInNode:self];
        
        [self.io moveTo:touchLocation];
    }
}

-(void) update:(NSTimeInterval)currentTime
{
    
    self.viewPoint = self.io.realPosition;
    // self.previousIoPosition = CGPointMake(self.io.position.x, self.io.position.y);
    // self.viewPoint = CGPointMake(self.viewPoint.x + dx, self.viewPoint.y + dy);
    
    NSLog(@"x %.2f", self.viewPoint.x);
    NSLog(@"y %.2f", self.viewPoint.y);

    
    // update background position based on Io's movement
    if (self.viewPoint.x > self.frame.size.width/2 &&
        self.viewPoint.x < self.background.size.width - self.frame.size.width/2)
    {
        // update x on background
        [self.background setViewPointX:self.viewPoint.x];
    } else if (self.viewPoint.x <= self.frame.size.width/2) {
        self.io.position = CGPointMake(self.io.realPosition.x, self.io.position.y);
    } else {
        self.io.position = CGPointMake(self.io.realPosition.x - self.background.size.width + self.frame.size.height/2, self.io.position.y);
    }

    if (self.viewPoint.y > self.frame.size.height/2 &&
        self.viewPoint.y < self.background.size.height - self.frame.size.height/2)
    {
        // update x on background
        [self.background setViewPointY:self.viewPoint.y];
    } else if (self.viewPoint.y <= self.frame.size.height/2){
        self.io.position = CGPointMake(self.io.position.x, self.io.realPosition.y);
    } else {
        self.io.position = CGPointMake(self.io.position.x, self.io.realPosition.y - self.background.size.height + self.frame.size.height/2);
    }
    
}



@end
