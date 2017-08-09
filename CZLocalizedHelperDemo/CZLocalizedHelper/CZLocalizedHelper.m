//
//  CZLocalizedHelper.m
//  InsightView
//
//  Created by Ug's iMac on 2016/11/8.
//  Copyright © 2016年 avery. All rights reserved.
//

#import "CZLocalizedHelper.h"

static NSBundle *_bundle;
static NSString *const kUserLanguage = @"kUserLanguage";

@implementation CZLocalizedHelper

+ (instancetype)sharedInstance {
	static CZLocalizedHelper *helper;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		helper = [[CZLocalizedHelper alloc] init];
	});
	return helper;
}

- (instancetype)init {
	if (self = [super init]) {
		if (!_bundle) {
			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			NSString *userLanguage = [defaults valueForKey:kUserLanguage];
			// 用户未手动设置过语言
			if (userLanguage.length == 0) {
				// 先去获取系统语言，返回格式为：语言-国家
				NSArray *systemLanguages = [NSLocale preferredLanguages];
				userLanguage = [systemLanguages objectAtIndex:0];
				// 移除获取的系统语言中的国家字符
				NSRange nationDashRange = [userLanguage rangeOfString:@"-" options:NSBackwardsSearch];
				userLanguage = [userLanguage substringToIndex:nationDashRange.location];
				if ([[NSBundle mainBundle] pathForResource:userLanguage ofType:@"lproj"] == nil) {	// 系统语言没有对应的语言包，先去取通用的“Base.lproj”语言包，没有则去取应用的第一个语言包
					if ([[NSBundle mainBundle] pathForResource:@"Base" ofType:@"lproj"] == nil) {
						NSArray *bundleLanguages = [[NSBundle mainBundle] preferredLocalizations];
						NSString *bundleFirstLanguage = bundleLanguages.firstObject;
						userLanguage = bundleFirstLanguage;
					} else {
						userLanguage = @"Base";
					}
				}
			}
			NSString *path = [[NSBundle mainBundle] pathForResource:userLanguage ofType:@"lproj"];
			_bundle = [NSBundle bundleWithPath:path];
		}
	}
	return self;
}

- (NSBundle *)bundle {
	return _bundle;
}

- (NSString *)currentLanguage {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *userLanguage = [defaults valueForKey:kUserLanguage];
	if (userLanguage.length == 0) {
		NSString *systemLanguage = [self currentSystemLanguage];
		return systemLanguage;
	}
	return userLanguage;
}

- (NSString *)currentSystemLanguage {
	// 先去获取系统语言，返回格式为：语言-国家
	NSArray *systemLanguages = [NSLocale preferredLanguages];
	NSString *currentSystemLanguage = [systemLanguages objectAtIndex:0];
	// 移除获取的系统语言中的国家字符
	NSRange nationDashRange = [currentSystemLanguage rangeOfString:@"-" options:NSBackwardsSearch];
	currentSystemLanguage = [currentSystemLanguage substringToIndex:nationDashRange.location];
	return currentSystemLanguage;
}

- (void)setUserLanguage:(NSString *)language {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
	_bundle = [NSBundle bundleWithPath:path];
	[defaults setValue:language forKey:kUserLanguage];
	[defaults synchronize];
}

- (NSString *)stringWithKey:(NSString *)key {
	if (_bundle) {
		return [_bundle localizedStringForKey:key value:nil table:@"localization"];
	} else {
		return NSLocalizedString(key, nil);
	}
}

@end
