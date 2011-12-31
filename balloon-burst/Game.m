//
//  Game.m
//  balloon-burst
//
//  Created by Jamie Ly on 12/30/11.
//  Copyright (c) 2011 angelforge.org. All rights reserved.
//

#import "Game.h"

@implementation Game

@synthesize score = score_, timer = timer_, treasuresCollected = treasuresCollected_,
    treasuresNeeded = treasuresNeeded_, balloons = balloons_, dropItems = dropItems_,
    round = round_, balloonPace = balloonPace_;

int treasuresToAddNextRound;
int timerStart;

-(id) init
{
    timerStart = 15;
    treasuresToAddNextRound = 2;
    
    self.treasuresCollected = 0;
    self.score = 0;
    self.timer = timerStart;
    self.round = 1;
    self.treasuresNeeded = 3;
    self.balloonPace = 2.0f;
    
    balloons_ = [[NSMutableArray alloc] init];
    dropItems_ = [[NSMutableArray alloc] init]; 
    
    return self;
}

-(Boolean) isTreasureCollected
{
    return self.treasuresCollected >= self.treasuresNeeded;
}

-(Boolean) isGameOver
{
    return [self isRoundComplete] && ![self isTreasureCollected];
}

-(Boolean) isRoundComplete
{
    return [self isTimeUp] || [self isTreasureCollected];
}

-(Boolean) isTimeUp
{
    return self.timer <= 0;
}


-(void) nextRound 
{
    timerStart *= 1.5;
    
    // increment round
    self.round ++;
    
    // reset timer
    self.timer = timerStart;
    
    // score is not reset between rounds
    // player needs to collect more treasures
    self.treasuresCollected = 0;
    
    // player must retrieve more treasures each round
    self.treasuresNeeded += treasuresToAddNextRound;
    treasuresToAddNextRound += 5;
    
    self.balloonPace -= 0.1; 
    if(self.balloonPace < 0.5) {
        self.balloonPace = 0.5;
    }
}

- (Balloon *) newBalloon {
    CCSprite* balloonSprite = [CCSprite spriteWithFile: @"balloon.png"];
    int balloonSpeed = arc4random() % 8 + 2;
    
    NSString* letter = [NSString stringWithFormat:@"%c", (unsigned char) arc4random() % 26 + 65];
    Balloon* balloon = [[Balloon alloc] initWithString:balloonSpeed/60.0f sprite:balloonSprite string:letter];
    
    NSLog(@"scale: %f, %@", balloonSpeed/60.0f, letter);
    
    [balloons_ addObject:balloon];
    
    return balloon;
}

-(DropItem*) newDropItem:(DropItemType)type sprite:(CCSprite *)sprite
{
    DropItem* item = [[DropItem alloc] initWithType:type scoreValue:15 sprite:sprite];
    [dropItems_ addObject:item];
    return item;
}

-(void) removeDropItem:(id)object
{
    [dropItems_ removeObject:object];
}

-(void) removeBalloon:(id)object
{
    [balloons_ removeObject:object];
}

@end
