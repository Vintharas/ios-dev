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
#import "MathHelpers.h"
#import "Damage.h"


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
    
    // configure physics world
    self.physicsWorld.gravity = CGVectorMake(0, 0); // no gravity, we're in space!
    
    // setup collisions
    self.physicsWorld.contactDelegate = self;
    
    // Add background
    [self addBackground];
    
    // Add a space ship
    [self addIo];
    
    // Update current view point to Io position
    self.viewPoint = self.io.position;
    self.background.viewPointOffset = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    // Add some rocks
    [self addRocks];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    // this method comes from the Scene conforming to the <SKPhysicsMadeContactDelegate>
    if (([contact.bodyA.node.name  isEqual:@"rock"] && [contact.bodyB.node.name  isEqual: @"io"]) ||
        ([contact.bodyA.node.name  isEqual:@"io"] && [contact.bodyB.node.name  isEqual: @"rock"]) ) {
        // damageIo
        SKNode* rock;
        if ([contact.bodyA.node.name isEqualToString:@"rock"]){
            rock = contact.bodyA.node;
        } else{
            rock = contact.bodyB.node;
        }
        [self.io takeDamage:[[Damage alloc] initFromMass:rock.physicsBody.mass]];
        [rock removeFromParent];
    }
}


- (void)addBackground;
{
    // this is just going to be used to tie all background elements together
    self.background = [[Background alloc] initWithColor:[UIColor blackColor] size:CGSizeMake(1000, 2000)];

    
    // add stars
    for (int i = 0; i < 50; i++) {
        CGPoint randomPosition =
            CGPointMake([MathHelpers randomFloatWithMaxValueOf:(self.background.size.width)],
                        [MathHelpers randomFloatWithMaxValueOf:(self.background.size.height)]);
        Star* star = [[Star alloc] initWithPosition:randomPosition];
        [self.background addChild:star];
    }
    
    [self addChild:self.background];
}

- (void) addIo;
{
    self.io = [[Io alloc] init];
    self.io.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-150);
    
    self.io.physicsBody.categoryBitMask = shipCategory;
    self.io.physicsBody.collisionBitMask = shipCategory | rockCategory;
    self.io.physicsBody.contactTestBitMask = shipCategory | rockCategory;
    
    [self.background addChild:self.io];
}

- (void)addRocks
{
    SKAction *makeRocks = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(addRock) onTarget:self],
                                                [SKAction waitForDuration:0.20 withRange:0.40]
                                                ]];
    [self runAction: [SKAction repeatActionForever:makeRocks]];
}

- (void)addRock
{
    CGFloat size = [MathHelpers randomFloatBetween:2 and:6];
    CGSize rockSize = CGSizeMake(size, size);
    SKSpriteNode *rock = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:rockSize];
    rock.name = @"rock";
    
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    rock.physicsBody.density = 1;
    rock.physicsBody.usesPreciseCollisionDetection = YES;
    rock.physicsBody.categoryBitMask = rockCategory;
    
    rock.position = CGPointMake([MathHelpers randomFloatWithMaxValueOf:self.background.size.width],
                                [MathHelpers randomFloatWithMaxValueOf:self.background.size.height]);
    CGVector randomDirection = CGVectorMake([MathHelpers randomFloatBetween:50 and:500],
                                            [MathHelpers randomFloatBetween:50 and:500]);

    rock.physicsBody.velocity = randomDirection;
    rock.physicsBody.linearDamping = 0;
    rock.physicsBody.allowsRotation = NO;
    
    [self.background addChild:rock];
}



-(void)didSimulatePhysics // This gets executed after running physics
{
    [self enumerateChildNodesWithName:@"rock" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0 || node.position.y > self.background.size.height)
            [node removeFromParent];
        if (node.position.x < 0 || node.position.x > self.background.size.width)
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
        CGPoint touchLocationInBackground = [self.background convertPoint:touchLocation fromNode:self];
        [self.io moveTo:touchLocationInBackground];
    }
}

-(void) update:(NSTimeInterval)currentTime
{
    
    self.viewPoint = self.io.position;
  
    // update background position based on Io's movement
    if (self.viewPoint.x > self.frame.size.width/2 &&
        self.viewPoint.x < self.background.size.width - self.frame.size.width/2)
    {
        // update x on background
        [self.background setViewPointX:self.viewPoint.x];
    }

    if (self.viewPoint.y > self.frame.size.height/2 &&
        self.viewPoint.y < self.background.size.height - self.frame.size.height/2)
    {
        // update x on background
        [self.background setViewPointY:self.viewPoint.y];
    }
    
}



@end
