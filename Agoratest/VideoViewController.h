//
//  VideoViewController.h
//  Agoratest
//
//  Created by 川何 on 16/10/11.
//  Copyright © 2016年 川何. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoViewController : UIViewController
@property (nonatomic,copy)NSString *roomNumber;
@property(nonatomic,copy)NSString *userID;
@property (strong, nonatomic) NSString *vendorKey;

@end
