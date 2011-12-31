//
//  DropItem.h
//  balloon-burst
//
//  Created by Jamie Ly on 12/30/11.
//  Copyright (c) 2011 angelforge.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    kBomb = -1,
    kDiamond = 1,
    kCupcake = 2,
    kKey = 3,
    kTreasure = 4,
    kCoin = 5
} DropItemType;

@interface DropItem : NSObject
{
    int scoreValue_;
    DropItemType itemType_;
    // for now, we'll also store sprites here, but it should be factored out later.
    CCSprite *sprite_;
}

@property (readwrite, assign) int scoreValue;
@property (readwrite, assign) DropItemType itemType;
@property (readwrite, retain) CCSprite* sprite;

-(id) initWithType: (DropItemType) type scoreValue: (int) scoreVal sprite: (CCSprite*) sprite; 

@end
