//
//  ContactManager.cpp
//  Angry Hagai
//
//  Created by Adam on 6/27/13.
//  Copyright (c) 2013 Adam. All rights reserved.
//

#include "ContactManager.h"
#import "Box2D.h"
#include <math.h>
MyContactListener::~MyContactListener()
{
    
}

void MyContactListener::BeginContact(b2Contact* contact)
{
}

void MyContactListener::EndContact(b2Contact* contact)
{
}

void MyContactListener::PreSolve(b2Contact* contact,
                                 const b2Manifold* oldManifold)
{
}


void MyContactListener::PostSolve(b2Contact *c, const b2ContactImpulse *impulse)
{
    b2Body* b1 = c->GetFixtureA()->GetBody();
    b2Body* b2 = c->GetFixtureB()->GetBody();
    
    if(c->GetFixtureA() && c->GetFixtureB())
        if((int)c->GetFixtureB()->GetUserData() == 1 || (int)c->GetFixtureA()->GetUserData() == 1) {
            float32 maxImpulse = 0.0f;
            if(b1->IsBullet() ^ b2->IsBullet())
                printf("we have a bullet collided with an enemy and destroying it!!");
            
            int pointCount = c->GetManifold()->pointCount;
            for(int i = 0; i < pointCount; i++)
                if(maxImpulse < impulse->normalImpulses[i])
                    maxImpulse = impulse->normalImpulses[i];

            if(maxImpulse > .7f) {
                printf("maxImpulse is %f\r", maxImpulse);
                b2Body* enemy = b2;
                if(c->GetFixtureB()&&c->GetFixtureB()->GetUserData() == NULL)
                    enemy = b1;
                if(enemy && enemy->GetWorld()) {
                    /*
                    enemy->SetActive(false);
                    enemy->GetWorld()->DestroyBody(enemy);
                    {
                        CCParticleSun* explosion = [[CCParticleSun alloc] initWithTotalParticles:500];
                        explosion.autoRemoveOnFinish = YES;
                        explosion.startSize = 10.0f;
                        explosion.speed = 70.0f;
                        explosion.anchorPoint = ccp(0.5f,0.5f);
                        explosion.position = ccp(enemy->GetPosition().x*PTM_RATIO, enemy->GetPosition().y*PTM_RATIO);
                        explosion.duration = 1.0f;
                        [self addChild:explosion z:11];
                        
                    }*/
                    killedSet.insert(enemy);
                }
                if(c->GetFixtureA()&&c->GetFixtureA()->GetUserData() != NULL && b1) {
                    if((int)c->GetFixtureA()->GetUserData() == 1 && maxImpulse > .7f)
                    /*
                    b1->SetActive(false);
                    world->DestroyBody(b1);
                    CCParticleSun* explosion = [[CCParticleSun alloc] initWithTotalParticles:200];
                    explosion.autoRemoveOnFinish = YES;
                    explosion.startSize = 10.0f;
                    explosion.speed = 70.0f;
                    explosion.anchorPoint = ccp(0.5f,0.5f);
                    explosion.position = ccp(b1->GetPosition().x*PTM_RATIO, b1->GetPosition().y*PTM_RATIO);
                    explosion.duration = 1.0f;
                    [self addChild:explosion z:11];*/
                    killedSet.insert(b1);
                }
            }
        }

}


