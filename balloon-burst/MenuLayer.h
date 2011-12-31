//
//  MenuScene.h
//  balloon-burst
//
//  Created by Jamie Ly on 12/30/11.
//  Copyright (c) 2011 angelforge.org. All rights reserved.
//

#import "cocos2d.h"

@interface MenuLayer : CCLayerColor
{
    CCMenu* menu_;
}
// returns a CCScene that contains the BalloonLayer as the only child
+(CCScene *) scene;
-(CCLabelTTF *) getDefaultLabel:(NSString*) text;

@end
