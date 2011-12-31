//
//  Balloon.h
//  balloon-burst
//
//  Created by Jamie Ly on 12/30/11.
//  Copyright (c) 2011 angelforge.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Balloon : NSObject
{
    CCSprite* sprite_;
    CCLabelTTF* label_;
    float speed_;
    float scale_;
}

@property (readwrite, retain) CCSprite* sprite;
@property (readwrite, retain) CCLabelTTF* label;
@property (readwrite, assign) float speed;
@property (readwrite, assign) float scale;

-(id) init:(CCSprite*) sprite;
-(id) initWithString:(CCSprite*) sprite string:(NSString*) string;
-(void) raise:(float) delta;
-(void) setString:(NSString*) string;
-(void) setPosition:(CGPoint) position;

@end
