//
//  QCEditLocalView.h
//  qianchuo
//
//  Created by jacklong on 16/6/13.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "LCCancelAndOKView.h"


typedef void(^QCEditedBlock)(NSDictionary *editedDic);

@interface QCEditLocalView : LCCancelAndOKView
@property (nonatomic)LCEditDetailType editType;
@property (nonatomic,strong)QCEditedBlock editedBlock;
//@property (nonatomic,strong)id editView;
//@property (nonatomic)float offsetY;

+(void)showEditViewAndEditedBlock:(QCEditedBlock)editedBlock;
 
@end
