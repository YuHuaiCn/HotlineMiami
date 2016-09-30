#ifndef __ANIMATION_MANAGER__
#define __ANIMATION_MANAGER__

#include "cocos2d.h"
#include <string.h>

using namespace std;

class AnimationManager
{
public:
	int runAnimation(cocos2d::Node node, string animName, bool loop = false);
protected:

private:
	
};


#endif  // end of __ANIMATION_MANAGER__