//
//  SoundManager.m
//  CocPrototype
//
//  Created by Wirawit Rueopas on 6/11/2557 BE.
//  Copyright (c) 2557 Wirawit Rueopas. All rights reserved.
//

#import "SoundManager.h"
#import "COCAudioPlayer.h"

@interface SoundManager ()<AVAudioPlayerDelegate>
{
    NSArray *whooshSounds, *slashSounds,*screamSounds;
    //slash contain 10
    NSMutableDictionary *monsterToSlashSound;
    NSMutableDictionary *peopleToScreamSound;
    COCAudioPlayer *swordChingSound,*fireSpecialEffect;
    BOOL playingWhoosh;
}
@end
@implementation SoundManager
+(instancetype)sharedSoundManager{
    return [[SoundManager alloc] init ];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        monsterToSlashSound = [NSMutableDictionary new];
        
        NSMutableArray * whooshMutable = [NSMutableArray new];
        NSMutableArray * slashMutable = [NSMutableArray new];
        NSMutableArray * screamMutable= [NSMutableArray new];
        for(int i =0 ; i < 4 ; i++){
            NSString * name = [NSString stringWithFormat:@"whoosh%i",(i+1)];
            NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"mp3"]];
            COCAudioPlayer * whoosh = [[COCAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            [whooshMutable addObject:whoosh];
            [whoosh prepareToPlay];
        }
        whooshSounds = [NSArray arrayWithArray:whooshMutable];
        for(int i =0 ; i < 2*5 ; i++){
            NSString * name = [NSString stringWithFormat:@"slash%i",(i%2)+1];
            NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"mp3"]];
            COCAudioPlayer * slash = [[COCAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            [slashMutable addObject:slash];
            [slash prepareToPlay];
        }
        for(int i =0 ; i < 3 ; i++){
            NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"peopleScream" ofType:@"wav"]];
            COCAudioPlayer * scream = [[COCAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            [screamMutable addObject:scream];
            [scream prepareToPlay];
        }
        
        slashSounds = [NSArray arrayWithArray:slashMutable];
        screamSounds = [NSArray arrayWithArray:screamMutable];
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"SwordCollide" ofType:@"wav"]];
        swordChingSound = [[COCAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [swordChingSound prepareToPlay];
        NSURL *url2 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"fireEffect" ofType:@"mp3"]];
        fireSpecialEffect = [[COCAudioPlayer alloc ] initWithContentsOfURL:url2 error:nil];
        
    }
    return self;
}
-(void)playWhooshSoundEffect{
   // if(playingWhoosh) return;
    int num = arc4random()%[whooshSounds count];
    COCAudioPlayer* whoosh = whooshSounds[num];
    
    [whoosh prepareToPlay];
    [whoosh play];
}
-(void)playMonsterSlashEffectWithMonster:(MonsterNode*)monsterNode{
    if([monsterToSlashSound objectForKey:monsterNode.keyForSlashEffect]){
        return;
    }
    int num = arc4random()%[slashSounds count];
    COCAudioPlayer* slash = slashSounds[num];
    slash.delegate = self;
    slash.currentKeyFromNode = monsterNode.keyForSlashEffect;
    [monsterToSlashSound setObject:slash forKey:monsterNode.keyForSlashEffect];
    [slash prepareToPlay];
    [slash play];
 
}
-(void)playPeopleSlashEffectWithPeople:(PeopleNode *)peopleNode
{
    if([peopleToScreamSound objectForKey:peopleNode.keyForSlashEffect]){
        return;
    }
    int num = arc4random()%[screamSounds count];
    COCAudioPlayer* scream = screamSounds[num];
    scream.delegate = self;
    scream.currentKeyFromNode = peopleNode.keyForSlashEffect;
    [peopleToScreamSound setObject:scream forKey:peopleNode.keyForSlashEffect];
    [scream prepareToPlay];
    [scream play];
    
}
-(void)playSwordChingSoundEffect{
    [swordChingSound prepareToPlay];
    [swordChingSound play];
}
-(void)audioPlayerDidFinishPlaying:(COCAudioPlayer *)player successfully:(BOOL)flag{
    
    [monsterToSlashSound removeObjectForKey:player.currentKeyFromNode];
    [peopleToScreamSound removeObjectForKey:player.currentKeyFromNode];
}
-(void)playFireSpecialEffect
{
    [fireSpecialEffect prepareToPlay];
    [fireSpecialEffect play];
}
-(void)fadeOutFireSpecialEffect
{
    if (fireSpecialEffect.volume > 0.1) {
        fireSpecialEffect.volume = fireSpecialEffect.volume - 0.1;
        [self performSelector:@selector(fadeOutFireSpecialEffect) withObject:nil afterDelay:0.1];
    } else {
        // Stop and get the sound ready for playing again
        [fireSpecialEffect stop];
        fireSpecialEffect.currentTime = 0;
        [fireSpecialEffect prepareToPlay];
        fireSpecialEffect.volume = 1.0;
    }
}
@end
