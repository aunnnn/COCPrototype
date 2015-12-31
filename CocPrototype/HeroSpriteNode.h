//
//  HeroSpriteNode.h
//  CocPrototype
//
//  Created by Wirawit Rueopas on 6/9/2557 BE.
//  Copyright (c) 2557 Wirawit Rueopas. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "COCCharacter.h"
@interface HeroSpriteNode : COCCharacter
@property CGFloat runSpeed;

-(void)moveToPosition:(CGPoint) position;
-(void)runWalkingAction;
@end
