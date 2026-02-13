//
//  PGScreenShieldView.m
//  CherryTWUser
//
//  Created by guo on 2025/2/8.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGScreenShieldView.h"

@interface PGScreenShieldView ()

@property (nonatomic,strong) UIView *clearView;

@end

@implementation PGScreenShieldView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setupUI];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setupUI];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    [self setupUI];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.textField.frame = self.bounds;
  self.clearView.frame = self.bounds;
  
  if (self.textField.superview != self) {
      [self addSubview:self.textField];
  }
}

- (void)setupUI {
  [self addSubview:self.textField];
  self.textField.subviews.firstObject.userInteractionEnabled = YES;
  [self.textField.subviews.firstObject addSubview:self.clearView];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    if (self.textField.isFirstResponder) {
        [self.textField resignFirstResponder];
        self.textField.subviews.firstObject.userInteractionEnabled = YES;
    }
}

- (void)addSubview:(UIView *)view {
  [super addSubview:view];
  if (self.textField != view) {
    [self.clearView addSubview:view];
  }
}

- (UITextField *)textField {
  if (!_textField) {
    _textField = [[UITextField alloc] init];
    _textField.secureTextEntry = YES;
  }
  
  return _textField;
}

- (UIView *)clearView {
  if (!_clearView) {
    _clearView = [[UIView alloc] init];
    _clearView.backgroundColor = [UIColor clearColor];
  }
  
  return _clearView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
