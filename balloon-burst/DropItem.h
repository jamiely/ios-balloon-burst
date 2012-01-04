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
    // for now, we'll also store sprites here, but it should be factored out later.
    CCSprite *sprite_;
    NSString *string_; 
}

@property (readwrite, assign) int scoreValue;
@property (readwrite, retain) CCSprite* sprite;
@property (readwrite, retain) NSString* string;

-(id) initWithString: (NSString*) string scoreValue: (int) scoreVal;

@end
