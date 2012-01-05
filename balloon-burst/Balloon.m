//
//  Balloon.m
//  balloon-burst
//
//  Created by Jamie Ly on 12/30/11.
//  Copyright (c) 2011 angelforge.org. All rights reserved.
//

#import "Balloon.h"

@implementation Balloon

@synthesize sprite = sprite_, label = label_, speed = speed_, string = string_;

-(id) init:(float) scale sprite: (CCSprite*) sprite
{
    return [self initWithString: scale sprite: sprite string:@""];
}

-(id) initWithString:(float) scale sprite: (CCSprite*) sprite string: (NSString*) string
{
    speed_ = 30.0f; // 30 px a second
    scale_ = 1.5f;
    sprite.scale = scale_;
    
    sprite_ = sprite;
    string_ = string;
    
    [self setScale:scale];
    
    int fontSize = 90;
    if(scale < 0.04) {
        fontSize = 20;
    }
    else if(scale < 0.08) {
        fontSize = 30;
    }
    else if(scale < 0.1) {
        fontSize = 40;
    }
    else if(scale < 0.12) {
        fontSize = 60;
    }
    else if(scale < 0.15) {
        fontSize = 80;
    }

    [self initLabel:fontSize];
    
    return self;
}

-(void) initLabel:(int) fontSize
{
    label_ = [CCLabelTTF labelWithString:string_ fontName:@"Helvetica" fontSize:fontSize];
    label_.position = sprite_.position;
}

-(void) setPosition:(CGPoint) position
{
    label_.position = position;
    sprite_.position = position;
}

-(void) raise:(float)delta
{
    CGPoint pos = [self.sprite position];
    pos.y += delta;
    
    self.sprite.position = pos;
    label_.position = pos;
}

-(void) setString:(NSString *)string
{
    [self.label setString:string];
}

-(void) setScale:(float)scale
{
    scale_ = scale;
    sprite_.scale = scale;
}
@end
