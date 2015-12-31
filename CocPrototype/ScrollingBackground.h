//
//  ScrollingBackground.h
//  CocPrototype
//
//  Created by Wirawit Rueopas on 6/10/2557 BE.
//  Copyright (c) 2557 Wirawit Rueopas. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ScrollingBackground : SKSpriteNode
+(ScrollingBackground*)defaultBackground;
-(void)setScrollingPaused:(BOOL)p;
- (void) update:(NSTimeInterval)currentTime;
+(CGFloat)scrollingSpeed;
@end
