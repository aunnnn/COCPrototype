//
//  COCStageBlock.h
//  CocPrototype
//
//  Created by Wirawit Rueopas on 6/13/2557 BE.
//  Copyright (c) 2557 Wirawit Rueopas. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface COCStageCharacterBlock : NSObject
{

}
@property NSArray *rows;
@property float timeIntervalSinceLastBlock;

- (instancetype)initWithStringTimePart:(NSString*)timePartString;
@end
