//
//  EmployeDetailController.m
//  TestCoreDatadsfsdfsdf
//
//  Created by Alexander on 10.04.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "EmployeDetailController.h"
#import "CoreDataManager.h"
@import MobileCoreServices;

@interface EmployeDetailController() <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{}
@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@property (nonatomic, weak) IBOutlet UITextField *firstNameField;
@property (nonatomic, weak) IBOutlet UITextField *lastNameField;
@end

@implementation EmployeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imgView.image = self.employe.avatar;
    self.firstNameField.text = self.employe.first_name;
    self.lastNameField.text = self.employe.last_name;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.employe.first_name = self.firstNameField.text;
    self.employe.last_name = self.lastNameField.text;
    if (![self.navigationController.viewControllers containsObject:self]) {
        [self.employe.managedObjectContext save:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return false;
}

- (IBAction)avatarPressed:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Изменить фото" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = true;
        picker.mediaTypes = @[(id)kUTTypeImage];
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker animated:true completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Удалить фото" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        self.imgView.image = nil;
        self.employe.avatar = nil;
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - Image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *img = info[UIImagePickerControllerEditedImage] ?: info[UIImagePickerControllerOriginalImage];
    self.imgView.image = img;
    self.employe.avatar = img;
    [picker dismissViewControllerAnimated:true completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:true completion:nil];
}

@end
