//
//  MenuScene.m
//  balloon-burst
//
//  Created by Jamie Ly on 12/30/11.
//  Copyright (c) 2011 angelforge.org. All rights reserved.
//

#import "MenuLayer.h"
#import "BalloonLayer.h"

@implementation MenuLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init 
{
    if(self = [super initWithColor:ccc4(204,243,255,255)]) {
        CCMenuItemLabel *start = [CCMenuItemLabel itemWithLabel:[self getDefaultLabel: @"Start"] target:self selector:@selector(startGame:)];
        menu_ = [CCMenu menuWithItems:start, nil];
        [self addChild:menu_];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"story" ofType:@"txt"];
        NSString *story = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        CGSize windowSize_ = [[CCDirector sharedDirector] winSize];
        
        CGSize dimensions = [story sizeWithFont:[UIFont fontWithName:@"Helvetica" size:20] constrainedToSize:windowSize_ lineBreakMode:UILineBreakModeWordWrap];
        
        CCLabelTTF *lblStory = [CCLabelTTF labelWithString:story dimensions:dimensions alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeWordWrap fontName:@"Helvetica" fontSize:20];
        
        lblStory.position = ccp(windowSize_.width / 2, 100);
        lblStory.color = ccc3(0, 0, 0);
        [self addChild:lblStory];
    }
    
    return self;
}

-(void) startGame: (CCMenuItem*) menuItem 
{
    [[CCDirector sharedDirector] replaceScene: [BalloonLayer scene]];
}

-(CCLabelTTF*) getDefaultLabel:(NSString*) text 
{
    CCLabelTTF* lbl = [CCLabelTTF labelWithString:text fontName:@"Helvetica" fontSize:72];
    lbl.color = ccc3(0, 0, 0);
    return lbl;
}

@end
