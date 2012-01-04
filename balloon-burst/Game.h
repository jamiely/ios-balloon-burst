//
//  Game.h
//  balloon-burst
//
//  Created by Jamie Ly on 12/30/11.
//  Copyright (c) 2011 angelforge.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Balloon.h"
#import "DropItem.h"

@interface Game : NSObject
{
    int score_;
    float timer_;
    int treasuresCollected_;
    int treasuresNeeded_;
    int round_;
    float balloonPace_;
    
    NSArray* words_;
    NSMutableDictionary* wordLookup_;
    NSMutableArray* dropItems_;
    NSMutableArray* balloons_;
}

@property (readwrite, assign) int score;
@property (readwrite, assign) float timer;
@property (readwrite, assign) int treasuresCollected;
@property (readwrite, assign) int treasuresNeeded;
@property (readwrite, assign) int round;
@property (readwrite, assign) float balloonPace;

@property (readonly, retain) NSMutableArray* dropItems;
@property (readonly, retain) NSMutableArray* balloons;

-(id) init;

-(void) nextRound;
-(Boolean) isTreasureCollected;
-(Boolean) isRoundComplete;
-(Boolean) isGameOver;
-(Boolean) isTimeUp;
-(Balloon*) newBalloon;
-(DropItem*) newDropItem:(Balloon*) balloon;
-(void) removeDropItem:(id)object;
-(void) removeBalloon:(id)object;

@end
