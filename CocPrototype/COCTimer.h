//
//  COCTimer.h
//  CocPrototype
//
//  Created by Wirawit Rueopas on 6/13/2557 BE.
//  Copyright (c) 2557 Wirawit Rueopas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "COCStageCharacterBlock.h"

@protocol COCTimerDelegate <NSObject>

@required
-(void)cocTimerTickWithCOCStageCharacterBlock:(COCStageCharacterBlock*)currentCharacterBlock;

@end


@interface COCTimer : NSObject
-(void)start;
- (instancetype)initWithArrayOfCOCStageCharacterBlock:(NSArray*)stageBlocks;
@property id<COCTimerDelegate> delegate;
@end
