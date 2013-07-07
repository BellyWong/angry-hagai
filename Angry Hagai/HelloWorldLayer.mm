//
//  HelloWorldLayer.mm
//  Angry Hagai
//
//  Created by Adam on 6/25/13.
//  Copyright Adam 2013. All rights reserved.
//

// Import the interfaces
#import "HelloWorldLayer.h"

// Not included in "cocos2d.h"
#import "CCPhysicsSprite.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "SimpleAudioEngine.h"


enum {
	kTagParentNode = 1,
};


#define FLOOR_HEIGHT    62.0f
#define CC_POINT_TO_VECTOR(p)       b2Vec2(p.x/PTM_RATIO, p.y/PTM_RATIO)

#define NUMBER_OF_BULLETS   3

#pragma mark - HelloWorldLayer

@interface HelloWorldLayer()
-(void) initPhysics;
@end

@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void)createTarget:(NSString*)imageName
          atPosition:(CGPoint)position
            rotation:(CGFloat)rotation
            isCircle:(BOOL)isCircle
            isStatic:(BOOL)isStatic
             isEnemy:(BOOL)isEnemy
{
    CCPhysicsSprite *sprite = [CCPhysicsSprite spriteWithFile:imageName];
    
    
    b2BodyDef bodyDef;
    bodyDef.type = isStatic?b2_staticBody:b2_dynamicBody;
    bodyDef.position.Set((position.x+sprite.contentSize.width/2.0f-400.0f/PTM_RATIO)/PTM_RATIO,
                         (position.y+sprite.contentSize.height/2.0f)/PTM_RATIO);
    bodyDef.angle = CC_DEGREES_TO_RADIANS(rotation);
    b2Body *body = world->CreateBody(&bodyDef);
    body->SetUserData((__bridge void*)sprite);
    b2FixtureDef boxDef;
    if (isCircle)
    {
        b2CircleShape circle;
        circle.m_radius = sprite.contentSize.width/2.0f/PTM_RATIO;
        boxDef.shape = &circle;
    }
    else
    {
        b2PolygonShape box;
        box.SetAsBox(sprite.contentSize.width/2.0f/PTM_RATIO, sprite.contentSize.height/2.0f/PTM_RATIO);
        boxDef.shape = &box;
    }
    
    boxDef.userData = (void*)2;
    
    if (isEnemy)
    {
        boxDef.userData = (void*)1;
        [enemies addObject:[NSValue valueWithPointer:body]];
    }
    
    boxDef.density = 0.5f;
    b2Fixture* fixture = body->CreateFixture(&boxDef);
    b2Filter filter = fixture->GetFilterData();
    filter.groupIndex = 1;
    fixture->SetFilterData(filter);
    [sprite setPTMRatio:PTM_RATIO];
    [sprite setB2Body:body];
    [self addChild:sprite z:3];
    [targets addObject:[NSValue valueWithPointer:body]];
}

- (void)createTargets
{
    targets = [[NSMutableSet alloc] init];
    enemies = [[NSMutableSet alloc] init];
    
    [self createTarget:@"head_dog.png" atPosition:CGPointMake(600.0f, FLOOR_HEIGHT+108.0f) rotation:0.0f isCircle:YES isStatic:YES isEnemy:YES];
    
    // First block
    [self createTarget:@"brick_2.png" atPosition:CGPointMake(675.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"brick_1.png" atPosition:CGPointMake(741.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"brick_1.png" atPosition:CGPointMake(741.0, FLOOR_HEIGHT+23.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"brick_3.png" atPosition:CGPointMake(672.0, FLOOR_HEIGHT+46.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"brick_1.png" atPosition:CGPointMake(707.0, FLOOR_HEIGHT+58.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"brick_1.png" atPosition:CGPointMake(707.0, FLOOR_HEIGHT+81.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    
    [self createTarget:@"head_dog.png" atPosition:CGPointMake(702.0, FLOOR_HEIGHT) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES];
    
    [self createTarget:@"head_cat.png" atPosition:CGPointMake(680.0, FLOOR_HEIGHT+58.0f) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES];
    [self createTarget:@"head_dog.png" atPosition:CGPointMake(740.0, FLOOR_HEIGHT+58.0f) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES];
    
    // 2 bricks at the right of the first block
    [self createTarget:@"brick_2.png" atPosition:CGPointMake(770.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"brick_2.png" atPosition:CGPointMake(770.0, FLOOR_HEIGHT+46.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    
    // The dog between the blocks
    [self createTarget:@"head_dog.png" atPosition:CGPointMake(830.0, FLOOR_HEIGHT) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES];
    
    // Second block
    [self createTarget:@"brick_platform.png" atPosition:CGPointMake(839.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:YES isEnemy:NO];
    [self createTarget:@"brick_2.png"  atPosition:CGPointMake(854.0, FLOOR_HEIGHT+28.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"brick_2.png"  atPosition:CGPointMake(854.0, FLOOR_HEIGHT+28.0f+46.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"head_cat.png" atPosition:CGPointMake(881.0, FLOOR_HEIGHT+28.0f) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES];
    [self createTarget:@"brick_2.png"  atPosition:CGPointMake(909.0, FLOOR_HEIGHT+28.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    
    [self createTarget:@"brick_1.png"  atPosition:CGPointMake(909.0, FLOOR_HEIGHT+28.0f+46.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"brick_1.png"  atPosition:CGPointMake(909.0, FLOOR_HEIGHT+28.0f+46.0f+23.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    
    [self createTarget:@"brick_2.png"  atPosition:CGPointMake(882.0, FLOOR_HEIGHT+118.0f) rotation:90.0f isCircle:NO isStatic:NO isEnemy:NO];
    
}


-(id) init
{
	if( (self=[super init])) {
		
		// enable events
		
		self.touchEnabled = YES;
		//self.accelerometerEnabled = YES;
		//CGSize s = [CCDirector sharedDirector].winSize;
		releasingArm = false;
        goingBack = false;
        gameFinished = FINISH_STATE_NOT_ENDED;
        
		// init physics
        
		[self initPhysics];
        
		[self scheduleUpdate];
        
        _restartButton = [CCSprite spriteWithFile:@"acorn.png"]; // CCSprite is a descendant of CCNode
        [self addChild: _restartButton];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        _restartButton.position = CGPointMake(_restartButton.contentSize.width/2, winSize.height-_restartButton.contentSize.height/2);
        
        // we now have a node with a sprite in in. On this sprite (well, maybe
        // it you should attack the node to a scene) you can call convertToWorldSpace:
        //CGPoint worldCoord = [mySprite convertToWorldSpace: CGPointMake(0.0f, 20.f)];
        
        //[mySprite setPosition:worldCoord];
        
        
	}
	return self;
}

-(bool) isInWorld:(b2Body*) body
{
    for(b2Body* b = world->GetBodyList(); b; b = b->GetNext())
        if(b == body)
            return true;
    return false;
}

// Pos comes from the ccTouchesEnded function. I've already converted it to Cocos2D coordinates.
-(void) launchBomb:(CGPoint)pos
{
    BOOL doSuction = YES; // Very cool looking implosion effect instead of explosion.
    
    //In Box2D the bodies are a linked list, so keep getting the next one until it doesn't exist.
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        //Box2D uses meters, there's 32 pixels in one meter. PTM_RATIO is defined somewhere in the class.
        b2Vec2 b2TouchPosition = b2Vec2(pos.x/PTM_RATIO, pos.y/PTM_RATIO);
        b2Vec2 b2BodyPosition = b2Vec2(b->GetPosition().x, b->GetPosition().y);
        
        //Don't forget any measurements always need to take PTM_RATIO into account
        float maxDistance = 9.0f; // In your head don't forget this number is low because we're multiplying it by 32 pixels;
        int maxForce = 80;
        CGFloat distance; // Why do i want to use CGFloat vs float - I'm not sure, but this mixing seems to work fine for this little test.
        CGFloat strength;
        float force;
        CGFloat angle;
        
        if(doSuction) // To go towards the press, all we really change is the atanf function, and swap which goes first to reverse the angle
        {
            // Get the distance, and cap it
            distance = b2Distance(b2BodyPosition, b2TouchPosition);
            if(distance > maxDistance) distance = maxDistance - 0.01;
            // Get the strength
            //strength = distance / maxDistance; // Uncomment and reverse these two. and ones further away will get more force instead of less
            strength = (maxDistance - distance) / maxDistance; // This makes it so that the closer something is - the stronger, instead of further
            force  = strength * maxForce;
            
            // Get the angle
            angle = atan2f(b2TouchPosition.y - b2BodyPosition.y, b2TouchPosition.x - b2BodyPosition.x);
            //NSLog(@" distance:%0.2f,force:%0.2f", distance, force);
            // Apply an impulse to the body, using the angle
            b->ApplyLinearImpulse(b2Vec2(cosf(angle) * force, sinf(angle) * force), b->GetPosition());
        }
        else
        {
            distance = b2Distance(b2BodyPosition, b2TouchPosition);
            if(distance > maxDistance) distance = maxDistance - 0.01;
            
            // Normally if distance is max distance, it'll have the most strength, this makes it so the opposite is true - closer = stronger
            strength = (maxDistance - distance) / maxDistance; // This makes it so that the closer something is - the stronger, instead of further
            force = strength * maxForce;
            angle = -atan2f(b2BodyPosition.y - b2TouchPosition.y, b2BodyPosition.x - b2TouchPosition.x);
            //NSLog(@" distance:%0.2f,force:%0.2f,angle:%0.2f", distance, force, angle);
            // Apply an impulse to the body, using the angle
            b->ApplyLinearImpulse(b2Vec2(cosf(angle) * force, sinf(angle) * force), b->GetPosition());
        }
    }
}


-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	
}

- (void)createBullets:(int)count
{
    currentBullet = 0;
    CGFloat pos = 62.0f;
    
    if (count > 0)
    {
        // delta is the spacing between corns
        // 62 is the position o the screen where we want the corns to start appearing
        // 165 is the position on the screen where we want the corns to stop appearing
        // 30 is the size of the corn
        CGFloat delta = (count > 1)?((165.0f - 62.0f - 30.0f) / (count - 1)):0.0f;
        
        bullets = [[NSMutableArray alloc] initWithCapacity:count];
        for (int i=0; i<count; i++, pos+=delta)
        {
            // Create the bullet
            //
            CCPhysicsSprite *sprite = [CCPhysicsSprite spriteWithFile:@"hagai.png"];
            
            b2BodyDef bulletBodyDef;
            bulletBodyDef.type = b2_dynamicBody;
            bulletBodyDef.bullet = true;
            
            bulletBodyDef.position.Set(pos/PTM_RATIO,(FLOOR_HEIGHT+15.0f)/PTM_RATIO);
            b2Body *bullet = world->CreateBody(&bulletBodyDef);
            bullet->SetUserData((__bridge void*)sprite);
            bullet->SetActive(false);
            
            b2CircleShape circle;
            circle.m_radius = 15.0/PTM_RATIO;
            
            b2FixtureDef ballShapeDef;
            ballShapeDef.shape = &circle;
            ballShapeDef.density = 0.8f;
            ballShapeDef.restitution = 0.2f;
            ballShapeDef.friction = 0.99f;
            bullet->CreateFixture(&ballShapeDef);
            
            [bullets addObject:[NSValue valueWithPointer:bullet]];
            [sprite setPTMRatio:PTM_RATIO];
            [sprite setB2Body:bullet];
            [self addChild:sprite z:3];
        }
    }
}

-(BOOL) attachBullet
{
    if(currentBullet < [bullets count]) {
        
        bulletBody = (b2Body*)[[bullets objectAtIndex:currentBullet++] pointerValue];
        
        bulletBody->SetTransform(b2Vec2(220.0f/PTM_RATIO, (155.0f+FLOOR_HEIGHT)/PTM_RATIO), CC_DEGREES_TO_RADIANS(9.0f));
        bulletBody->SetActive(true);
        
        b2WeldJointDef jointDef;
        jointDef.Initialize(bulletBody, armBody, b2Vec2(220.0f/PTM_RATIO,(155.0f+FLOOR_HEIGHT)/PTM_RATIO));
        jointDef.collideConnected = false;
        bulletJoint = (b2WeldJoint*)world->CreateJoint(&jointDef);
        return YES;
    }
    NSLog(@"attachBullet false");
    return NO;
}

-(void) recreateTargets
{
    for(b2Body* b = world->GetBodyList(); b; b = b->GetNext())
        if(b && b->GetWorld() && ([enemies containsObject:[NSValue valueWithPointer:b]] || [targets containsObject:[NSValue valueWithPointer:b]] ))
            world->DestroyBody(b);
    
    NSLog(@"recreating...");
    
    [self createTargets];
}

-(void) recreateGame
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene] ]];
    /*
     [self recreateTargets];
     [self createBullets:1];
     [self attachBullet];*/
}

-(void) resetGame
{
    [self createBullets:NUMBER_OF_BULLETS];
    [self attachBullet];
    world->SetContactListener(contactManager);
}

-(void) initPhysics
{
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
	
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	//world->SetDebugDraw(m_debugDraw);
	
    CCSprite *sprite = [CCSprite spriteWithFile:@"bg.png"];
    sprite.anchorPoint = CGPointZero;
    [self addChild:sprite z:-1];
    
    sprite = [CCSprite spriteWithFile:@"catapult_base_2.png"];
    sprite.anchorPoint = CGPointZero;
    sprite.position = CGPointMake(181.0f, FLOOR_HEIGHT);
    [self addChild:sprite z:0];
    
    sprite = [CCSprite spriteWithFile:@"squirrel_1.png"];
    sprite.anchorPoint = CGPointZero;
    sprite.position = CGPointMake(11.0f, FLOOR_HEIGHT);
    [self addChild:sprite z:0];
    
    sprite = [CCSprite spriteWithFile:@"catapult_base_1.png"];
    sprite.anchorPoint = CGPointZero;
    sprite.position = CGPointMake(181.0f, FLOOR_HEIGHT);
    [self addChild:sprite z:9];
    
    // Create the catapult's arm
    //
    
    
    b2BodyDef armBodyDef;
    armBodyDef.type = b2_dynamicBody;
    armBodyDef.linearDamping = 1;
    armBodyDef.angularDamping = 1;
    armBodyDef.position.Set(230.0f/PTM_RATIO,(FLOOR_HEIGHT+91.0f)/PTM_RATIO);
    //    armBodyDef.userData = arm;
    armBody = world->CreateBody(&armBodyDef);
    
    
    
    b2PolygonShape armBox;
    b2FixtureDef armBoxDef;
    armBoxDef.shape = &armBox;
    armBoxDef.density = 0.3F;
    armBox.SetAsBox(11.0f/PTM_RATIO, 91.0f/PTM_RATIO);
    armFixture = armBody->CreateFixture(&armBoxDef);
    
    CCPhysicsSprite *arm = [CCPhysicsSprite spriteWithFile:@"catapult_arm.png"];
    [arm setPTMRatio:PTM_RATIO];
    [arm setB2Body:armBody];
    [arm setPosition:ccp(223.0f, FLOOR_HEIGHT+91.0f)];
    [self addChild:arm z:3];
    
    sprite = [CCSprite spriteWithFile:@"squirrel_2.png"];
    sprite.anchorPoint = CGPointZero;
    sprite.position = CGPointMake(240.0f, FLOOR_HEIGHT);
    [self addChild:sprite z:9];
    
    sprite = [CCSprite spriteWithFile:@"fg.png"];
    sprite.anchorPoint = CGPointZero;
    [self addChild:sprite z:10];
    
    
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);
	
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;
	
	// bottom
	
	groundBox.Set(b2Vec2(0,FLOOR_HEIGHT/PTM_RATIO), b2Vec2(2*s.width/PTM_RATIO,FLOOR_HEIGHT/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	//groundBox.Set(b2Vec2(s.width*2.0f/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width*2.0f/PTM_RATIO,0));
	//groundBody->CreateFixture(&groundBox,0);
    
    
    b2RevoluteJointDef armJointDef;
    armJointDef.Initialize(groundBody, armBody, b2Vec2(233.0f/PTM_RATIO, FLOOR_HEIGHT/PTM_RATIO));
    armJointDef.enableMotor = true;
    armJointDef.enableLimit = true;
    armJointDef.motorSpeed  = -120;
    armJointDef.lowerAngle  = CC_DEGREES_TO_RADIANS(9);
    armJointDef.upperAngle  = CC_DEGREES_TO_RADIANS(75);
    armJointDef.maxMotorTorque = 480;
    
    [self createTargets];
    
    contactManager = new MyContactListener();
    
    armJoint = (b2RevoluteJoint*)world->CreateJoint(&armJointDef);
    
    [self performSelector:@selector(resetGame) withObject:nil afterDelay:0.5f];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL: location];
    
    if(CGRectIntersectsRect(CGRectMake(_restartButton.position.x-_restartButton.contentSize.width/2, _restartButton.position.y-_restartButton.contentSize.height/2, _restartButton.boundingBox.size.width, _restartButton.boundingBox.size.height), CGRectMake(location.x + fabs(self.position.x), location.y, 1.0f, 1.0f))) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene] ]];
        return;
    }
    
    location.x += fabs(self.position.x);
    
    b2Vec2 locationWorld = CC_POINT_TO_VECTOR(location);
    
    NSLog(@"touch=%f,body=%f", location.x/PTM_RATIO, armBody->GetWorldCenter().x);
    if(locationWorld.x < armBody->GetWorldCenter().x + ((__bridge CCSprite*)bulletBody->GetUserData()).contentSize.width/PTM_RATIO) {
        locationWorld.x -= ((__bridge CCSprite*)bulletBody->GetUserData()).contentSize.width/(PTM_RATIO*8.0f)+fabs(self.position.x/PTM_RATIO);
        NSLog(@"pulling");
        b2MouseJointDef jointDef;
        jointDef.bodyA = groundBody;
        jointDef.bodyB = armBody;
        jointDef.target = locationWorld;
        jointDef.maxForce = 2000;
        
        mouseJoint = (b2MouseJoint*)world->CreateJoint(&jointDef);
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    /*
     // Examine allTouches instead of just touches.  Touches tracks only the touch that is currently moving...
     //   But stationary touches still trigger a multi-touch gesture.
     NSArray* allTouches = [[event allTouches] allObjects];
     
     if ([allTouches count] == 2) {
     // Get two of the touches to handle the zoom
     UITouch* touchOne = [allTouches objectAtIndex:0];
     UITouch* touchTwo = [allTouches objectAtIndex:1];
     
     // Get the touches and previous touches.
     CGPoint touchLocationOne = [touchOne locationInView: [touchOne view]];
     CGPoint touchLocationTwo = [touchTwo locationInView: [touchTwo view]];
     
     CGPoint previousLocationOne = [touchOne previousLocationInView: [touchOne view]];
     CGPoint previousLocationTwo = [touchTwo previousLocationInView: [touchTwo view]];
     
     // Get the distance for the current and previous touches.
     CGFloat currentDistance = sqrt(
     pow(touchLocationOne.x - touchLocationTwo.x, 2.0f) +
     pow(touchLocationOne.y - touchLocationTwo.y, 2.0f));
     
     CGFloat previousDistance = sqrt(
     pow(previousLocationOne.x - previousLocationTwo.x, 2.0f) +
     pow(previousLocationOne.y - previousLocationTwo.y, 2.0f));
     
     // Get the delta of the distances.
     CGFloat distanceDelta = currentDistance - previousDistance;
     
     // Next, position the camera to the middle of the pinch.
     // Get the middle position of the pinch.
     CGPoint pinchCenter = ccpMidpoint(touchLocationOne, touchLocationTwo);
     
     // Then, convert the screen position to node space... use your game layer to do this.
     pinchCenter = [self convertToNodeSpace:pinchCenter];
     
     // Finally, call the scale method to scale by the distanceDelta, pass in the pinch center as well.
     // Also, multiply the delta by PINCH_ZOOM_MULTIPLIER to slow down the scale speed.
     // A PINCH_ZOOM_MULTIPLIER of 0.005f works for me, but experiment to find one that you like.
     //[self scale:[self scale] - (distanceDelta * 0.01f)];
     }
     */
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    if(goingBack)
        goingBack = false;
    if(location.x/PTM_RATIO > armBody->GetWorldCenter().x+((__bridge CCSprite*)bulletBody->GetUserData()).contentSize.width/PTM_RATIO && !mouseJoint)
    {
        CGPoint oldPosition1 = [[CCDirector sharedDirector] convertToGL:[myTouch previousLocationInView:[myTouch view]]];
        CGPoint newLocation = ccp(MIN(0,self.position.x - (oldPosition1.x-location.x)), 0);
        newLocation.x = MAX(newLocation.x, -winSize.width);
        self.position = newLocation;
//        location.x -= ((__bridge CCSprite*)bulletBody->GetUserData()).contentSize.width/PTM_RATIO;
    }
    if (mouseJoint == nil) return;
    
    mouseJoint->SetTarget(CC_POINT_TO_VECTOR(location));
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    /*
     
     UITouch *myTouch = [touches anyObject];
     CGPoint location = [myTouch locationInView:[myTouch view]];
     location = [[CCDirector sharedDirector] convertToGL:location];
     [self launchBomb:location];
     */
    NSLog(@"arm's angle=%f", CC_RADIANS_TO_DEGREES(armBody->GetAngle()));
    if(CC_RADIANS_TO_DEGREES(armBody->GetAngle()) >= 15)
    {
        releasingArm = true;
        NSLog(@"releasing arm");
    }
    
    if (mouseJoint != nil)
    {
        world->DestroyJoint(mouseJoint);
        mouseJoint = nil;
    }
}


-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();
	
	kmGLPopMatrix();
}

-(void) bulletStopped
{
    NSLog(@"creating a goback");
    goingBack = true;
}

-(void) lostGame
{
    NSLog(@"lost...");
    gameFinished = FINISH_STATE_NOT_ENDED;
    [self performSelector:@selector(recreateGame) withObject:nil afterDelay:3.5f];
    self.touchEnabled = false;
    [[SimpleAudioEngine sharedEngine] playEffect:@"lost.caf"];
    CCSprite* asaf = [CCSprite spriteWithFile:@"asafcohen.png"];
    CCDelayTime* delay = [CCDelayTime actionWithDuration:3.0f];
    self.position = CGPointMake(0.0f, 0.0f);
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    [asaf setPosition:CGPointMake(winSize.width/2, winSize.height/2)];
    [self addChild:asaf z:100];
    CCCallBlockN* cleanup = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    CCSequence* seq = [CCSequence actions:delay, cleanup, nil];
    [asaf runAction:seq];
}

-(void) wonGame
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"win.caf"];
    CCLabelTTF *lab = [CCLabelTTF labelWithString:@"Good Joib! Boingy loves you." fontName:@"Marker Felt" fontSize:32];
    CCLabelTTF *enough = [CCLabelTTF labelWithString:@"If you got here then it means that my game works!" fontName:@"Marker Felt" fontSize:20];
    enough.rotation = 15.0f;
    [lab setColor:ccc3(0,0,0)];
    //[enough setColor:ccc3(0, 255, 77)];
    [enough setBlendFunc:(ccBlendFunc){GL_ONE_MINUS_DST_COLOR, GL_SRC_ALPHA}];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    [lab setPosition:CGPointMake(winSize.width/2, winSize.height/2)];
    [enough setPosition:CGPointMake(winSize.width/2, winSize.height/2 - lab.contentSize.height - 30.0f)];
    self.position = CGPointMake(.0f, .0f);
    [self addChild:lab z:100];
    [self addChild:enough z:100];
    
}

-(BOOL) noMovementInWorld
{
    for(b2Body* b = world->GetBodyList(); b; b = b->GetNext()) {
        if(b && b->GetWorld() && b->GetPosition().x < 35.0f &&(fabs(b->GetLinearVelocity().x) > .1f || fabs(b->GetLinearVelocity().y) > .1f))
            return NO;
    }
    return YES;
}

-(void) update: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
    
    if(releasingArm && bulletJoint)
    {
        if (armJoint->GetJointAngle() <= CC_DEGREES_TO_RADIANS(10)) {
            NSLog(@"released");
            world->DestroyJoint(bulletJoint);
            bulletJoint = nil;
            releasingArm = false;
            [[SimpleAudioEngine sharedEngine] playEffect:@"whee.caf"];
        }
    }
        
    if(bulletBody && bulletBody->IsAwake())
    {
        if(bulletBody->GetPosition().y - (FLOOR_HEIGHT/PTM_RATIO) < 2) {
            signed char direction = bulletBody->GetAngularVelocity() > 0 ? -1 : 1;
            b2Vec2 friction = b2Vec2(bulletBody->GetMass()*(world->GetGravity().y)* direction*dt*.15f, 0.0f);
            bulletBody->ApplyLinearImpulse(friction, bulletBody->GetWorldCenter());
        }
        b2Vec2 position = bulletBody->GetPosition();
        CGPoint myPosition = self.position;
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        // Move the camera.
        if (position.x > screenSize.width / (2.0f * PTM_RATIO))
            //if(!bulletJoint)
        {
#ifdef ANDROID
            myPosition.x = -MIN(screenSize.width*0.75f, position.x * PTM_RATIO - screenSize.width / 2.0f);
#else
            myPosition.x = -MIN(screenSize.width, position.x * PTM_RATIO - screenSize.width / 2.0f);
#endif
            self.position = myPosition;
        }
        
    }/*
      if(bulletBody)
      NSLog(@"bulletBodyx=%f,winSize=%f,bulletJoint=%d", bulletBody->GetPosition().x, ([[CCDirector sharedDirector] winSize].width*2)/PTM_RATIO, bulletJoint != nil);*/
    
    if(contactManager->killedSet.size() > 0)
        for(std::set<b2Body*>::iterator i = contactManager->killedSet.begin(); i != contactManager->killedSet.end(); ++i)
        {
            b2Body* enemy = *i;
            if(enemy) {
                CCParticleSun* explosion = [[CCParticleSun alloc] initWithTotalParticles:500];
                explosion.autoRemoveOnFinish = YES;
                explosion.startSize = 10.0f;
                explosion.speed = 70.0f;
                explosion.anchorPoint = ccp(0.5f,0.5f);
                explosion.position = ccp(enemy->GetPosition().x*PTM_RATIO, enemy->GetPosition().y*PTM_RATIO);
                explosion.duration = 1.0f;
                [self addChild:explosion z:11];
                [enemies removeObject:[NSValue valueWithPointer:enemy]];
                if(CCPhysicsSprite* enemyVisual = (__bridge CCPhysicsSprite*)enemy->GetUserData())
                    [self removeChild:enemyVisual];
                enemy->SetActive(false);
                world->DestroyBody(enemy);
            }
        }
    if(bulletBody && !bulletJoint && (abs(bulletBody->GetLinearVelocity().x) < .1f || bulletBody->GetPosition().x > 35.0f))
    {
        if(bulletBody->GetPosition().x < 35.0f && bulletBody->GetWorld()) {
            CCParticleSmoke* explosion = [[CCParticleSmoke alloc] initWithTotalParticles:200];
            explosion.autoRemoveOnFinish = YES;
            explosion.startSize = 10.0f;
            explosion.speed = 70.0f;
            explosion.anchorPoint = ccp(0.5f,0.5f);
            explosion.position = ccp(bulletBody->GetPosition().x*PTM_RATIO, bulletBody->GetPosition().y*PTM_RATIO);
            explosion.duration = 1.0f;
            [self addChild:explosion z:11];
        }
        bulletBody->SetAwake(false);
        
        [self performSelector:@selector(removeChild:) withObject:(__bridge id)bulletBody->GetUserData() afterDelay:3.0f];
        if(bulletBody->GetWorld())
            world->DestroyBody(bulletBody);
        bulletBody = nil;
        NSLog(@"bulletStopped initiating with delay=0.5f");
        NSLog(@"enemies count=%d", [enemies count]);
        if([enemies count] == 0)
            gameFinished = FINISH_STATE_WIN;
        else if([enemies count] > 0 && ![self attachBullet]) {
            gameFinished = FINISH_STATE_MAYBE_LOST;
        }
        else
            [self scheduleOnce:@selector(bulletStopped) delay:2.5f];
    }
    
    contactManager->killedSet.clear();
    
    if(gameFinished != FINISH_STATE_NOT_ENDED && [self noMovementInWorld]) {
        NSLog(@"game ended...");
        switch (gameFinished) {
            case FINISH_STATE_WIN:
            {
                [self scheduleOnce:@selector(wonGame) delay:2.5f];
                gameFinished = FINISH_STATE_NOT_ENDED;
            }break;
            case FINISH_STATE_MAYBE_LOST:
            {
                if([enemies count] > 0 && [self noMovementInWorld] && currentBullet >= NUMBER_OF_BULLETS)
                {
                    [self scheduleOnce:@selector(lostGame) delay:2.5f];
                    gameFinished = FINISH_STATE_NOT_ENDED;
                    goingBack = false;
                }
                else if([enemies count] == 0)
                    gameFinished = FINISH_STATE_WIN;
                
            }break;
            default:
            {
                gameFinished = FINISH_STATE_NOT_ENDED;
            }
                break;
        }
    }
    
    if(goingBack)
    {
        self.position = ccp(MIN(self.position.x+5.0f, 0), self.position.y);
        if(self.position.x == 0)
            goingBack = false;
    }
    
    [_restartButton setPosition:ccp(_restartButton.contentSize.width/2 + fabs(self.position.x), _restartButton.position.y)];

	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
}

#pragma mark GameKit delegate
/*
 -(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
 {
 AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
 [[app navController] dismissModalViewControllerAnimated:YES];
 }
 
 -(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
 {
 AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
 [[app navController] dismissModalViewControllerAnimated:YES];
 }
 */
@end
