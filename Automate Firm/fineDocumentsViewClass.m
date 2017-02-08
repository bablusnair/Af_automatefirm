//
//  fineDocumentsViewClass.m
//  Automate Firm
//
//  Created by Ambu Vamadevan on 29/04/2016.
//  Copyright © 2016 leonine. All rights reserved.
//

#import "fineDocumentsViewClass.h"
#import "fineInnerViewClass.h"
#import "settingsViewController.h"
@implementation fineDocumentsViewClass

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
    
    
    app.ruleID=[[NSUserDefaults standardUserDefaults]objectForKey:@"fineID"];
    [self.myconnection individualProtocolRuleView:[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedofficeId"] :app.ruleID :@"fine"];
    
}

-(void)willRemoveSubview:(UIView *)subview
{
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"popupAction"]isEqualToString:@"employee"]) {
        NSMutableArray *selectedEmployeeArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedEmployee"];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectedEmployee"];
        
        NSData *imageData=[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedEmployeeIcon"];
        for (fineInnerViewClass *myView in accordion.scrollView.subviews) {
            if ([myView isKindOfClass:[fineInnerViewClass class]]) {
                
                [myView specificEmployee:selectedEmployeeArray :  imageData];
            }
        }
    }
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"popupAction"]isEqualToString:@"includedesignation"])
    {
        NSMutableArray *selectedDeignationArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"selected_emp"];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selected_emp"];
        
        NSLog(@"%@",self.subviews);
        for (fineInnerViewClass *myView in accordion.scrollView.subviews) {
            if ([myView isKindOfClass:[fineInnerViewClass class]]) {
                
                [myView collectionViewReload:selectedDeignationArray];
            }
        }
    }
    else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"popupAction"]isEqualToString:@"designation"])
    {
        NSMutableArray *selectedDesignationArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedDesig"];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectedDesig"];
        
        for (fineInnerViewClass *myView in accordion.scrollView.subviews) {
            if ([myView isKindOfClass:[fineInnerViewClass class]]) {
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enableDocumentsCollectionView" object:Nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enabletable" object:Nil];
    [self removeFromSuperview];
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
-(void)serviceGotResponse:(id)responseData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"%@",responseData);
        
        NSMutableDictionary *fineDetailsDict=[[responseData objectForKey:@"rule_details"]objectAtIndex:0];
        
        self.fineNameLabel.text=[fineDetailsDict objectForKey:@"rule_name"];
        
        if ([fineDetailsDict objectForKey:@"modified_date"]!=(id)[NSNull null]) {
            
            [[NSUserDefaults standardUserDefaults]setObject:[fineDetailsDict objectForKey:@"modified_date"] forKey:@"modified_date"];
            self.modifiedDate=[fineDetailsDict objectForKey:@"modified_date"];
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
            
            accordion = [[fineDocumentTile alloc] initWithFrame:CGRectMake(22, 96, 602, 465)];
            [self.scrollView addSubview:accordion];
            
            app.conditionCount=arrayCount;
            fineDocumentTile *myobj = (fineDocumentTile *)[self.scrollView.subviews lastObject];
            [myobj CreationoftileforUpdation:arrayCount];
            
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"create" forKey:@"paperworkAction"];
            self.plusButton.hidden=true;
            
            accordion = [[fineDocumentTile alloc] initWithFrame:CGRectMake(22, 58,602, 465)];
            [app.conditionIDArray addObject:@"0"];
            [self.scrollView addSubview:accordion];
        }
        
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
        
        fineDocumentTile *myobj = (fineDocumentTile *)[self.scrollView.subviews lastObject];
        [myobj addNewTileForUpdation:arrayCount];
    }
}

-(void)showalerviewcontroller:(NSString *)errorMessage
{
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Warning"
                               message:[NSString stringWithFormat:@"%@",errorMessage]
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   
                                                   
                                               }];
    [alert addAction:ok];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@",self.superview.superview.superview.superview);
        
        [(settingsViewController *)[self.superview.superview.superview.superview nextResponder] presentViewController:alert animated:YES completion:nil];
    });
}

@end
