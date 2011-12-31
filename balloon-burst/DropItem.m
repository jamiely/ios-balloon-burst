//
//  DropItem.m
//  balloon-burst
//
//  Created by Jamie Ly on 12/30/11.
//  Copyright (c) 2011 angelforge.org. All rights reserved.
//

#import "DropItem.h"

@implementation DropItem

@synthesize itemType = itemType_, scoreValue = scoreValue_, sprite = sprite_;

-(id) initWithType:(DropItemType)type scoreValue:(int)scoreVal sprite:(CCSprite *)sprite 
{
    self.itemType = type;
    self.scoreValue = scoreVal;
    self.sprite = sprite;
    
    return self;
}

@end
