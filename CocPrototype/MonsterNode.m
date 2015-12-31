//
//  MonsterNode.m
//  CocPrototype
//
//  Created by Wirawit Rueopas on 6/11/2557 BE.
//  Copyright (c) 2557 Wirawit Rueopas. All rights reserved.
//

#import "MonsterNode.h"
#import "ScrollingBackground.h"
#import "COCConstants.h"


@implementation MonsterNode

+(instancetype)monsterOne{
    return [[MonsterNode alloc] init];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.characterDidGoBelowGameScene = NO;
        self.characterDidDie = NO;
        self = [MonsterNode spriteNodeWithTexture:walkTexture1];
        self.size = CGSizeMake(MONSTER_WIDTH  , MONSTER_HEIGHT);
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.height/2.0f];
        //self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = COCColliderTypeEnemy;
        self.physicsBody.contactTestBitMask = COCColliderTypeEnemy|COCColliderTypeHero;
   
        [self runAction:walk];
        
        _keyForSlashEffect = [NSString stringWithFormat:@"%i",arc4random()%100000];
        
        self.movementSpeed = 1.0f;
    }
    return self;
}

- (void) update:(NSTimeInterval)currentTime
{
    CGFloat deltaSpeed = [ScrollingBackground scrollingSpeed] + self.movementSpeed;
    self.position= CGPointMake(self.position.x, self.position.y - deltaSpeed);
    if(self.position.y + self.size.height/2.0f < 0){
        self.characterDidGoBelowGameScene = YES;
    }
}
-(void)characterDie{
   // self.movementSpeed = 0 ;
    //self.physicsBody.dynamic = NO;

    [self runAction:dieGroup completion:^{
        [self removeFromParent];
        self.characterDidDie = YES;
        
    }];
}
-(void)characterDidGoBelowScene{
    [self removeFromParent];
}

+(void)loadSharedAssets{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        walkTexture1 = [SKTexture textureWithImageNamed:@"BasicEnemy1.png"];
        walkTexture1.filteringMode = SKTextureFilteringNearest;
        SKTexture* walkTexture2 = [SKTexture textureWithImageNamed:@"BasicEnemy2.png"];
        walkTexture2.filteringMode = SKTextureFilteringNearest;
        SKTexture* dieTexture = [SKTexture textureWithImageNamed:@"BasicEnemyDie.png"];
        dieTexture.filteringMode = SKTextureFilteringNearest;
        
        walk = [SKAction animateWithTextures:@[walkTexture1, walkTexture2] timePerFrame:0.25];
        walk = [SKAction repeatActionForever:walk];
        SKAction *animate = [SKAction animateWithTextures:@[dieTexture] timePerFrame:0.1];
        SKAction *scale = [SKAction scaleTo:1.2 duration:0.1f];
        SKAction *scale2 = [SKAction scaleTo:0.8 duration:0.1f];
        SKAction *scaleSequence = [SKAction sequence:@[scale,scale2]];
        SKAction *fadeOut = [SKAction fadeOutWithDuration:0.2f];
        
        dieGroup = [SKAction group:@[animate, scaleSequence, fadeOut]];
    });
}
static SKAction *walk;
static SKAction *dieGroup;
static SKTexture *walkTexture1;


@end
