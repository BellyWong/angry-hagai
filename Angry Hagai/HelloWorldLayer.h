//
//  HelloWorldLayer.h
//  Angry Hagai
//
//  Created by Adam on 6/25/13.
//  Copyright Adam 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "ContactManager.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

enum GameState {
    FINISH_STATE_NOT_ENDED = 0x0,
    FINISH_STATE_WIN = 0x1,
    FINISH_STATE_LOST = 0x2,
    FINISH_STATE_MAYBE_LOST = 0x3,
};

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer// <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
	CCTexture2D *spriteTexture_;	// weak ref
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref
    b2Fixture *armFixture;
    b2Body *armBody;
    b2RevoluteJoint *armJoint;
    b2MouseJoint *mouseJoint;
    b2Body* groundBody;
    NSMutableArray* bullets;
    int currentBullet;
    b2Body *bulletBody;
    b2WeldJoint *bulletJoint;
    bool releasingArm;
    bool goingBack;
    NSMutableSet *targets;
    NSMutableSet *enemies;
    MyContactListener* contactManager;
    GameState gameFinished;
    uint32 finishTimer;
    CCSprite* _restartButton;

}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
