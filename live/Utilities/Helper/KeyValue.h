//
//  KeyValue.h
//  Fitel
//
//  Created by James on 14-7-22.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyValue : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, retain) id value;

- (instancetype)initWithKey:(NSString *)key value:(id)value;

+ (instancetype)key:(NSString *)key value:(id)value;

@end
