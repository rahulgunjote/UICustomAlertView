//
//  UICustomAlertView.h
//  UICustomAlertView
//
//  Created by Rahul Gunjote on xx/xx/14.
//  Copyright (c) 2014 Rahul Gunjote. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UICustomAlertViewStyle) {
    
    UICustomAlertViewStyleDefault = 0,
    UICustomAlertViewStylePlainTextInput = 1,
    UICustomAlertViewStyleSecureTextInput = 2,
    UICustomAlertViewStyleLoginAndPasswordInput = 3
};

@class UICustomAlertView;
@protocol UICustomAlertViewDelegate <NSObject>
@optional

-(void)dismiss;
-(void)alertView:(UICustomAlertView *)alertView dismissWithclickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface UICustomAlertView : UIView
{
    
}
/*!
 *  confirm to UICustomAlertView protocol
 */
@property (nonatomic,assign)id<UICustomAlertViewDelegate> delegate;
/*!
 *  sets style of a alert view
 */
@property(nonatomic,assign)UICustomAlertViewStyle alertViewStyle;
/*!
 *  sets background image to alert view
 */
@property(nonatomic,strong)UIImage *backgroundImage;
/*!
 *  alert title
 */
@property (nonatomic,strong)UILabel  *titleLabel;
/*!
 *  alert message
 */
@property (nonatomic,strong)UILabel  *messageLabel;
/*!
 *  dismiss (Hide) alert view button
 */
@property (nonatomic,strong)UIButton *dismissButton;
/*!
 *  get all buttons other than dismiss (Hide) button. nil when there will not be any other button than hide button
 */
@property (nonatomic,strong,readonly)NSArray  *otherButtons;
/*!
 *  nil when there will not be any textfield
 */
@property (nonatomic,strong, readonly)NSArray  *textFields;


-(id)initWithTitle:(NSString*)alertTitle message:(NSString *)alertMessage delegate:(id) delegate dismissButtonTitle:(NSString *)dismissButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;

/*!
 *  shows alert view on top of all views
 */
-(void)show;

/*!
 *  calls on dismissButton clicked
 */
- (void)hide;

@end


