//
//  CZLocalizedHelper.h
//  InsightView
//
//  Created by Ug's iMac on 2016/11/8.
//  Copyright © 2016年 avery. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CZLocalizedString(key) [[CZLocalizedHelper sharedInstance] stringWithKey:key]

@interface CZLocalizedHelper : NSObject

+ (instancetype)sharedInstance;
/** 返回当前语言包文件夹对应的 NSBundle 对象 */
- (NSBundle *)bundle;
/** 当前的应用语言，跟随系统或应用内手动设置 */
- (NSString *)currentLanguage;
/** 当前系统语言 */
- (NSString *)currentSystemLanguage;
/** 设置应用的语言，参数需要跟项目中的语言包文件夹 .lproj 的前缀一致 */
- (void)setUserLanguage:(NSString *)language;
/** key 对应语言的文字 */
- (NSString *)stringWithKey:(NSString *)key;

@end
