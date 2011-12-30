//
//  Game.h
//  balloon-burst
//
//  Created by Jamie Ly on 12/30/11.
//  Copyright (c) 2011 angelforge.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject
{
    int score_;
    float timer_;
    int treasuresCollected_;
}

@property (readwrite, assign) int score;
@property (readwrite, assign) float timer;
@property (readwrite, assign) int treasuresCollected;

-(id) init;

@end
