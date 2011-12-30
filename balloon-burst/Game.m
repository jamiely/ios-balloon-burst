//
//  Game.m
//  balloon-burst
//
//  Created by Jamie Ly on 12/30/11.
//  Copyright (c) 2011 angelforge.org. All rights reserved.
//

#import "Game.h"

@implementation Game

@synthesize score = score_, timer = timer_, treasuresCollected = treasuresCollected_;

-(id) init
{
    self.treasuresCollected = 0;
    self.score = 0;
    self.timer = 60;
    
    return self;
}

@end
