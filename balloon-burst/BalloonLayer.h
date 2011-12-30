//
//  BalloonLayer.h
//  balloon-burst
//
//  Created by Jamie Ly on 12/27/11.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface BalloonLayer : CCLayerColor
{
}

// returns a CCScene that contains the BalloonLayer as the only child
+(CCScene *) scene;
-(void) setUpMenus;
-(CCSprite *) newBalloon;
-(void) cleanUpSprite: (CCSprite*) balloon;
-(void) popBalloon: (CCSprite*) balloon;
-(void) setUpClouds;
@end
