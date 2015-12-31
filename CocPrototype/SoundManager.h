//
//  SoundManager.h
//  CocPrototype
//
//  Created by Wirawit Rueopas on 6/11/2557 BE.
//  Copyright (c) 2557 Wirawit Rueopas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MonsterNode.h"
#import "PeopleNode.h"
@interface SoundManager : NSObject
+(instancetype)sharedSoundManager;
-(void)playWhooshSoundEffect;
-(void)playSwordChingSoundEffect;
-(void)playMonsterSlashEffectWithMonster:(MonsterNode*)monsterNode;
-(void)playPeopleSlashEffectWithPeople:(PeopleNode *)peopleNode;
-(void)playFireSpecialEffect;
-(void)fadeOutFireSpecialEffect;
@end
