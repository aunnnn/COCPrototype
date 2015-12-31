//
//  COCStageBlock.m
//  CocPrototype
//
//  Created by Wirawit Rueopas on 6/13/2557 BE.
//  Copyright (c) 2557 Wirawit Rueopas. All rights reserved.
//

#import "COCStageCharacterBlock.h"

@implementation COCStageCharacterBlock

- (instancetype)initWithStringTimePart:(NSString*)timePartString
{
    self = [super init];
    if (self) {
        NSString* encodingString = timePartString;
        
        NSMutableArray* linePart = [[encodingString componentsSeparatedByString:@"\n" ] mutableCopy];
        [linePart removeLastObject];
        for(int i=0 ; i < linePart.count ; i++){
            NSString* partsInLine = linePart[i];
            NSMutableArray* encodingRows = [[partsInLine componentsSeparatedByString:@"," ] mutableCopy];
            if(i==0)
            {//time,...
                _timeIntervalSinceLastBlock = ([encodingRows[1] floatValue]);
                
                
            }else{
                //@,0,0,0,0
                NSMutableArray *temp = [NSMutableArray new] ;
                for(int col = 1 ; col < encodingRows.count ; col++){
                    NSString* string = encodingRows[col];
                    NSString* checkFirstString   = [NSString stringWithFormat:@"%c" , [string characterAtIndex:0]];
            
                    if([checkFirstString isEqualToString:@"-"] ){
                        //minus number
                        
                        NSString* otherString = [string substringFromIndex:1];
    
                        [temp addObject:[NSNumber numberWithFloat:-[otherString floatValue]]];
                    }else
                        [temp addObject:[NSNumber numberWithFloat:[encodingRows[col] floatValue]]];
                }
                NSArray *colsInCurrentRow = [NSArray arrayWithArray:temp];
                linePart[i] = colsInCurrentRow;
            }
        }
        [linePart removeObjectAtIndex:0];
        _rows = [linePart mutableCopy];
    }
    return self;
}

@end
