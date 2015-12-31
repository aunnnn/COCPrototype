//
//  COCStageFileReader.m
//  CocPrototype
//
//  Created by Wirawit Rueopas on 6/13/2557 BE.
//  Copyright (c) 2557 Wirawit Rueopas. All rights reserved.
//

#import "COCStageFileReader.h"
#import "COCStageCharacterBlock.h"
@interface COCStageFileReader ()

@end


@implementation COCStageFileReader
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString* path = [[NSBundle mainBundle] pathForResource: @"GameStageFlow" ofType: @"txt"];
        NSString *total =[ NSString stringWithContentsOfFile:path encoding:4 error:nil];
        _finalDecodingStage = [[total componentsSeparatedByString:@"##########endTime\n"] mutableCopy];
        for (int i =0 ; i < _finalDecodingStage.count ; i++){
            NSString* part = _finalDecodingStage[i];
            COCStageCharacterBlock *blockReader = [[COCStageCharacterBlock alloc] initWithStringTimePart:part];
            _finalDecodingStage[i] = blockReader;
        }
        
        //check
        for(int i=0; i < _finalDecodingStage.count;i++){
            COCStageCharacterBlock *block = _finalDecodingStage[i];
            NSLog(@"%i time %f block %@",i,block.timeIntervalSinceLastBlock, block.rows);
        }
        
    }
    return self;
}
@end
