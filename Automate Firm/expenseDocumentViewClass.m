//
//  expenseDocumentViewClass.m
//  Automate Firm
//
//  Created by Ambu Vamadevan on 29/04/2016.
//  Copyright © 2016 leonine. All rights reserved.
//

#import "expenseDocumentViewClass.h"
#import "expenseInnerViewClass.h"
#import "settingsViewController.h"
#import "documentationSettingsViewClass.h"

@implementation expenseDocumentViewClass

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.myconnection=[[connectionclass alloc]init];
    self.myconnection.mydelegate=self;
    
    
    
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    app.conditionID=@"0";
    app.conditionCount=0;
    [app.conditionIDArray removeAllObjects];
    app.warningflag=0;
    app.designationFlag=0;
    app.designationFlag1=app.designationFlag2=app.designationFlag3=app.designationFlag4=app.designationFlag5=0;
    app.specificEmployeeFlag1=app.specificEmployeeFlag2=app.specificEmployeeFlag3=app.specificEmployeeFlag4=app.specificEmployeeFlag5=0;
    
    self.alertFlag=0;
    
    app.ruleID=[[NSUserDefaults standardUserDefaults]objectForKey:@"expenseID"];
    [self.myconnection individualProtocolRuleView:[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedofficeId"] :app.ruleID :@"expense"];
}

-(void)willRemoveSubview:(UIView *)subview
{
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"popupAction"]isEqualToString:@"employee"]) {
        NSMutableArray *selectedEmployeeArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedEmployee"];
        NSData *imageData=[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedEmployeeIcon"];
        for (expenseInnerViewClass *myView in accordion.scrollView.subviews) {
            if ([myView isKindOfClass:[expenseInnerViewClass class]]) {
                
                [myView specificEmployee:selectedEmployeeArray :  imageData];
            }
        }
    }
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"popupAction"]isEqualToString:@"includedesignation"])
    {
        NSMutableArray *selectedDeignationArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"selected_emp"];
        for (expenseInnerViewClass *myView in accordion.scrollView.subviews) {
            if ([myView isKindOfClass:[expenseInnerViewClass class]]) {
                
                [myView collectionViewReload:selectedDeignationArray];
            }
        }
    }
    else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"popupAction"]isEqualToString:@"designation"])
    {
        NSMutableArray *selectedDesignationArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedDesig"];
        for (expenseInnerViewClass *myView in accordion.scrollView.subviews) {
            if ([myView isKindOfClass:[expenseInnerViewClass class]]) {
                [myView assignDesignation:selectedDesignationArray];
            }
        }
    }
    else
    {
        
    }
}
-(IBAction)doneButtonAction:(id)sender
{
    [app.conditionIDArray removeObject:@"0"];
    if (app.conditionIDArray.count > 0) {
        
        if ([self.declarationText.text isEqualToString:@"Declaration Message"]) {
            self.declarationText.text=@"";
        }
        
        NSMutableDictionary *mydict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.declarationText.text,@"decalaration_msg", nil];
    
        [self.myconnection savePaperworkRule:app.ruleID :@"expense" :mydict];
    }
    else
    {
        self.alertFlag=1;
        [self showalerviewcontroller:@"Must Save Atleast One Protocol"];
    }
    
    
    
}
-(IBAction)cancelButtonAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enableDocumentsCollectionView" object:Nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enabletable" object:Nil];
    [self removeFromSuperview];
}
-(void)enable
{
    self.plusButton.enabled=YES;
    self.doneButton.enabled=YES;
    self.cancelButton.enabled=YES;
}
-(void)disable
{
    self.plusButton.enabled=NO;
    self.doneButton.enabled=NO;
    self.cancelButton.enabled=NO;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [[NSUserDefaults standardUserDefaults]setObject:@"keyboardEnable" forKey:@"keyboardAction"];
    
    if ([self.declarationText.text isEqualToString:@"Declaration Message"]) {
        self.declarationText.text=@"";
    }
    self.declarationText.textColor=[UIColor blackColor];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"keyboardAction"];
    if (!(self.declarationText.text.length > 0 )) {
        self.declarationText.text=@"Declaration Message";
        self.declarationText.textColor=[UIColor lightGrayColor];
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView==self.declarationText) {
        if ([text isEqualToString:@""]) {
            return YES;
        }
        if (textView.text.length<=174) {
            NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()_+:<>;,./?'|\" "];
            unichar u = [text characterAtIndex:0];
            if ([myCharSet characterIsMember:u])
            {
                return YES;
            }
            else{
                return NO;
            }
            
        }
        else
            return NO;
    }
    else
    {
        return YES;
    }
}
-(void)serviceGotResponse:(id)responseData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"%@",responseData);
        
        NSMutableDictionary *expenseDetailsDict=[[responseData objectForKey:@"rule_details"]objectAtIndex:0];
        
        if ([expenseDetailsDict objectForKey:@"declaration_type"]!=(id)[NSNull null]) {
            if ([[expenseDetailsDict objectForKey:@"declaration_type"]isEqualToString:@"expense"])
            {
                if ([expenseDetailsDict objectForKey:@"declaration_msg"]!=(id)[NSNull null]) {
                    
                    if ([[expenseDetailsDict objectForKey:@"declaration_msg"]isEqualToString:@" "])
                    {
                        self.declarationText.text=@"Declaration Message";
                    }
                    else
                    {
                        self.declarationText.text=[expenseDetailsDict objectForKey:@"declaration_msg"];
                    }
                }
                else
                    self.declarationText.text=@"Declaration Message";
            }
        }
        
        
        
        self.expenseLabel.text=[NSString stringWithFormat:@"%@(%@)",[expenseDetailsDict objectForKey:@"rule_name"],[expenseDetailsDict objectForKey:@"rule_abbrv"]];
        
        if ([expenseDetailsDict objectForKey:@"modified_date"]!=(id)[NSNull null]) {
            
            [[NSUserDefaults standardUserDefaults]setObject:[expenseDetailsDict objectForKey:@"modified_date"] forKey:@"modified_date"];
            self.modifiedDate=[expenseDetailsDict objectForKey:@"modified_date"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"modified_date"];
            self.modifiedDate=@"0";
        }
        
        NSMutableArray *protocolArray=[responseData objectForKey:@"protocol_details"];
        for (int i=0; i<protocolArray.count; i++) {
            NSMutableDictionary *protocolDict=[protocolArray objectAtIndex:i];
            [app.conditionIDArray addObject:[protocolDict objectForKey:@"tile_id"]];
        }
        
        
        NSInteger count=app.conditionIDArray.count;
        int arrayCount= (int)count;
        if (arrayCount > 0) {
            
            [[NSUserDefaults standardUserDefaults]setObject:@"update" forKey:@"paperworkAction"];
            self.plusButton.hidden=false;
            
            accordion = [[expenseDocumentTile alloc] initWithFrame:CGRectMake(22, 152, 602, 465)];
            [self.scrollView addSubview:accordion];
            
            app.conditionCount=arrayCount;
            expenseDocumentTile *myobj = (expenseDocumentTile *)[self.scrollView.subviews lastObject];
            [myobj CreationoftileforUpdation:arrayCount];
            
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"create" forKey:@"paperworkAction"];
            self.plusButton.hidden=true;
            
            accordion = [[expenseDocumentTile alloc] initWithFrame:CGRectMake(22, 116
                                                                              , 602, 465)];
            [app.conditionIDArray addObject:@"0"];
            [self.scrollView addSubview:accordion];
        }
        
    });
}

-(IBAction)AddNewTile:(id)sender
{
    if ([app.conditionIDArray.lastObject isEqualToString:@"0"]) {
        [self showalerviewcontroller:@"Can't make an empty Condition"];
    }
    else
    {
        NSInteger count=app.conditionIDArray.count;
        int arrayCount= (int)count;
        
        expenseDocumentTile *myobj = (expenseDocumentTile *)[self.scrollView.subviews lastObject];
        [myobj addNewTileForUpdation:arrayCount];
    }
}

-(void)viewAllResponse:(id)responseList
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        documentationSettingsViewClass *ob = (documentationSettingsViewClass *)self.superview.superview;
        
        [ob viewAllResponse:responseList];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"enableDocumentsCollectionView" object:Nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"enabletable" object:Nil];
        
        [self removeFromSuperview];
        
        
    });
}

-(void)showalerviewcontroller:(NSString *)errorMessage
{
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Warning"
                               message:[NSString stringWithFormat:@"%@",errorMessage]
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   if (self.alertFlag==1) {
                                                       [app.conditionIDArray addObject:@"0"];
                                                       self.alertFlag=0;
                                                   }
                                                   
                                               }];
    [alert addAction:ok];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@",self.superview.superview.superview.superview);
        
        [(settingsViewController *)[self.superview.superview.superview.superview nextResponder] presentViewController:alert animated:YES completion:nil];
    });
}

@end
