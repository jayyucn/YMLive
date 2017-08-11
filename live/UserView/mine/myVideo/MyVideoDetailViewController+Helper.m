////
////  MyVideoDetailViewController+Helper.m
////  XCLive
////
////  Created by 王威 on 15/3/23.
////  Copyright (c) 2015年 www.0x123.com. All rights reserved.
////
//
//#import "MyVideoDetailViewController.h"
////#import "NSString+LCChat.h"
//#import "ESEmoticonManager.h"
//
//@implementation MyVideoDetailViewController (Helper)
//
//+ (NSString *)HTMLFromMessageContent:(NSString *)content
//{
//    if (!ESIsStringWithAnyText(content)) {
//        return @"";
//    }
//    
//    // Escape HTML tags and special characters
//    NSString *filteredContent = [content stringByEncodingHTMLEntitiesForTTStyledText];
//    if (!ESIsStringWithAnyText(filteredContent)) {
//        return @"";
//    }
//    
//    // Replace emoticons
//    // [xxx] to <img src="file:///xxxxx.png" width="24" height="24"/>
//    filteredContent = [[ESEmoticonManager sharedManager]
//                       stringByReplacingQQExpressionNameToHTML:filteredContent
//                       styleString:@"width=\"16.5\" height=\"16.5\""];
//    
//    // Detect URLs, numbers
//    NSDataDetector *dataDetector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypePhoneNumber | NSTextCheckingTypeLink) error:NULL];
//    if (!dataDetector) {
//        return filteredContent;
//    }
//    NSMutableString *resultContent = [filteredContent mutableCopy];
//    __block NSUInteger locationOffset = 0;
//    [dataDetector enumerateMatchesInString:filteredContent options:0
//                                     range:NSMakeRange(0, filteredContent.length)
//                                usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
//     {
//         NSRange range = result.range;
//         if (range.location == NSNotFound) {
//             return ;
//         }
//         range.location += locationOffset;
//         if (range.location + range.length > resultContent.length) {
//             return;
//         }
//         if (result.URL.isFileURL) {
//             // 表情图片用的是本地URL
//             return;
//         }
//         
//         //https://developer.apple.com/library/ios/featuredarticles/iPhoneURLScheme_Reference/Introduction/Introduction.html
//         // TTStyledText里的mail:xxxx@xxx.xx tel:xxx 会自动跳转到系统邮件app,
//         // 这里截获以让TTNavigator处理,从而让ChatViewController处理
//         
//         NSString *str = [resultContent substringWithRange:range];
//         NSString *replace = nil;
//         if (NSTextCheckingTypePhoneNumber == result.resultType &&
//             result.phoneNumber) {
//             // NSDataDetector解析出来的电话号码可能有误
//             // 例如 "tel:12345678" 解析后 result.phoneNumber为"tel:12345678"(包含"tel:")
//             // 正确的电话号码可包含 +86 1234-886 (12)
//             NSString *number = [result.phoneNumber replace:@"[^\\+\\s\\-\\(\\)\\d]" with:@"" options:(NSRegularExpressionSearch|NSCaseInsensitiveSearch)];
//             if (number.length) {
//                 number = [number URLEncode];
////                 replace = NSStringWith(@"<a href=\"%@://%@\">%@</a>", LCChatURLSchemePhoneNumber, number, str);
//             }
//         }
//         else if (result.resultType == NSTextCheckingTypeLink && result.URL)
//         {
//             NSString *url = result.URL.absoluteString;
//             NSString *urlLowercase = url.lowercaseString;
//             if ([urlLowercase hasPrefix:@"mailto:"]) {
//                 // 接管TTStyledText的默认行为
//                 // Email至少包含一个 "@" 和一个 "."
//                 if ([url contains:@"@"] && [url contains:@"."]) {
//                     NSString *email = [url replace:@"^mailto:/?/?" with:@"" options:(NSCaseInsensitiveSearch | NSRegularExpressionSearch)];
////                     url = NSStringWith(@"%@://%@", LCChatURLSchemeEmail, email);
//                 }
//                 else
//                 {
//                     url = nil;
//                 }
//             }
//             else if ([urlLowercase hasPrefix:@"tel:"])
//             {
//                 // 接管TTStyledText的默认行为
//                 NSString *phone = [url replace:@"^tel:/?/?" with:@"" options:(NSCaseInsensitiveSearch | NSRegularExpressionSearch)];
////                 url = NSStringWith(@"%@://%@", LCChatURLSchemePhoneNumber, phone);
//             }
//             else if ([urlLowercase hasPrefix:@"@:"])
//             {
//                 
//             }
//             
//             if (url)
//             {
//                 replace = NSStringWith(@"<a href=\"%@\">%@</a>", url, str);
//             }
//         }
//         
//         if (replace) {
//             [resultContent replaceInRange:range to:replace];
//             locationOffset += (replace.length - range.length);
//         }
//         
//     }];
//    
//    return (NSString *)resultContent;
//}
//
//
//@end