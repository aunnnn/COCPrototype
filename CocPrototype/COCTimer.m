//
//  COCTimer.m
//  CocPrototype
//
//  Created by Wirawit Rueopas on 6/13/2557 BE.
//  Copyright (c) 2557 Wirawit Rueopas. All rights reserved.
//

#import "COCTimer.h"

@interface COCTimer ()
{
    NSArray *arrayOfCOCStageCharacterBlocks;
    int currentBlockIndex;
}

@end


@implementation COCTimer

- (instancetype)initWithArrayOfCOCStageCharacterBlock:(NSArray*)stageBlocks
{
    self = [super init];
    if (self) {
        arrayOfCOCStageCharacterBlocks = stageBlocks;
        
    }
    return self;
}
-(void) start{
    currentBlockIndex = 0;
    COCStageCharacterBlock *firstBlock =  arrayOfCOCStageCharacterBlocks[currentBlockIndex];
    
    float timeInterval = firstBlock.timeIntervalSinceLastBlock;
    [self performSelector:@selector(timerFireMethod) withObject:nil afterDelay:timeInterval];
}
-(void)timerFireMethod
{
    if([self.delegate conformsToProtocol:@protocol(COCTimerDelegate) ]){
        [self.delegate cocTimerTickWithCOCStageCharacterBlock:arrayOfCOCStageCharacterBlocks[currentBlockIndex]];
        if(currentBlockIndex+1 < arrayOfCOCStageCharacterBlocks.count){
            currentBlockIndex++;
            COCStageCharacterBlock *firstBlock =  arrayOfCOCStageCharacterBlocks[currentBlockIndex];
            
            float timeInterval = firstBlock.timeIntervalSinceLastBlock;
            [self performSelector:@selector(timerFireMethod) withObject:nil afterDelay:timeInterval];
        }else{
            //end game do nothing
            currentBlockIndex = 1;
            [self performSelector:@selector(timerFireMethod) withObject:nil afterDelay:1];
        }
        
    }
    
}


@end
