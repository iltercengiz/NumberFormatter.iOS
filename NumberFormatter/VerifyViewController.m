//
//  VerifyViewController.m
//  NumberFormatter
//
//  Created by Ilter Cengiz on 12/06/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "VerifyViewController.h"

#import "NumberFormatter.h"

#import <BlocksKit/UIAlertView+BlocksKit.h>
#import <BlocksKit/UIBarButtonItem+BlocksKit.h>
#import <libPhoneNumber-iOS/NBAsYouTypeFormatter.h>
#import <libPhoneNumber-iOS/NBPhoneNumberUtil.h>

@interface VerifyViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;

@property (nonatomic) NBAsYouTypeFormatter *formatter;

@end

@implementation VerifyViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.phoneNumberField.delegate = self;
    
    NSError *error = nil;
    NSString *regionCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    NBPhoneNumber *exampleNumber = [[NBPhoneNumberUtil sharedInstance] getExampleNumberForType:regionCode
                                                                                          type:NBEPhoneNumberTypeMOBILE
                                                                                         error:&error];
    if (error) {
        NSLog(@"Error: %@", error.description);
    } else {
        NSString *placeholder = [[NBPhoneNumberUtil sharedInstance] format:exampleNumber
                                                              numberFormat:NBEPhoneNumberFormatNATIONAL
                                                                     error:&error];
        if (!error) {
            self.phoneNumberField.placeholder = placeholder;
        }
    }
    
    void (^confirm)() = ^{
        [self.phoneNumberField resignFirstResponder];
        [self performSegueWithIdentifier:@"EnterCodeSegue" sender:nil];
    };
    
    void (^next)(id sender) = ^(id sender) {
        
        NSString *formattedNumber = [NumberFormatter formattedNumberInInternationalFormatFromNumber:self.phoneNumberField.text];
        
        if (formattedNumber) {
            UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:formattedNumber
                                                            message:NSLocalizedString(@"Verify Number message", nil)];
            [alert bk_setCancelButtonWithTitle:NSLocalizedString(@"Let me edit it", nil) handler:nil];
            [alert bk_addButtonWithTitle:NSLocalizedString(@"Yes, it's okay", nil) handler:confirm];
            [alert show];
        } else {
            UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:NSLocalizedString(@"Number Validation title", nil)
                                                            message:NSLocalizedString(@"Number Validation message", nil)];
            [alert bk_setCancelButtonWithTitle:NSLocalizedString(@"Okay, I'll correct it", nil) handler:nil];
            [alert show];
        }
        
    };
    
    self.navigationItem.rightBarButtonItem = ({
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] bk_initWithTitle:NSLocalizedString(@"Next", nil)
                                                                          style:UIBarButtonItemStylePlain
                                                                        handler:next];
        buttonItem.enabled = NO;
        buttonItem;
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark - Getter

- (NBAsYouTypeFormatter *)formatter {
    if (!_formatter) {
        NSString *regionCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
        _formatter = [[NBAsYouTypeFormatter alloc] initWithRegionCode:regionCode];
    }
    return _formatter;
}

#pragma mark - Text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        textField.text = [self.formatter removeLastDigit];
    } else {
        textField.text = [self.formatter inputDigit:string];
    }
    self.navigationItem.rightBarButtonItem.enabled = ![textField.text isEqualToString:@""];
    return NO;
}

@end
