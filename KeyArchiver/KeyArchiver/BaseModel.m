//
//  BaseModel.m
//  KeyArchiver
//
//  Created by Mr.Yang on 13-7-17.
//  Copyright (c) 2013年 Hunter. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel

- (void)dealloc
{
    [self classDealloced];
}

- (void)classDealloced
{
    Class classRef = [self class];
    // method 1
    const char *className = class_getName(classRef);
    // method 2
    NSString *classNameStr = NSStringFromClass(classRef);
    //className is same as [classNameStr UTF8String]
    NSLog(@"~classDealloced:%s  -  %@", className, classNameStr);
}

- (id)copyWithZone:(NSZone *)zone
{
    BaseModel *model = [[[self class] alloc] init];
    if (model) {
        [self classPropertListNameWithBlock:^(NSString *name) {
            [model setValue:[self valueForKey:name] forKey:name];
        }];
    }
    return model;
}

- (void)classPropertListNameWithBlock:(void(^)(NSString *name))propretyBlock
{
    id classRef = [self class];
    u_int listCount = 0;
    while (true) {
        objc_property_t *propretyList = class_copyPropertyList(classRef, &listCount);
        for (int i = 0; i < listCount; i++) {
            objc_property_t proprety = propretyList[i];
            char const *propretyName = property_getName(proprety);
            NSString *name = [NSString stringWithCString:propretyName encoding:NSUTF8StringEncoding];
            propretyBlock(name);
        }
        free(propretyList);
        classRef = class_getSuperclass(classRef);
        if ([NSStringFromClass(classRef) isEqualToString:@"NSObject"]) {
            break;
        }
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self classPropertListNameWithBlock:^(NSString *name) {
        [aCoder encodeObject:[self valueForKey:name] forKey:name];
    }];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self classPropertListNameWithBlock:^(NSString *name) {
            [self setValue:[aDecoder decodeObjectForKey:name] forKey:name];
        }];
    }
    return self;
}

- (NSString *)description
{
    NSMutableString *string = [[NSMutableString alloc] init];
    [self classPropertListNameWithBlock:^(NSString *name) {
        [string appendString:[NSString stringWithFormat:@"\nname:%@ -   value:%@",name, [self valueForKey:name]]];
    }];
    
    return string;
}

@end
