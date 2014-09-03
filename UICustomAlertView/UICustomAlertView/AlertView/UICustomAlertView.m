//
//  UICustomAlertView.m
//  UICustomAlertView
//
//  Created by Rahul Gunjote on xx/xx/14.
//  Copyright (c) 2014 Rahul Gunjote. All rights reserved.
//

#import "UICustomAlertView.h"

typedef NS_OPTIONS(NSInteger, UIViewBorderSide) {
     UIViewBorderSideNone      =0,
     UIViewBorderSideTop       = 1 << 0, //1
     UIViewBorderSideLeft      = 1 << 1, //2
     UIViewBorderSideBottom    = 1 << 2, //4
     UIViewBorderSideRight     = 1 << 3  //8
};
@interface UICustomAlertView()<UITextFieldDelegate>
{
    NSInteger _height;
    NSInteger _width;
}
@property (nonatomic,strong)UIView *platformWindow;
@property(nonatomic,strong)UITextField *plainTextField;
@property(nonatomic,strong)UITextField *secureTextField;
@property (nonatomic,strong)NSMutableArray *otherButtonsArray;
@end

@implementation UICustomAlertView
@synthesize titleLabel,messageLabel;
@synthesize dismissButton,otherButtons;
@synthesize textFields;

-(id)initWithTitle:(NSString*)alertTitle message:(NSString *)alertMessage delegate:(id<UICustomAlertViewDelegate>) delegate dismissButtonTitle:(NSString *)dismissButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;
{
     self = [super initWithFrame:CGRectZero];
    if (self) {
        
        if ([delegate conformsToProtocol:@protocol(UICustomAlertViewDelegate)]) {
            _delegate=delegate;
        }
        UIWindow  *window = [UIApplication sharedApplication].keyWindow;
        if (!window)
        {
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }
        _platformWindow =[[UIView alloc] initWithFrame:window.bounds];
        _platformWindow.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        _width = 250;
        
        if (alertTitle)
        {
            titleLabel =[[UILabel alloc] init];
            titleLabel.text = alertTitle;
            titleLabel.textColor =[UIColor blueColor];
            titleLabel.numberOfLines = 2;
            titleLabel.textAlignment =NSTextAlignmentCenter;
            titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            [self addSubview:titleLabel];
            [titleLabel addObserver:self forKeyPath:NSStringFromSelector(@selector(font)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        }
        if (alertMessage) {
            messageLabel =[[UILabel alloc] init];
            messageLabel.text =alertMessage;
            messageLabel.numberOfLines = 5;
            messageLabel.textColor =[UIColor blueColor];
            messageLabel.textAlignment =NSTextAlignmentCenter;
            messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            [self addSubview:messageLabel];
            [messageLabel addObserver:self forKeyPath:NSStringFromSelector(@selector(font)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        }
        dismissButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [dismissButton setTitle:(dismissButtonTitle ? dismissButtonTitle : @"Ok") forState:UIControlStateNormal];
        [dismissButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [dismissButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        [self addDismissButtonAttributes:@{@"Font": [UIFont fontWithName:@"Arial" size:14],
                                           @"TextColor": [UIColor blueColor],
                                           @"BackgroundColor": [UIColor whiteColor]}];
        [dismissButton addObserver:self forKeyPath:NSStringFromSelector(@selector(backgroundImage)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addSubview:dismissButton];
        
        if (otherButtonTitles) {
            _otherButtonsArray =[[NSMutableArray alloc] init];
            int i=0;
            for (NSString *btnTitle in otherButtonTitles)
            {
                UIButton *otherButton =[UIButton buttonWithType:UIButtonTypeCustom];
                otherButton.tag=i;
                [otherButton setTitle:btnTitle forState:UIControlStateNormal];
                [otherButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [otherButton addTarget:self action:@selector(dismissWithclickedButton:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:otherButton];
                [otherButton addObserver:self forKeyPath:NSStringFromSelector(@selector(backgroundImage)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
                [_otherButtonsArray addObject:otherButton];
                i++;
            }
            otherButtons = [NSArray arrayWithArray:_otherButtonsArray];
            [self addOtherButtonsAttributes:@{@"Font": [UIFont fontWithName:@"Arial" size:14],
                                              @"TextColor": [UIColor blueColor],
                                              @"BackgroundColor": [UIColor whiteColor]}];
        }
        self.backgroundColor =[UIColor whiteColor];
        self.layer.cornerRadius=5;
        [self configureView];
        self.frame = CGRectMake(0, 0, _width, _height);
    }
    return self;
}
#pragma mark ---- view appearance methods ----
-(void)configureView
{
    _height = 0;
    NSInteger hPadding =10, vPadding=10;
    CGSize expectedTextSize;
    CGSize maximumLabelSize = CGSizeMake(_width-2*hPadding, 9999);
    NSInteger absoluteWidth =_width-2*hPadding;
    
    if (titleLabel) {
         expectedTextSize = [titleLabel sizeThatFits:maximumLabelSize];
        titleLabel.frame =CGRectMake(hPadding, _height+vPadding, absoluteWidth, expectedTextSize.height);
        _height = titleLabel.frame.origin.y+titleLabel.frame.size.height;
    }
    if (messageLabel) {
        expectedTextSize = [messageLabel sizeThatFits:maximumLabelSize];
        messageLabel.frame =CGRectMake(hPadding, _height+vPadding, absoluteWidth, expectedTextSize.height);
        _height = messageLabel.frame.origin.y+messageLabel.frame.size.height;
    }
    
    if (_plainTextField) {
        _plainTextField.frame =CGRectMake(hPadding, _height+vPadding, absoluteWidth, 30);
        _height = _plainTextField.frame.origin.y+_plainTextField.frame.size.height;
    }
    if (_secureTextField) {
        _secureTextField.frame =CGRectMake(hPadding, _height+vPadding, absoluteWidth, 30);
        _height = _secureTextField.frame.origin.y+_secureTextField.frame.size.height;
    }
    
    if (_otherButtonsArray.count==1)
    {
        UIButton *otherBtn = [_otherButtonsArray firstObject];
        otherBtn.frame= CGRectMake(hPadding, _height+vPadding, absoluteWidth/2, 30);
        [self addTopBorderToView:otherBtn borderSide:UIViewBorderSideTop|UIViewBorderSideRight];
        dismissButton.frame =CGRectMake(hPadding+ (absoluteWidth/2), _height+vPadding, absoluteWidth/2, 30);
        [self addTopBorderToView:dismissButton borderSide:UIViewBorderSideTop];

        _height = dismissButton.frame.origin.y+dismissButton.frame.size.height;
    }else if (_otherButtonsArray.count>1)
    {
        _height+=vPadding;
        for (UIButton *otherButton in _otherButtonsArray) {
             otherButton.frame =CGRectMake(0, _height, _width, 30);
             [self addTopBorderToView:otherButton borderSide:(UIViewBorderSideTop)];
            _height+=otherButton.frame.size.height;
        }
        dismissButton.frame =CGRectMake(0, _height, _width, 30);
        [self addTopBorderToView:dismissButton borderSide:(UIViewBorderSideTop)];
        _height = dismissButton.frame.origin.y+dismissButton.frame.size.height;
    }else
    {
        dismissButton.frame =CGRectMake(hPadding, _height+vPadding, absoluteWidth, 30);
        _height = dismissButton.frame.origin.y+dismissButton.frame.size.height;
    }
    _height +=3;
}
-(void)show
{
    @try
    {
        UIWindow  *window = [UIApplication sharedApplication].keyWindow;
        if (!window)
        {
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }
        [window addSubview:_platformWindow];
        [_platformWindow addSubview:self];
        self.frame =CGRectMake(_platformWindow.center.x-(_width/2), 0, _width, _height);
        self.alpha=0;
        _platformWindow.alpha = 0;
        CGRect viewFrame = self.frame;
        viewFrame.origin.y = _platformWindow.center.y-(_height/2);
        
        [UIView animateWithDuration:0.5 animations:^{
            self.frame =viewFrame;
            self.alpha=1;
            _platformWindow.alpha = 1;
        } completion:^(BOOL finished) {
        }];
        
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        
    }
    
}
- (void)hide
{
    CGRect viewFrame = self.frame;
    viewFrame.origin.y = -(CGRectGetHeight(self.frame));
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = viewFrame;
        self.alpha = 0;
        _platformWindow.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            [_platformWindow removeFromSuperview];
        }
    }];
}

#pragma mark ---- Manipulate view components methods ----
-(void)setAlertViewStyle:(UICustomAlertViewStyle)alertViewStyle
{
    switch (alertViewStyle) {
        case UICustomAlertViewStylePlainTextInput:
            _plainTextField =[[UITextField alloc] init];
            break;
        case UICustomAlertViewStyleSecureTextInput:
            _secureTextField =[[UITextField alloc] init];
            break;
        case UICustomAlertViewStyleLoginAndPasswordInput:
            _plainTextField =[[UITextField alloc] init];
            _plainTextField.placeholder =@"Username";
            _secureTextField =[[UITextField alloc] init];
            _secureTextField.placeholder =@"Password";
            break;
        default:
            break;
    }
    NSMutableArray *tempTextFields = [NSMutableArray array];
    if (_plainTextField)
    {
        _plainTextField.returnKeyType = UIReturnKeyDefault;
        _plainTextField.delegate = self;
        _plainTextField.borderStyle = UITextBorderStyleRoundedRect;
        _plainTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:_plainTextField];
        [tempTextFields addObject:_plainTextField];
    }
    if (_secureTextField)
    {
        _secureTextField.secureTextEntry =YES;
        _secureTextField.returnKeyType = UIReturnKeyDefault;
        _secureTextField.delegate = self;
        _secureTextField.borderStyle = UITextBorderStyleRoundedRect;
        _secureTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:_secureTextField];
        [tempTextFields addObject:_secureTextField];
    }
    if (tempTextFields.count>0) {
        textFields = [NSArray arrayWithArray:tempTextFields];
    }
    [self configureView];
    
}
- (void)addOtherButtonsAttributes:(NSDictionary *)attrs
{
    UIFont *font = [attrs valueForKey:@"Font"];
    UIColor *textColor = [attrs valueForKey:@"TextColor"];
    UIColor *backgroundColor = [attrs valueForKey:@"BackgroundColor"];
    
    for (UIButton *otherButton in _otherButtonsArray) {
        
        [otherButton.titleLabel setFont:font];
        [otherButton setTitleColor:textColor forState:UIControlStateNormal];
        [otherButton setBackgroundColor:backgroundColor];
    }
}

- (void)addDismissButtonAttributes:(NSDictionary *)attrs
{
    UIFont *font = [attrs valueForKey:@"Font"];
    UIColor *textColor = [attrs valueForKey:@"TextColor"];
    UIColor *backgroundColor = [attrs valueForKey:@"BackgroundColor"];
    
    [dismissButton.titleLabel setFont:font];
    [dismissButton setTitleColor:textColor forState:UIControlStateNormal];
    [dismissButton setBackgroundColor:backgroundColor];
}
-(void)addTopBorderToView:(UIView *)view borderSide:(UIViewBorderSide)borderSide
{
    
    if (borderSide & UIViewBorderSideTop) {
        CALayer *border = [CALayer layer];
        border.backgroundColor = [UIColor lightGrayColor].CGColor;
        border.frame = CGRectMake(0.0f, 0.0f, view.frame.size.width, 1.0f);
        [view.layer addSublayer:border];
    }
    if (borderSide & UIViewBorderSideLeft) {
        CALayer *border = [CALayer layer];
        border.backgroundColor = [UIColor lightGrayColor].CGColor;
        border.frame = CGRectMake(0.0f, 0.0f, 1.0f, view.frame.size.height);
        [view.layer addSublayer:border];
    }
    if (borderSide & UIViewBorderSideBottom) {
        CALayer *border = [CALayer layer];
        border.backgroundColor = [UIColor lightGrayColor].CGColor;
        border.frame = CGRectMake(0.0f, view.frame.size.height-1.0f, view.frame.size.width, 1.0f);
        [view.layer addSublayer:border];
    }
    if (borderSide & UIViewBorderSideRight) {
        CALayer *border = [CALayer layer];
        border.backgroundColor = [UIColor lightGrayColor].CGColor;
        border.frame = CGRectMake(view.frame.size.width-1.0f, 0.0f, 1.0f, view.frame.size.height);
        [view.layer addSublayer:border];
    }
   
}
#pragma mark ---- call delegate Methods ----
-(void)dismiss:(id)sender
{
    [self hide];
    if ([_delegate respondsToSelector:@selector(dismiss)])
    {
        [_delegate dismiss];
    }
}
- (void)dismissWithclickedButton:(id)sender
{
    [self hide];
    if ([_delegate respondsToSelector:@selector(alertView:dismissWithclickedButtonAtIndex:)]) {
        [_delegate alertView:self dismissWithclickedButtonAtIndex:[sender tag]];
    }
}
#pragma mark ---- UITextfield methods ----
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -70;
    const float movementDuration = 0.3f;
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.frame = CGRectOffset(self.frame, 0, movement);
    [UIView commitAnimations];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{   [textField resignFirstResponder];
    return YES;
}

#pragma mark ---- NSObject methods ----
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self configureView];
}
-(void)dealloc
{
    [dismissButton removeObserver:self forKeyPath:NSStringFromSelector(@selector(backgroundImage))];
    [titleLabel removeObserver:self forKeyPath:NSStringFromSelector(@selector(font))];
    [messageLabel removeObserver:self forKeyPath:NSStringFromSelector(@selector(font))];
     for (UIButton *otherButton in _otherButtonsArray) {
         [otherButton removeObserver:self forKeyPath:NSStringFromSelector(@selector(backgroundImage))];
     }
}
@end
