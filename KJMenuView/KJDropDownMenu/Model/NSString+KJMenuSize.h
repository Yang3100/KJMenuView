//
//  NSString+KJMenuSize.h
//  KJMenuView
//
//  Created by 杨科军 on 2019/2/25.
//  Copyright © 2019 杨科军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KJMenuSize)
- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
@end
