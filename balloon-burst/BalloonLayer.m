//
//  BalloonLayer.m
//  balloon-burst
//
//  Created by Jamie Ly on 12/27/11.
//


// Import the interfaces
#import "BalloonLayer.h"
#import "CCTouchDispatcher.h"
#import "SimpleAudioEngine.h"

CCSprite *seeker1;
NSMutableArray *balloons;
CCLabelTTF *lblScore;

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

int score = 0;
-(void)updateScore: (int) delta{
    score += delta;
    [lblScore setString:[[NSString alloc] initWithFormat:@"Score: %04d", score]];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        // ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
    
        
        // create and initialize our seeker sprite, and add it to this layer
        seeker1 = [CCSprite spriteWithFile: @"seeker.png"];
        seeker1.position = ccp( 50, 100 );
        [self addChild:seeker1];
        
        balloons = [[NSMutableArray alloc] initWithObjects:nil];
        
        // create an initial balloon
        [self newBalloon];
        
        // schedule a repeating callback on every frame
        [self schedule:@selector(nextFrame:)];
        
        self.isTouchEnabled = YES;
        [self setUpMenus];
        
        // score display
        lblScore = [CCLabelTTF labelWithString:@"Score: 0000" fontName:@"Helvetica" fontSize:30];
        CGSize lblSize = lblScore.boundingBox.size;
        lblScore.position = ccp(lblSize.width/2, size.height-lblSize.height/2);
        [self addChild:lblScore];
        
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf"];
	}
	return self;
}

// set up the Menus
-(void) setUpMenus
{
    
	// Create some menu items
	CCMenuItemImage * menuItem1 = [CCMenuItemImage itemFromNormalImage:@"myfirstbutton.png"
                                                         selectedImage: @"myfirstbutton_selected.png"
                                                                target:self
                                                              selector:@selector(doSomethingOne:)];
    
	CCMenuItemImage * menuItem2 = [CCMenuItemImage itemFromNormalImage:@"mysecondbutton.png"
                                                         selectedImage: @"mysecondbutton_selected.png"
                                                                target:self
                                                              selector:@selector(doSomethingTwo:)];
    
    
	CCMenuItemImage * menuItem3 = [CCMenuItemImage itemFromNormalImage:@"mythirdbutton.png"
                                                         selectedImage: @"mythirdbutton_selected.png"
                                                                target:self
                                                              selector:@selector(doSomethingThree:)]; 
    
    
	// Create a menu and add your menu items to it
	CCMenu * myMenu = [CCMenu menuWithItems:menuItem1, menuItem2, menuItem3, nil];
    
	// Arrange the menu items vertically
	[myMenu alignItemsVertically];
    
	// add the menu to your scene
	[self addChild:myMenu];
}

- (void) doSomethingOne: (CCMenuItem  *) menuItem 
{
	NSLog(@"The first menu was called");
}
- (void) doSomethingTwo: (CCMenuItem  *) menuItem 
{
	NSLog(@"The second menu was called");
}
- (void) doSomethingThree: (CCMenuItem  *) menuItem 
{
	NSLog(@"The third menu was called");
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}


float secondsSinceLastBalloon = 0;

- (void) nextFrame:(ccTime)dt {
    seeker1.position = ccp( seeker1.position.x + 100*dt, seeker1.position.y );
    if (seeker1.position.x > 480+32) {
        seeker1.position = ccp( -32, seeker1.position.y );
    }
    
    secondsSinceLastBalloon += dt;
    if(secondsSinceLastBalloon > 2.0f) {
        [self newBalloon];
        secondsSinceLastBalloon = 0;
    }
    
}

- (CCSprite*) newBalloon {
    CCSprite* balloon = [CCSprite spriteWithFile: @"balloon.png"];
    int x = arc4random() % 400;
    int balloonSpeed = arc4random() % 8 + 2;
    
    NSLog(@"newBalloon x: %d", x);
    balloon.position = ccp(x, 0);
    balloon.scale = balloonSpeed/60.0f;
    [self addChild:balloon];
    [balloons addObject:balloon];
    
    
    id moveUp = [CCMoveTo actionWithDuration:balloonSpeed position:ccp(x, 400)];
    id cleanupAction = [CCCallFuncND actionWithTarget:self selector:@selector(cleanUpSprite:) data:balloon];
    id seq = [CCSequence actions:moveUp, cleanupAction, nil];
    [balloon runAction:seq];

    
    NSLog(@"Balloon count: %i", balloons.count);

    return balloon;
}

- (void) explosionAt: (float) x y: (float) y {
    CCParticleSystem* emitter = [CCParticleExplosion node];
    emitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars-grayscale.png"];
	emitter.autoRemoveOnFinish = YES;
    emitter.position = ccp(x,y);
    
    [self addChild:emitter];
}

- (void) cleanUpSprite:(CCSprite*)inSprite
{   
    // call your destroy particles here
    // remove the sprite
    [self removeChild:inSprite cleanup:YES];
    [balloons removeObject:inSprite];
}


- (void) popBalloon:(CCSprite*) balloon {
    [self updateScore: 10];
    [[SimpleAudioEngine sharedEngine] playEffect:@"balloon_pop.mp3"];
    [self explosionAt: balloon.position.x y:balloon.position.y];
    [self cleanUpSprite:balloon];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
	CGPoint location = [self convertTouchToNodeSpace: touch];
    
    for(CCSprite* balloon in balloons) {
        // we have to refine this bounding box later
        CGRect rect = [balloon boundingBox];
        if(CGRectContainsPoint(rect, location)) {
            [self popBalloon:balloon];
            return; 
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
