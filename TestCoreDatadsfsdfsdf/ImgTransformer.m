//
//  ImgTransformer.m
//  Test_CoreData
//
//  Created by Alexander on 19.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "ImgTransformer.h"
#import <UIKit/UIKit.h>

@implementation ImgTransformer
+ (Class)transformedValueClass {
    return [UIImage class];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}

- (id)transformedValue:(id)value {
    return  UIImageJPEGRepresentation(value, 0.8);
}
- (id)reverseTransformedValue:(id)value {
    return [UIImage imageWithData:value];
}
@end
