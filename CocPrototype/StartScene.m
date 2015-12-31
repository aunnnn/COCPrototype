//
//  StartScene.m
//  CocPrototype
//
//  Created by Wirawit Rueopas on 6/9/2557 BE.
//  Copyright (c) 2557 Wirawit Rueopas. All rights reserved.
//

#import "StartScene.h"
#import "GameScene.h"
@implementation StartScene

-(void)didMoveToView:(SKView *)view{
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Verdana"];
    label.text = @"Tap Anywhere to Start";
    label.fontSize = 20;
    label.fontColor = [SKColor whiteColor];
    label.position = CGPointMake(CGRectGetMidX(self.frame),
                                  CGRectGetMidY(self.frame));
    
    
    [self addChild:label];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    GameScene *gameScene=  [[GameScene alloc] initWithSize:self.frame.size];
  
    [self.view presentScene:gameScene transition:[SKTransition fadeWithDuration:1.0f]];
}


@end
