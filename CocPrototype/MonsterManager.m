//
//  GameManager.m
//  CocPrototype
//
//  Created by Wirawit Rueopas on 6/11/2557 BE.
//  Copyright (c) 2557 Wirawit Rueopas. All rights reserved.
//

#import "MonsterManager.h"
#import <SpriteKit/SpriteKit.h>


#import "COCStageFileReader.h"
#import "COCConstants.h"
#import "COCTimer.h"

@interface MonsterManager ()
{
    SKScene *targetScene;
    NSMutableArray *monsterAliveNodes;
    NSMutableArray *monsterDeathNodes;
    NSMutableArray *peopleAliveNodes;
    NSMutableArray *peopleDeathNodes;
    COCStageFileReader *stageReader;
    COCTimer *monsterTimer;
    BOOL walkingPaused;
}

@end

@implementation MonsterManager
+(instancetype)monsterManagerWithScene:(SKScene*)scene{

    return [[MonsterManager alloc] initWithScene:scene];
}
- (instancetype)initWithScene:(SKScene*)scene
{
    self = [super init];
    if (self) {
        walkingPaused = NO;
        stageReader = [[COCStageFileReader alloc] init];
        monsterTimer = [[COCTimer alloc] initWithArrayOfCOCStageCharacterBlock:stageReader.finalDecodingStage];
        monsterTimer.delegate = self;
        
        
        _totalMonsterKill = 0;
        _totalPeopleKill = 0 ;
        targetScene = scene;
        
        monsterAliveNodes = [NSMutableArray new];
        monsterDeathNodes = [NSMutableArray new];
        peopleAliveNodes = [NSMutableArray new];
        peopleDeathNodes = [NSMutableArray new];
        [MonsterNode loadSharedAssets];
        [PeopleNode loadSharedAssets];
        
        [monsterTimer start];
    }

    return self;
}

-(void)spawnNewMonsterAtX:(CGFloat)x AndY:(CGFloat)y
{
    MonsterNode *monsterNode = [MonsterNode monsterOne];
    monsterNode.position = CGPointMake(x, y);
    [monsterAliveNodes addObject:monsterNode];
    [targetScene addChild:monsterNode];
}
-(void)spawnCharacterWithIntCode:(int) code AtX:(CGFloat)x AndY:(CGFloat)y{
    COCCharacter *characterNode ;
    if(code == 1){
        characterNode = [MonsterNode monsterOne];
        [monsterAliveNodes addObject:characterNode];
    }else if (code == -1){
        characterNode = [PeopleNode peopleOne];
        [peopleAliveNodes addObject:characterNode];
    }else{
        return;
    }
    characterNode.position = CGPointMake(x, y);

    [targetScene addChild:characterNode];
    
    
}
-(void)heroContactWithCharacterNode:(COCCharacter *)characterNode
{
    [characterNode characterDie];
}
- (void) update:(NSTimeInterval)currentTime
{
    if(!walkingPaused){
    //MONSTER UPDATE
    for (MonsterNode *monster in monsterAliveNodes) {
        if(!monster.characterDidDie){
            if(!monster.characterDidGoBelowGameScene){
                [monster update:currentTime];
            }else{
                [monsterDeathNodes addObject:monster];
                [monster characterDidGoBelowScene];
            }
        }else{
            self.totalMonsterKill++;
            [monsterDeathNodes addObject:monster];
        }
        
    }
    for(MonsterNode *death in monsterDeathNodes){
        [monsterAliveNodes removeObject:death];
    }
    [monsterDeathNodes removeAllObjects];
    
    //PEOPLE UPDATE
    for (PeopleNode *people in peopleAliveNodes) {
        if(!people.characterDidDie){
            if(!people.characterDidGoBelowGameScene){
                [people update:currentTime];
            }else{
                [peopleDeathNodes addObject:people];
                [people characterDidGoBelowScene];
            }
        }else{
            self.totalPeopleKill++;
            [peopleDeathNodes addObject:people];
        }
        
    }
    for(PeopleNode *people in peopleDeathNodes){
        [peopleAliveNodes removeObject:people];
    }
    [peopleDeathNodes removeAllObjects];
    }else{
        //do nothing
    }
 
    //NSLog(@"count alive %i",(int)[monsterAliveNodes count]);
}
-(void)cocTimerTickWithCOCStageCharacterBlock:(COCStageCharacterBlock *)currentCharacterBlock
{
    NSArray *rowsArray = currentCharacterBlock.rows;
    for(int row = 0 ; row < rowsArray.count ; row++){
        NSArray *colsArray = rowsArray[row];
        for (int col = 0; col < colsArray.count  ; col++) {
            NSNumber* characterCode = [colsArray objectAtIndex:col];
            int intCode = (int)[characterCode integerValue];
    
            CGFloat x = ROAD_SIDE_INSET+MONSTER_WIDTH/2.0f + col*MONSTER_WIDTH;
            CGFloat y = targetScene.size.height+row*MONSTER_HEIGHT;
            [self spawnCharacterWithIntCode:intCode AtX:x AndY:y];
                
          
            
        }
    }
}
-(void)setWalkingPauseAllCharacters:(BOOL)paused{
    //MONSTER UPDATE
    walkingPaused = paused;
}
@end
