//
//  IntroLayer.m
//  Angry Hagai
//
//  Created by Adam on 6/25/13.
//  Copyright Adam 2013. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"

#pragma mark - IntroLayer

#define EXPIRATION  @"10/7/2013 10:00"

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

//
-(id) init
{
	if( (self=[super init])) {
		
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"whee.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"lost.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"win.caf"];
		
		CCSprite *background;
        
        [[CCDirector sharedDirector] setDisplayStats:NO];
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"default-load.png"];
            //			background.rotation = 90;
		} else {
			background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
		}
		background.position = ccp(size.width/2, size.height/2);
		
		// add the label as a child to this Layer
		[self addChild: background];
	}
	
	return self;
}

-(void) onEnter
{
	[super onEnter];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    /*
     A License check goes here, it is currently censored (but you can still play the real game if you manage to compile this on your computer).
     If you think you're smart, download the original IPA\APK in this repository and try to play it after EXPIRATION macro :)
     This requires no jailbreak. however, jailbreaking will make it easier.
     */
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene] ]];
}
@end
