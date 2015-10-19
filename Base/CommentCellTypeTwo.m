//
//  CommentCellTypeTwo.m
//  WPXap
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 龙乐. All rights reserved.
//

#import "CommentCellTypeTwo.h"

@implementation CommentCellTypeTwo

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)replyComment:(UIButton *)sender {
    [self.delegate replyCommentTo:self.model.commentPid];
}

- (IBAction)supportComment:(UIButton *)sender {
    [self.delegate agreeWith:self.model.commentPid];
}

- (IBAction)disagreeComment:(UIButton *)sender {
    [self.delegate disagreeWith:self.model.commentPid];
}
@end
