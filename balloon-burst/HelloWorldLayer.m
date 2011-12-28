//
//  HelloWorldLayer.m
//  balloon-burst
//
//  Created by Jamie Ly on 12/27/11.
//  Copyright University of Pennsylvania 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "CCTouchDispatcher.h"

CCSprite *seeker1;
NSMutableArray *balloons;

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
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
    CCSprite* balloon = [CCSprite spriteWithFile: @"red_balloon.png"];
    int x = (arc4random() % 400);
    NSLog(@"newBalloon x: %d", x);
    balloon.position = ccp(x, 0);
    balloon.scale = 0.3;
    [self addChild:balloon];
    [balloons addObject:balloon];
    
    id moveUp = [CCMoveTo actionWithDuration:5 position:ccp(x, 400)];
    id cleanupAction = [CCCallFuncND actionWithTarget:self selector:@selector(cleanupSprite:) data:balloon];
    id seq = [CCSequence actions:moveUp, cleanupAction, nil];
    [balloon runAction:seq];

    
    NSLog(@"Balloon count: %i", balloons.count);

    return balloon;
}

- (void) cleanupSprite:(CCSprite*)inSprite
{
    // call your destroy particles here
    // remove the sprite
    [self removeChild:inSprite cleanup:YES];
    [balloons removeObject:inSprite];
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
            [self cleanupSprite:balloon];
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
