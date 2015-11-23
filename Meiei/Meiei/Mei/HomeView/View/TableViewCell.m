//
//  TableViewCell.m
//  Meiei
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "TableViewCell.h"


@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imgView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"o"]];
        
        _imgView.frame = CGRectMake(5, 5, kWidth - 10,130);
        
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 8;
        
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, _imgView.frame.size.width - 20, 20)];
        _infoLabel.text = @"-❀--❀--❀--❀--❀--❀--❀--❀-";
        _infoLabel.textColor = [UIColor colorWithRed:0.916 green:0.872 blue:1.000 alpha:1.000];
        _infoLabel.numberOfLines = 0;
        _infoLabel.font = [UIFont systemFontOfSize:13];
        _infoLabel.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.300];
        _infoLabel.layer.masksToBounds = YES;
        _infoLabel.layer.cornerRadius = 5;
        [self.imgView addSubview:_infoLabel];
        
        [self addSubview:_imgView];
    }

    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
