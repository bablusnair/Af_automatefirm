//
//  leaveDocumentsClass.m
//  Automate Firm
//
//  Created by leonine on 11/20/15.
//  Copyright © 2015 leonine. All rights reserved.
//

#import "leaveDocumentsClass.h"
#import "documentInnerViewClass.h"
#import "settingsViewController.h"
#import "documentationSettingsViewClass.h"
@implementation leaveDocumentsClass

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    
    self.myconnection=[[connectionclass alloc]init];
    self.myconnection.mydelegate=self;
    
   // [[NSUserDefaults standardUserDefaults]setObject:@"advance" forKey:@"accordianAction"];
    
    
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    app.conditionID=@"0";
    app.conditionCount=0;
    [app.conditionIDArray removeAllObjects];
    app.designationFlag=0;
    app.warningflag=0;
    app.designationFlag1=app.designationFlag2=app.designationFlag3=app.designationFlag4=app.designationFlag5=0;
    app.specificEmployeeFlag1=app.specificEmployeeFlag2=app.specificEmployeeFlag3=app.specificEmployeeFlag4=app.specificEmployeeFlag5=0;
    
    self.alertFlag=@"0";
    
    app.ruleID=[[NSUserDefaults standardUserDefaults]objectForKey:@"leaveID"];
    [self.myconnection individualProtocolRuleView:[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedofficeId"] :app.ruleID :@"leave"];
    
    
}

-(void)willRemoveSubview:(UIView *)subview
{
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"popupAction"]isEqualToString:@"employee"]) {
        NSMutableArray *selectedEmployeeArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedEmployee"];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectedEmployee"];
        
        NSData *imageData=[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedEmployeeIcon"];
        for (documentInnerViewClass *myView in accordion.scrollView.subviews) {
            if ([myView isKindOfClass:[documentInnerViewClass class]]) {
                
                [myView specificEmployee:selectedEmployeeArray :  imageData];
            }
        }
    }
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"popupAction"]isEqualToString:@"includedesignation"])
    {
        NSMutableArray *selectedDeignationArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"selected_emp"];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selected_emp"];
        
        NSLog(@"%@",self.subviews);
        for (documentInnerViewClass *myView in accordion.scrollView.subviews) {
            if ([myView isKindOfClass:[documentInnerViewClass class]]) {
                
                [myView collectionViewReload:selectedDeignationArray];
            }
        }
    }
    else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"popupAction"]isEqualToString:@"designation"])
    {
        NSMutableArray *selectedDesignationArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedDesig"];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectedDesig"];
        
        for (documentInnerViewClass *myView in accordion.scrollView.subviews) {
            if ([myView isKindOfClass:[documentInnerViewClass class]]) {
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
        
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"paperworkAction"]isEqualToString:@"update"])
        {
            [mydict setObject:@"1" forKey:@"status"];
        }
        else
        {
            [mydict setObject:@"0" forKey:@"status"];
        }
        
        [self.myconnection savePaperworkRule:app.ruleID :@"leave" :mydict];
    }
    else
    {
        self.alertFlag=@"1";
        [self showalerviewcontroller:@"Must Save Atleast One Protocol"];
    }
    
    
}
-(IBAction)cancelButtonAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enableDocumentsCollectionView" object:Nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enabletable" object:Nil];
    [self removeFromSuperview];
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
        
        NSMutableDictionary *leaveDetailsDict=[[responseData objectForKey:@"rule_details"]objectAtIndex:0];
        
        
        if ([leaveDetailsDict objectForKey:@"declaration_type"]!=(id)[NSNull null]) {
            if ([[leaveDetailsDict objectForKey:@"declaration_type"]isEqualToString:@"leave"])
            {
                if ([leaveDetailsDict objectForKey:@"declaration_msg"]!=(id)[NSNull null]) {
                    if ([[leaveDetailsDict objectForKey:@"declaration_msg"] isEqualToString:@" "]) {
                        self.declarationText.text=@"Declaration Message";
                    }
                    else
                    {
                        self.declarationText.text=[leaveDetailsDict objectForKey:@"declaration_msg"];
                    }
                    
                }
                else
                {
                    self.declarationText.text=@"Declaration Message";
                }
                
            }
            
        }
        
        
        self.leaveTypeLabel=[leaveDetailsDict objectForKey:@"rule_abbrv"];
        self.leaveNameLabel.text=[NSString stringWithFormat:@"%@ (%@)",[leaveDetailsDict objectForKey:@"rule_name"],self.leaveTypeLabel];
        if ([self.leaveTypeLabel isEqualToString:@"MTRN"]) {
            self.declarationView.hidden=false;
        }
        else
        {
            self.declarationView.hidden=true;
            
        }
        if ([leaveDetailsDict objectForKey:@"modified_date"]!=(id)[NSNull null]) {
            
            self.modifiedDate=[leaveDetailsDict objectForKey:@"modified_date"];
        }
        else
        {
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
            if ([self.leaveTypeLabel isEqualToString:@"MTRN"]) {
                accordion = [[DocumentTile alloc] initWithFrame:CGRectMake(22, 152, 602, 465)];
                self.plusButton.frame=CGRectMake(self.plusButton.frame.origin.x, 116, self.plusButton.frame.size.width, self.plusButton.frame.size.height);
            }
            else
            {
                accordion = [[DocumentTile alloc] initWithFrame:CGRectMake(22, 96, 602, 465)];
                self.plusButton.frame=CGRectMake(self.plusButton.frame.origin.x, 58, self.plusButton.frame.size.width, self.plusButton.frame.size.height);
            }
            [self.scrollView addSubview:accordion];
            
            
            app.conditionCount=arrayCount;
            DocumentTile *myobj = (DocumentTile *)[self.scrollView.subviews lastObject];
            [myobj CreationoftileforUpdation:arrayCount];

            
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"create" forKey:@"paperworkAction"];
            self.plusButton.hidden=true
            ;
            if ([self.leaveTypeLabel isEqualToString:@"MTRN"]) {
                accordion = [[DocumentTile alloc] initWithFrame:CGRectMake(22, 116, 602, 465)];
            }
            else
            {
                accordion = [[DocumentTile alloc] initWithFrame:CGRectMake(22, 58, 602, 465)];
            }
            [app.conditionIDArray addObject:@"0"];
            [self.scrollView addSubview:accordion];
        }
        
        
        
        
    });
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

-(IBAction)plusButtonAction:(id)sender
{
    if ([app.conditionIDArray.lastObject isEqualToString:@"0"]) {
        [self showalerviewcontroller:@"Can't make an empty Condition"];
    }
    else
    {
        NSInteger count=app.conditionIDArray.count;
        int arrayCount= (int)count;
        
        DocumentTile *myobj = (DocumentTile *)[self.scrollView.subviews lastObject];
        [myobj addNewTileForUpdation:arrayCount];
    }
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
-(void)showalerviewcontroller:(NSString *)errorMessage
{
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Warning"
                               message:[NSString stringWithFormat:@"%@",errorMessage]
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   if ([self.alertFlag isEqualToString:@"1"]) {
                                                       [app.conditionIDArray addObject:@"0"];
                                                       self.alertFlag=@"0";
                                                   }
                                                   
                                               }];
    [alert addAction:ok];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@",self.superview.superview.superview.superview);
        
        [(settingsViewController *)[self.superview.superview.superview.superview nextResponder] presentViewController:alert animated:YES completion:nil];
    });
}

@end
