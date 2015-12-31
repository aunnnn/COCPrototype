//
//  COCCharacter.h
//  CocPrototype
//
//  Created by Wirawit Rueopas on 6/12/2557 BE.
//  Copyright (c) 2557 Wirawit Rueopas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

/* Bitmask for the different entities with physics bodies. */
typedef enum : uint8_t {
    COCColliderTypeHero             = 1,
    COCColliderTypeEnemy            = 2,
    COCColliderTypePeople           = 4,
    COCCOlliderTypeWall             = 8,
} COCColliderType;

@interface COCCharacter : SKSpriteNode
@property CGFloat movementSpeed;
@property BOOL characterDidDie;
@property BOOL characterDidGoBelowGameScene;
-(void)characterDie;
-(void)update:(NSTimeInterval)currentTime;
-(void)characterDidGoBelowScene;
@end
