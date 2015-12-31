//
//  HeroSpriteNode.m
//  CocPrototype
//
//  Created by Wirawit Rueopas on 6/9/2557 BE.
//  Copyright (c) 2557 Wirawit Rueopas. All rights reserved.
//

#import "HeroSpriteNode.h"
#import "COCConstants.h"

@interface HeroSpriteNode ()

@property (strong,nonatomic) SKAction * walk; //default
@property (strong,nonatomic) SKAction * run; //move


@end


@implementation HeroSpriteNode
-(id)init{
    if(self = [super init]){
        
        SKTexture* walkTexture1 = [SKTexture textureWithImageNamed:@"Hero1.png"];
        walkTexture1.filteringMode = SKTextureFilteringNearest;
        SKTexture* walkTexture2 = [SKTexture textureWithImageNamed:@"Hero2.png"];
        walkTexture2.filteringMode = SKTextureFilteringNearest;
        
        SKTexture* runTexture1 = [SKTexture textureWithImageNamed:@"Hero.png"];
        runTexture1.filteringMode = SKTextureFilteringNearest;
        

        self = [HeroSpriteNode spriteNodeWithTexture:walkTexture1];
        self.size = CGSizeMake(HERO_WIDTH  , HERO_HEIGHT);
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(self.size.height-20)/2.0f];
//        SKShapeNode *physicsCheckShapeNode = [SKShapeNode shapeNodeWithEllipseInRect:CGRectMake(0, 0, 28,28)];
//        physicsCheckShapeNode.fillColor = [UIColor redColor];
//        physicsCheckShapeNode.strokeColor = [UIColor greenColor];
//        physicsCheckShapeNode.position = CGPointMake(-20, -20);
//        physicsCheckShapeNode.zPosition = 1;
//        [self addChild:physicsCheckShapeNode];
        //self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = COCColliderTypeHero;
        self.physicsBody.contactTestBitMask = 0;

        self.walk = [SKAction animateWithTextures:@[walkTexture1, walkTexture2] timePerFrame:0.25];
        self.walk = [SKAction repeatActionForever:self.walk];
        self.run = [SKAction animateWithTextures:@[runTexture1] timePerFrame:0.25];
        self.run = [SKAction repeatActionForever:self.run];
        

        [self setTexture:walkTexture1];
        [self runAction:self.walk withKey:@"walk"];
        
        _runSpeed = 100.0f;

        
    }
    return self;
}
-(void)moveToPosition:(CGPoint) position{
    self.position = position;
    [self runAction:self.run withKey:@"run"];
}
-(void)runWalkingAction{
    [self runAction:self.walk withKey:@"walk"];
}
@end
