//
//  ScrollingBackground.m
//  CocPrototype
//
//  Created by Wirawit Rueopas on 6/10/2557 BE.
//  Copyright (c) 2557 Wirawit Rueopas. All rights reserved.
//

#import "ScrollingBackground.h"

@interface ScrollingBackground ()
{
    SKSpriteNode *bg1, *bg2;
    BOOL scrollingPaused;
}

@end

static CGFloat scrollingSpeed;

@implementation ScrollingBackground
- (instancetype)init
{
    self = [super init];
    if (self) {
        scrollingPaused = NO;
        scrollingSpeed = 2.0f;
        bg1 = [SKSpriteNode spriteNodeWithImageNamed:@"bg2.jpg"];
        bg2 = [SKSpriteNode spriteNodeWithImageNamed:@"bg2.jpg"];
       // bg1 = [SKSpriteNode spriteNodeWithColor:[UIColor brownColor] size:CGSizeZero];
       // bg2 = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeZero];
        bg1.size = [[UIScreen mainScreen] bounds].size;
        bg2.size = [[UIScreen mainScreen] bounds].size;
        bg1.anchorPoint = CGPointZero;
        bg2.anchorPoint = CGPointZero;
        bg1.position = CGPointZero;
        bg2.position = CGPointMake(0, bg1.frame.size.height);
        
        
        [self addChild:bg1];
        [self addChild:bg2];
        
    }
    return self;
}
+(ScrollingBackground*)defaultBackground{
    return [[ScrollingBackground alloc] init];
}
- (void) update:(NSTimeInterval)currentTime
{
    if(!scrollingPaused){

        [self.children enumerateObjectsUsingBlock:^(SKNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SKSpriteNode *child = (SKSpriteNode*)obj;
            if(child != nil){
                child.position = CGPointMake(child.position.x, child.position.y-scrollingSpeed);
                if (child.position.y <= -child.size.height){
                    child.position = CGPointMake(0, child.size.height);
                }
            }
        }];
    }else{
        //do nothing
    }
    
}
-(void)setScrollingPaused:(BOOL)p{
    scrollingPaused = p;
}
+(CGFloat)scrollingSpeed{
    return scrollingSpeed;
}
@end
