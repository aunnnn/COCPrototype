//
//  GameManager.h
//  CocPrototype
//
//  Created by Wirawit Rueopas on 6/11/2557 BE.
//  Copyright (c) 2557 Wirawit Rueopas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "MonsterNode.h"
#import "PeopleNode.h"
#import "COCTimer.h"
@interface MonsterManager : NSObject<COCTimerDelegate>
@property int totalMonsterKill;
@property int totalPeopleKill;
@property int totalMonsterPassThrough;
+(instancetype)monsterManagerWithScene:(SKScene*)scene;
-(void)spawnNewMonsterAtX:(CGFloat)x AndY:(CGFloat)y;
-(void)heroContactWithCharacterNode:(COCCharacter *)characterNode;
- (void) update:(NSTimeInterval)currentTime;
-(void) setWalkingPauseAllCharacters:(BOOL)paused;
@end
