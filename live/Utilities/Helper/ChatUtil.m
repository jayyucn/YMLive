//
//  ChatUtil.m
//  qianchuo
//
//  Created by 林伟池 on 16/5/24.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ChatUtil.h"


@interface ChatUtil()

@property (nonatomic , strong) NSArray* mFilterArray;

@end

@implementation ChatUtil


#pragma mark - init
+ (instancetype)shareInstance {
    static id test;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[[self class] alloc] init];
    });
    return test;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _mFilterArray = [self loadFileData];
    }
    return self;
}

#pragma mark - 下载脏词文件
- (void) downLoadDirtyFile:(NSString*)fileUrl
{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"filtermsg.txt"];
    NSFileManager* FM = [NSFileManager defaultManager];
    
    if (![FM fileExistsAtPath:filePath]) {
        NSLog(@"file is not exist");
        [[NSUserDefaults standardUserDefaults] setObject:fileUrl forKey:kDirtyWordServerUrl];
        
        //declerations
        NSString* TheFile;
        
        if ([FM fileExistsAtPath:filePath]) {
            NSLog(@"file is exist");
            
            [FM removeItemAtPath:filePath error:nil];
        }
        
        //downloading file
        NSURL *url = [NSURL URLWithString:fileUrl];
        TheFile = [[NSString alloc] initWithContentsOfURL: url
                                                 encoding: NSUTF8StringEncoding
                                                    error: nil];
        //nsstring to nsdata
        NSData* data = [TheFile dataUsingEncoding:NSUTF8StringEncoding];
        
        
        //saving file
        [FM createFileAtPath:filePath contents:data attributes:nil];
        
        if (!_mFilterArray) {
            _mFilterArray = [self loadFileData];
        }
        
    } else {
        NSString *dirtyOldFileUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kDirtyWordServerUrl];
        if (![fileUrl isEqualToString:dirtyOldFileUrl]) {
            [[NSUserDefaults standardUserDefaults] setObject:fileUrl forKey:kDirtyWordServerUrl];
            
            //declerations
            NSString* TheFile;
            
            if ([FM fileExistsAtPath:filePath]) {
                NSLog(@"file is exist");
                
                [FM removeItemAtPath:filePath error:nil];
            }
            
            //downloading file
            NSURL *url = [NSURL URLWithString:fileUrl];
            TheFile = [[NSString alloc] initWithContentsOfURL: url
                                                     encoding: NSUTF8StringEncoding
                                                        error: nil];
            //nsstring to nsdata
            NSData* data = [TheFile dataUsingEncoding:NSUTF8StringEncoding];
            
            
            //saving file
            [FM createFileAtPath:filePath contents:data attributes:nil];
            
            if (!_mFilterArray) {
                _mFilterArray = [self loadFileData];
            }
        } else {
            NSLog(@"file exist not download");
            if (!_mFilterArray) {
                _mFilterArray = [self loadFileData];
            }
        }
    }
    
    NSLog(@"download file succ");
}


- (NSArray *) loadFileData
{
    //    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"dirtywords.txt"];
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"filtermsg.txt"];
    
    
    NSError* err=nil;
    NSString* mTxt=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
    
    NSLog(@"dirty words:%@",mTxt);
    return [mTxt componentsSeparatedByString:@"，"];
}
#pragma mark - update



#pragma mark - get

- (NSString *)getFilterStringWithSrc:(NSString *)srcString {
    if (srcString) {
        for (NSString* filterString in self.mFilterArray) {
            NSString* tmpString = [filterString stringByReplacingRegex:@"." with:@"*" caseInsensitive:NO];
            srcString = [srcString stringByReplacing:filterString with:tmpString];
        }
    }
    return srcString;
}


#pragma mark - message

@end
