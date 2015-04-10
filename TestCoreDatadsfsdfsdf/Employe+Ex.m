//
//  Employe+Ex.m
//  TestCoreDatadsfsdfsdf
//
//  Created by Alexander on 02.04.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "Employe+Ex.h"
#import <UIKit/UIKit.h>

@implementation Employe (Ex)

- (void)awakeFromInsert {
    self.avatar = [UIImage imageNamed:@"no-avatar"];
}

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.first_name, self.last_name];
}
@end
