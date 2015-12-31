//
//  MonsterNode.h
//  CocPrototype
//
//  Created by Wirawit Rueopas on 6/11/2557 BE.
//  Copyright (c) 2557 Wirawit Rueopas. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "COCCharacter.h"

typedef enum : uint8_t {
    COCMonsterStateAlive                    =      1,
    COCMonsterStateDidDieAndFadeAway             = 2,
} COCMonsterState;

@interface MonsterNode : COCCharacter
@property NSString *keyForSlashEffect;

+(instancetype)monsterOne;
+(void)loadSharedAssets;
- (void) update:(NSTimeInterval)currentTime;
@end
