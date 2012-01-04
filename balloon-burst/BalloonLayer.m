//
//  BalloonLayer.m
//  balloon-burst
//
//  Created by Jamie Ly on 12/27/11.
//


// Import the interfaces
#import "BalloonLayer.h"
#import "MenuLayer.h"
#import "CCTouchDispatcher.h"
#import "SimpleAudioEngine.h"

CCLabelTTF *lblScore;
CCLabelTTF *lblTimer;
CCLabelTTF *lblGameOver;
CCLabelTTF *lblRound;

ccColor3B black;
NSString* font;

NSArray *availableTreasures;
NSMutableArray *clouds;
Game *game;

// BalloonLayer implementation
@implementation BalloonLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	BalloonLayer *layer = [BalloonLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void)updateScore: (int) delta{
    game.score += delta;
    [lblScore setString:[[NSString alloc] initWithFormat:@"Treasures Collected: %02d/%02d", 
                         game.treasuresCollected, game.treasuresNeeded]];
}
-(void)updateTime: (float) delta{
    game.timer -= delta;
    [lblTimer setString:[[NSString alloc] initWithFormat:@"Time: %03d", (int)game.timer]];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithColor:ccc4(204,243,255,255)])) {
        globalScale_ = 2;
        
        black = ccc3(0, 0, 0);
        font = @"Helvetica";
        
        game = [[Game alloc] init];
        
        // ask director the the window size
		windowSize_ = [[CCDirector sharedDirector] winSize];
        windowCenter_ = ccp(windowSize_.width / 2, windowSize_.height / 2);
        
        // create an initial balloon
        [self newBalloon];
        
        // schedule a repeating callback on every frame
        [self schedule:@selector(nextFrame:)];
        
        self.isTouchEnabled = YES;
        
        availableTreasures = [[NSArray alloc] initWithObjects:@"GoldenCoin.png", @"treasure_chest.png", @"metal_key.png", @"cupcake_small.png", @"diamond_juliane_krug_01.png", nil];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf"];
        
        clouds = [[NSMutableArray alloc] initWithObjects:nil];
        [self setUpClouds];
        
        // score display
        lblScore = [CCLabelTTF labelWithString:@"Treasures Collected: 00/00" fontName:font fontSize:30];
        CGSize lblSize = lblScore.boundingBox.size;
        lblScore.position = ccp(lblSize.width/2, windowSize_.height-lblSize.height/2);
        lblScore.color = black;
        [self addChild:lblScore];
        
        // timer display
        lblTimer = [CCLabelTTF labelWithString:@"Time: 000" fontName:font fontSize:30];
        lblTimer.position = ccp(windowSize_.width - lblTimer.boundingBox.size.width/2, 
                                windowSize_.height-lblTimer.boundingBox.size.height/2);
        lblTimer.color = black;
        [self addChild:lblTimer];   
        
        lblRound = [CCLabelTTF labelWithString:@"Round 1" fontName:font fontSize:72];
        lblRound.position = windowCenter_;
        lblRound.color = black;
        [self addChild:lblRound];
        [self showRound];
        
        
        [self updateScore: 0];
        
        [self setUpMenu];
        
        // game over
        lblGameOver = [CCLabelTTF labelWithString:@"Game Over" fontName:font fontSize:72];
        lblGameOver.position = ccp(windowCenter_.x, windowCenter_.y + 50);
        lblGameOver.color = black;
        lblGameOver.visible = false;
        [self addChild:lblGameOver];
        
        
	}
	return self;
}

-(void) setUpMenu 
{
    CCLabelTTF *lblMainMenu = [CCLabelTTF labelWithString:@"Main Menu" fontName:font fontSize:30];
    lblMainMenu.color = black;
    
    CCMenuItemLabel *mainMenu = [CCMenuItemLabel itemWithLabel:lblMainMenu target:self selector:@selector(gotoMainMenu:)];
    menu_ = [CCMenu menuWithItems:mainMenu, nil];
    menu_.visible = false;
    [self addChild:menu_];
}

-(void) gotoMainMenu: (CCMenuItem*) menuItem
{
    [[CCDirector sharedDirector] replaceScene:[MenuLayer scene]];
}


-(void) showRound
{
    lblRound.string = [[NSString alloc] initWithFormat:@"Round %d", game.round];
    lblRound.visible = true;
    [lblRound runAction:[CCFadeOut actionWithDuration:2]];   
}

-(void) nextRound 
{
    [game nextRound];
    [self updateScore:0];
    
    [self showRound];
}

-(void) setUpClouds
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    int cloudCount = 5, distribution = size.height / cloudCount;
    for(int i = 0; i< cloudCount; i++ ) {
        CCSprite* cloud = [CCSprite spriteWithFile:@"spite_cloud.png"];
        cloud.scale = 0.1 + (arc4random() % 3) / 10.0f  ;
        
        CGSize rect = cloud.boundingBox.size;
        cloud.position = ccp(arc4random() % (int) size.width, distribution * i + rect.height/2);
        
        [clouds addObject:cloud];
        [self addChild:cloud];
    }
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}


float secondsSinceLastBalloon = 0;

- (void) nextFrame:(ccTime)dt {
    [self updateClouds:dt];
    
    if([game isGameOver]) {
        [self showGameOver];
        return;
    }
    else if([game isRoundComplete]) {
        [self nextRound];
    }

    [self updateTime: dt];
    [self updateBalloons:dt];
}

- (void) updateBalloons:(ccTime)dt {
    // raise all balloons
    for(Balloon* balloon in game.balloons) {
        [balloon raise:dt * 50.0f];
    }
    
    secondsSinceLastBalloon += dt;
    if(secondsSinceLastBalloon > game.balloonPace) {
        [self newBalloon];
        secondsSinceLastBalloon = 0;
    }
}

- (void) updateClouds:(ccTime)dt {
    // all clouds move right
    for(CCSprite* cloud in clouds) {
        CGPoint pos = cloud.position;
        pos.x += dt * 15;
        CGSize cloudSize = cloud.boundingBox.size;
        
        if(pos.x > windowSize_.width) {
            pos.x = -cloudSize.width;
        }
        cloud.position = pos;
    }
}

- (void) showGameOver {
    lblGameOver.visible = true;

    // pop all balloons
    NSArray *balloons = [[NSArray alloc] initWithArray:game.balloons];
    for(Balloon* balloon in balloons) {
        [self popBalloon:balloon];
    }
    
    menu_.visible = true;
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

- (Balloon*) newBalloon {
    Balloon* balloon = [game newBalloon];
    int full = balloon.sprite.boundingBox.size.width * 0.75;
    int x = arc4random() % (int)(windowSize_.width - full) + full;
    
    balloon.sprite.scale *= globalScale_;
    [balloon setPosition: ccp(x, -balloon.sprite.boundingBox.size.height)];
    
    [self addChild:balloon.sprite];
    [self addChild:balloon.label];
    
    return balloon;
}

- (void) explosionAt: (float) x y: (float) y {
    CCParticleSystem* emitter = [CCParticleExplosion node];
    emitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars-grayscale.png"];
	emitter.autoRemoveOnFinish = YES;
    emitter.position = ccp(x,y);
    
    [self addChild:emitter];
}

- (void) cleanUpBalloon:(id) sender data:(Balloon*) balloon {
    [game removeBalloon:balloon];
    [self cleanUpSprite:sender];
}

- (void) cleanUpTreasure:(id) sender data: (DropItem*)treasure {
    [game removeDropItem:treasure];
    [sender stopAllActions];
    [self cleanUpSprite:sender];
}


- (void) cleanUpSprite:(CCSprite*)inSprite
{   
    // call your destroy particles here
    // remove the sprite
    [self removeChild:inSprite cleanup:YES];
}


- (DropItem*) dropTreasure:(Balloon*) balloon {
    DropItem* treasure = [game newDropItem:balloon];
    
    CCLabelTTF *wordLabel = [CCLabelTTF labelWithString:treasure.string fontName:@"Helvetica" fontSize:30];
    wordLabel.color = black;
    
    treasure.sprite = wordLabel;
    
    CGPoint pos = balloon.sprite.position;
    treasure.sprite.position = pos;
    treasure.sprite.scale = 1;
    
    [self addChild:treasure.sprite];
    
    id moveDown = [CCMoveTo actionWithDuration:1 position:ccp(pos.x, -10)];
    
    id cleanupAction = [CCCallFuncND actionWithTarget:self selector:@selector(cleanUpTreasure:data:) data:treasure];
    id seq = [CCSequence actions:moveDown, cleanupAction, nil];
    [treasure.sprite runAction:seq];
    
    return treasure;
}


- (void) popBalloon:(Balloon*) balloon {
    CGPoint pos = balloon.sprite.position;
    [self dropTreasure: balloon];
    [[SimpleAudioEngine sharedEngine] playEffect:@"balloon_pop.mp3"];
    
    [self explosionAt: pos.x y: pos.y];
    [self cleanUpSprite:balloon.label];
    [self cleanUpBalloon:balloon.sprite data: balloon];
}

- (void) pickupTreasure:(DropItem*) treasure {
    game.treasuresCollected ++;
    [self updateScore: 1];
    [[SimpleAudioEngine sharedEngine] playEffect:@"belt_buckle_clink.mp3"];
    [self cleanUpTreasure:treasure.sprite data: treasure];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
	CGPoint location = [self convertTouchToNodeSpace: touch];

    [self checkTouchTreasure:location];
    [self checkTouchBalloons:location];
}

- (void) checkTouchBalloons: (CGPoint) location {
    if([game isGameOver]) return;
    
    // check balloons
    for(Balloon* balloon in game.balloons) {
        // we have to refine this bounding box later
        CGRect rect = [balloon.sprite boundingBox];
        if(CGRectContainsPoint(rect, location)) {
            [self popBalloon:balloon];
            return; // if you don't return here (or handle otherwise), there will be an error (deleting breaks enumeration)
        }
    }
}

- (void) checkTouchTreasure: (CGPoint) location {
    // check treasures first, so we don't drop something just to pick it up
    for(DropItem* treasure in game.dropItems) {
        // we have to refine this bounding box later
        CGRect rect = [treasure.sprite boundingBox];
        if(CGRectContainsPoint(rect, location)) {
            [self pickupTreasure:treasure];
            return;  // if you don't return here (or handle otherwise), there will be an error (deleting breaks enumeration)
        }
    }
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
