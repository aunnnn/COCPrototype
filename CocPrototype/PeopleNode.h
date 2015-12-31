//
//  PeopleNode.h
//  CocPrototype
//
//  Created by Wirawit Rueopas on 6/12/2557 BE.
//  Copyright (c) 2557 Wirawit Rueopas. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "COCCharacter.h"

@interface PeopleNode : COCCharacter
@property NSString *keyForSlashEffect;
+(instancetype)peopleOne;
+(void)loadSharedAssets;
-(void)update:(NSTimeInterval)currentTime;


@end
