//
//  Background.m
//  io
//
//  Created by Jaime Gonzalez Garcia on 03/11/13.
//  Copyright (c) 2013 Jaime Gonzalez Garcia. All rights reserved.
//

#import "Background.h"

@implementation Background




- (void) setViewPointX:(CGFloat)x
{
    self.position = CGPointMake(self.viewPointOffset.x - x, self.position.y);
}

- (void) setViewPointY:(CGFloat)y
{
    self.position = CGPointMake(self.position.x, self.viewPointOffset.y - y);
}


@end
