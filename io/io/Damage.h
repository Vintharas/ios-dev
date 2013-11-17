//
//  Damage.h
//  io
//
//  Created by Jaime Gonzalez Garcia on 17/11/13.
//  Copyright (c) 2013 Jaime Gonzalez Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Damage : NSObject

@property CGFloat damage;
@property (strong) NSString* type;

- (id) initFromMass:(CGFloat)mass;

@end
