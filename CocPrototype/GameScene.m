//
//  GameScene.m
//  CocPrototype
//
//  Created by Wirawit Rueopas on 6/9/2557 BE.
//  Copyright (c) 2557 Wirawit Rueopas. All rights reserved.
//

#import "GameScene.h"
#import "HeroSpriteNode.h"
#import "SKBlade.h"
#import "ScrollingBackground.h"
#import "MonsterManager.h"
#import "SoundManager.h"

#import "COCConstants.h"

@interface GameScene ()
{
    HeroSpriteNode *heroNode;
    SKBlade *blade;
    SKEmitterNode *fire;
    ScrollingBackground *bgNode;
    SKLabelNode *totalMonsterKillLabel,*totalPeopleKillLabel;
    
    BOOL fireEnabled;
    
    SKSpriteNode *specialPowerMeter ,*meterNode;
    SKAction *meterFadeAction,*meterShrinkAction;
    BOOL specialPowerActivating,specialPowerUsing;
    
    CGFloat lastSqrVelocity,currentSqrVelocity;

    MonsterManager *monsterManager;
    SoundManager *soundManager;
    
    int countKillsForSpecialAttack;
    int currentKills;
    
}
@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    [self setUpPhysicsWorld];
    soundManager = [SoundManager sharedSoundManager];
    
    
    [self setUpScrollingBackground];

    [self setUpHero];
    
    [self setUpHeroEffect];
    
    [self setUptotalKillLabelNode];
    
    [self setUpSpecialPowerMeter];
    monsterManager = [MonsterManager monsterManagerWithScene:self];

    UIPanGestureRecognizer *panGr=  [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGr];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGr.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGr];
    
    UITapGestureRecognizer *tap3Gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapThreeGesture:)];
    tap3Gr.numberOfTapsRequired = 3;
    [self.view addGestureRecognizer:tap3Gr];

    specialPowerUsing = NO;
    specialPowerActivating = NO;
    
}


- (void)update:(CFTimeInterval)currentTime
{

    
    [bgNode update:currentTime];
    [monsterManager update:currentTime];
    [self updateSPMeter];

    [totalMonsterKillLabel setText:[NSString stringWithFormat:@"%i !",monsterManager.totalMonsterKill]];
    [totalPeopleKillLabel setText:[NSString stringWithFormat:@"%i !",monsterManager.totalPeopleKill]];
    
    currentKills = monsterManager.totalMonsterKill;
}


#pragma mark - handle gesture
-(void)handleTapThreeGesture:(UIPinchGestureRecognizer*) recognizer{
    if(self.paused){
        self.paused = NO;
        [bgNode setScrollingPaused:NO];
        [monsterManager setWalkingPauseAllCharacters:NO];
    }else{
        self.paused = YES;
        [bgNode setScrollingPaused:YES];
        [monsterManager setWalkingPauseAllCharacters:YES];
    }
}
-(void)handleTapGesture:(UITapGestureRecognizer*)recognizer{
    
    NSLog(@"using %i  acti %i",specialPowerUsing,specialPowerActivating);
    if(specialPowerActivating&&!specialPowerUsing){
        specialPowerUsing = YES;
        [heroNode addChild:fire];
        [soundManager playFireSpecialEffect];
        [meterNode runAction:meterShrinkAction completion:^{
            specialPowerUsing = NO;
            specialPowerActivating = NO;
            countKillsForSpecialAttack = 0;
            [fire removeFromParent];
            [meterNode removeAllActions];
            [soundManager fadeOutFireSpecialEffect];
        }];
    }
}
-(void)handlePanGesture:(UIPanGestureRecognizer*)recognizer{
    CGPoint location = [recognizer locationInView:recognizer.view];
    location = [self convertPointFromView:location];
    CGPoint velocity = [recognizer velocityInView:self.view];
    
    NSLog(@"location = %@",NSStringFromCGPoint(location));
    
    if(recognizer.state == UIGestureRecognizerStateBegan){
        if(!specialPowerUsing)
            [self presentBladeAtPosition:CGPointZero];
    }else if (recognizer.state ==UIGestureRecognizerStateChanged){
        //NSLog(@"VELOC %f",sqrtf( powf(velocity.x, 2)+powf(velocity.y, 2)));
        currentSqrVelocity = sqrtf( powf(velocity.x, 2)+powf(velocity.y, 2));
        
        if(currentSqrVelocity > 500){
            [soundManager playWhooshSoundEffect];
        }
        
        [heroNode moveToPosition:location];
        //NSLog(@"atan %f",atan2f(velocity.y, velocity.x)*180.0f/M_PI);
        [heroNode runAction:[SKAction rotateToAngle:atan2f(velocity.y, velocity.x)+M_PI_2 duration:0.1f] completion:nil];
        lastSqrVelocity = currentSqrVelocity;
    }else if (recognizer.state == UIGestureRecognizerStateEnded){
        if(!specialPowerUsing)
            [self removeBlade];
    }
}

#pragma mark - Physics World Delegate
-(void)didBeginContact:(SKPhysicsContact *)contact{
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ([firstBody.node isKindOfClass:[HeroSpriteNode class]] != 0 && ([secondBody.node isKindOfClass:[MonsterNode class]]))
        //hero and enemy
    {
    
        MonsterNode *monsterNode = (MonsterNode*)secondBody.node;
        [soundManager playMonsterSlashEffectWithMonster:monsterNode];
        [monsterManager heroContactWithCharacterNode:monsterNode];
    
    }else if (!specialPowerUsing&&[firstBody.node isKindOfClass:[HeroSpriteNode class]] != 0 && ([secondBody.node isKindOfClass:[PeopleNode class]])){
        PeopleNode *peopleNode = (PeopleNode*)secondBody.node;
        [soundManager playPeopleSlashEffectWithPeople:peopleNode];
        [soundManager playSwordChingSoundEffect];
        [monsterManager heroContactWithCharacterNode:peopleNode];
    }
    

}


#pragma mark - SKBlade Functions

// This will help us to initialize our blade
- (void)presentBladeAtPosition:(CGPoint)position
{
    blade = [[SKBlade alloc] initWithPosition:CGPointMake(0, 20)
                                   TargetNode:self
                                        Color:[UIColor whiteColor]];

    [heroNode addChild:blade];
}

// This will help us to remove our blade and reset the _delta value
- (void)removeBlade
{
    [blade removeFromParent];
}

#pragma mark - Set up Functions
-(void)setUpScrollingBackground{
    bgNode = [ScrollingBackground defaultBackground] ;
    bgNode.anchorPoint = CGPointZero ;
    bgNode.position = CGPointZero;
    [self addChild:bgNode];
}
-(void)setUpHero{
    heroNode = [HeroSpriteNode new];
    heroNode.position = CGPointMake(100, 100);
    [self addChild:heroNode];
}
-(void)setUpHeroEffect{
    NSString *firePath = [[NSBundle mainBundle] pathForResource:@"MySlashParticle" ofType:@"sks"];
    fire = [NSKeyedUnarchiver unarchiveObjectWithFile:firePath];
    fire.position = CGPointMake(0, 20);
    fire.targetNode = bgNode;
    //[heroNode addChild:fire];
}
-(void)setUpPhysicsWorld{
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    
    // Left Wall
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(ROAD_SIDE_INSET, CGRectGetHeight(self.frame))];
    node.alpha = 0.0f;
    node.anchorPoint= CGPointZero ;
    node.position = CGPointZero ;
    NSLog(@"%i dynamic",node.physicsBody.dynamic);
    node.physicsBody.categoryBitMask = COCCOlliderTypeWall;
    node.physicsBody.contactTestBitMask =  COCColliderTypeEnemy;
    node.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0.0f, 0.0f, ROAD_SIDE_INSET, CGRectGetHeight(self.frame))];
    node.zPosition = 5.0f;
    [self addChild:node];
    
    // Right wall
    SKSpriteNode *node2 = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(ROAD_SIDE_INSET, CGRectGetHeight(self.frame))];
    node2.alpha = 0.0f;
    node2.anchorPoint= CGPointZero ;
    node2.position = CGPointMake(CGRectGetWidth(self.frame)-ROAD_SIDE_INSET, 0) ;
    node2.physicsBody.categoryBitMask = COCCOlliderTypeWall;
    node2.physicsBody.contactTestBitMask =  COCColliderTypeEnemy;
    node2.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(CGRectGetWidth(self.frame) - ROAD_SIDE_INSET, 0.0f, ROAD_SIDE_INSET, CGRectGetHeight(self.view.frame))];
    node2.zPosition = 5.0f;
    [self addChild:node2];
    
}
-(void)setUptotalKillLabelNode{
    totalMonsterKillLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    totalMonsterKillLabel.text = @"0!";
    totalMonsterKillLabel.fontSize = 26;
    totalMonsterKillLabel.fontColor = [SKColor whiteColor];
    totalMonsterKillLabel.position = CGPointMake(40,20);
    
    [self addChild:totalMonsterKillLabel];
    
    totalPeopleKillLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    totalPeopleKillLabel.text = @"0!";
    totalPeopleKillLabel.fontSize = 26;
    totalPeopleKillLabel.fontColor = [SKColor redColor];
    totalPeopleKillLabel.position = CGPointMake(self.size.width-40,20);
    
    [self addChild:totalPeopleKillLabel];
}
-(void)setUpSpecialPowerMeter{
    specialPowerMeter = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(self.size.width/2, 16)];
    specialPowerMeter.anchorPoint = CGPointZero;
    specialPowerMeter.position = CGPointMake(68, 20);
    [self addChild:specialPowerMeter];
    [specialPowerMeter setZPosition:10.0f];
    
    meterNode = [SKSpriteNode spriteNodeWithColor:[UIColor yellowColor] size:CGSizeMake(countKillsForSpecialAttack*(self.size.width/20), 16)];
    meterNode.anchorPoint = CGPointZero;
    meterNode.position = CGPointZero;
    [specialPowerMeter addChild:meterNode];
    
    SKAction * fadeOutMeter = [SKAction fadeAlphaTo:0.5f duration:0.5];
    SKAction * fadeInMeter = [SKAction fadeAlphaTo:1.0f duration:0.5];
    meterFadeAction = [SKAction sequence:@[fadeOutMeter,fadeInMeter]];
    meterFadeAction = [SKAction repeatActionForever:meterFadeAction];

    meterShrinkAction = [SKAction resizeToWidth:0 duration:SPECIAL_POWER_DURATION];
}

-(void)updateSPMeter{
    int diff = monsterManager.totalMonsterKill - currentKills;
    if(diff > 0){
        if(!specialPowerActivating){
            if(countKillsForSpecialAttack+diff >= 10){
                NSLog(@"SPEXIAL Activating");
                countKillsForSpecialAttack = 10;
                specialPowerActivating = YES;
                specialPowerUsing = NO;
                [meterNode runAction:meterFadeAction];
            }else{
                countKillsForSpecialAttack += diff;
            }
        }
    }
    
    if(countKillsForSpecialAttack >9){
        meterNode.color = [UIColor greenColor];
    }else if(countKillsForSpecialAttack > 6){
        meterNode.color = [UIColor orangeColor];
    }else if (countKillsForSpecialAttack > 4){
        meterNode.color = [UIColor yellowColor];
    }
    
    meterNode.size = CGSizeMake(countKillsForSpecialAttack*(self.size.width/20), 16);
}

@end
