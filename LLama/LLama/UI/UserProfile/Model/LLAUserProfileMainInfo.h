//
//  LLAUserProfileMainInfo.h
//  LLama
//
//  Created by Live on 16/1/22.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle.h"

#import "LLAUser.h"
#import "LLAHallVideoItemInfo.h"

typedef NS_ENUM(NSInteger , UserProfileHeadVideoType){
    
    UserProfileHeadVideoType_Director = 0,
    UserProfileHeadVideoType_Actor = 1,
    
};

@interface LLAUserProfileMainInfo : MTLModel<MTLJSONSerializing>

@property(nonatomic , strong) LLAUser *userInfo;

@property(nonatomic , strong) NSMutableArray <LLAHallVideoItemInfo *> *directorVideoArray;

@property(nonatomic , strong) NSMutableArray <LLAHallVideoItemInfo *> *actorVideoArray;

@property(nonatomic , assign) UserProfileHeadVideoType showingVideoType;

@end
