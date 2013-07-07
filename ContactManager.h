//
//  ContactManager.h
//  Angry Hagai
//
//  Created by Adam on 6/27/13.
//  Copyright (c) 2013 Adam. All rights reserved.
//

#ifndef __Angry_Hagai__ContactManager__
#define __Angry_Hagai__ContactManager__

#include <iostream>
#include "Box2D.h"
#include <set>
class MyContactListener : public b2ContactListener
{
public:
    std::set<b2Body*> killedSet;

    MyContactListener() : b2ContactListener() { }
    ~MyContactListener();
    void BeginContact(b2Contact* contact);
    void EndContact(b2Contact* contact);
    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
    
};



#endif /* defined(__Angry_Hagai__ContactManager__) */
