//
//  postImageModel.h
//  DZ
//
//  Created by Nonato on 14-5-6.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#undef	PER_PAGE
#define PER_PAGE	(30)
#import "Bee.h"
#import "postImage.h"
@interface postImageModel : BeeStreamViewModel
@property (nonatomic, retain) NSString *	fid;
@property (nonatomic, retain) NSString *	uid;
@property (nonatomic,  retain)NSString *    filename;
@property (nonatomic,retain)  NSData   *    filedata;
@property (nonatomic,retain) POSTIMAGE *    postimge;
@end
