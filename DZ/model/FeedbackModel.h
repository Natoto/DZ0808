//
//  FeedbackModel.h
//  DZ
//
//  Created by PFei_He on 14-6-23.
//
//

#import <Foundation/Foundation.h>
#import "feedback.h"

@interface FeedbackModel : BeeStreamViewModel

@property (nonatomic, strong) NSString *content;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, assign) float appVersion;
@property (nonatomic, strong) NSString *QQ;

- (void)feedback;

AS_SIGNAL(FEEDBACK_RELOADING)
AS_SIGNAL(FEEDBACK_RELOADED)
AS_SIGNAL(FEEDBACK_FAILED)

@end
