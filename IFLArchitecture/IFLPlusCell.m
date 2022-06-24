//
//  IFLPlusCell.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/23.
//

#import "IFLPlusCell.h"
#import "Masonry.h"

@implementation IFLPlusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self prepareUI];
    }
    
    return self;
}


- (void)prepareUI {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.numLabel];
    [self.contentView addSubview:self.minusBtn];
    [self.contentView addSubview:self.plusBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView).offset(20);
    }];
    
    [self.plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.trailing.mas_equalTo(self.contentView).offset(-50);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.plusBtn.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.numLabel.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"default_name";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:20];
        _nameLabel.textColor = [UIColor redColor];
    }
    
    return _nameLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.font = [UIFont systemFontOfSize:20];
        _numLabel.textColor = [UIColor whiteColor];
        _numLabel.text = @"0";
    }
    return _numLabel;;
}

- (UIButton *)minusBtn {
    if (!_minusBtn) {
        _minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minusBtn setTitle:@"-" forState:UIControlStateNormal];
        [_minusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _minusBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_minusBtn setBackgroundColor:[UIColor blueColor]];
        _minusBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_minusBtn addTarget:self action:@selector(minus:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _minusBtn;
}

- (UIButton *)plusBtn {
    if (!_plusBtn) {
        _plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_plusBtn setTitle:@"+" forState:UIControlStateNormal];
        [_plusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _plusBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_plusBtn setBackgroundColor:[UIColor blueColor]];
        _plusBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_plusBtn addTarget:self action:@selector(plus:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _plusBtn;
}

- (void)minus:(UIButton *)btn {
    if (self.operateBlock) {
        self.numLabel.text = [NSString stringWithFormat:@"%i", self.operateBlock(0, self.indexPath)];
    }
}

- (void)plus:(UIButton *)btn {
    if (self.operateBlock) {
        self.numLabel.text = [NSString stringWithFormat:@"%i", self.operateBlock(1, self.indexPath)];
    }
}

- (void)dealloc {
    NSLog(@" --- %s ---- ", __func__);
}

@end
