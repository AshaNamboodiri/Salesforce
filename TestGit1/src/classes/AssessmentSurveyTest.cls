@isTest
private class AssessmentSurveyTest {
    
    @isTest static void test_AssessmentSurvey() {

        Account acc = new Account();
        acc.name = 'Test Account';
        acc.billingstreet = 'test street';
        acc.billingcity = 'test city';
        acc.billingcountry = 'india';
        insert acc;

        Opportunity testOpp = new Opportunity(Name='Test Opp',StageName='Qualification',CloseDate=Date.Today());
        testOpp.AccountId=acc.id;
        insert testOpp;
        

        Group__c pgrp = new Group__c();
        pgrp.Group_Name__c = 'Test Group';      
        insert pgrp;

        Group__c cgrp = new Group__c();
        cgrp.Group_Name__c = 'Test Group';      
        insert cgrp;
        Group__c cgrp1 = new Group__c();
        cgrp1.Group_Name__c = 'Test Group';     
        insert cgrp1;

        Groups_Line_Item__c itemObj = new Groups_Line_Item__c();
        itemObj.Parent_Group_ID__c=pgrp.id;
        itemObj.Child_Group_ID__c=cgrp.id;
        itemObj.Location__c='Germany';
        itemObj.LOB__c='Advisory';
        itemObj.Assessment_Type__c = 'Engagement Assessment';
        insert itemObj;

        Groups_Line_Item__c itemObj1 = new Groups_Line_Item__c();
        itemObj1.Parent_Group_ID__c=cgrp.id;
        itemObj1.Child_Group_ID__c=cgrp1.id;
        itemObj1.Location__c='Germany';
        itemObj1.LOB__c='Advisory';
        itemObj1.Assessment_Type__c = 'Engagement Assessment';
        insert itemObj1;

        Question__c qobj1= new Question__c(Question__c='question 1',Type__c='Single Select--Vertical',Group_ID__c=pgrp.id,Choices__c='Yes/nNo');
        insert qobj1;
        Question__c qobj2= new Question__c(Question__c='question 2',Type__c='Single Select--Horizontal',Group_ID__c=cgrp.id,Choices__c='Yes/nNo');
        insert qobj2;
        Question__c qobj3= new Question__c(Question__c='question 3',Type__c='Free Text',Group_ID__c=cgrp1.id);
        insert qobj3;
        Question__c qobj4= new Question__c(Question__c='question 4',Type__c='Attachment',Group_ID__c=pgrp.id);
        insert qobj4;

        //Assessmentgroup__c agObj = new Assessmentgroup__c(Account__c=acc.id,Assessment_Type__c='Client Acceptance',Groups_ID__c=cgrp.id,Is_Active__c=true,Opportunity__c=testOpp.id);
        //insert agObj;

        //Question_Response__c qresObj= new Question_Response__c(Account_ID__c=acc.id,Answer__c='ans',Groups__c=pgrp.id,Opportunity_ID__c=testOpp.id,Question_ID__c=qobj1.id,Assess_Grp_ID__c=agObj.id);
        //insert qresObj;

        //Question_Response__c qresObj1= new Question_Response__c(Account_ID__c=acc.id,Answer__c='ans',Groups__c=cgrp.id,Opportunity_ID__c=testOpp.id,Question_ID__c=qobj2.id,Assess_Grp_ID__c=agObj.id);
        //insert qresObj1;

        //Question_Response__c qresObj2= new Question_Response__c(Account_ID__c=acc.id,Answer__c='ans',Groups__c=cgrp1.id,Opportunity_ID__c=testOpp.id,Question_ID__c=qobj3.id,Assess_Grp_ID__c=agObj.id);
        //insert qresObj2;
        

        ApexPages.currentPage().getParameters().put('oppId',testOpp.id);
        ApexPages.currentPage().getParameters().put('aId',acc.id);
        ApexPages.currentPage().getParameters().put('assessType','Engagement Assessment');
        ApexPages.currentPage().getParameters().put('location','Germany');
        ApexPages.currentPage().getParameters().put('lob','Advisory');


          
    AssessmentSurvey asurveyctr= new AssessmentSurvey();
    asurveyctr.init();
    asurveyctr.nextButton();
    asurveyctr.previousButton();
    asurveyctr.saveButton();
    asurveyctr.SubmitButton();

}
     
    @isTest static void test_AssessmentSurvey1() {


        Account acc = new Account();
        acc.name = 'Test Account';
        acc.billingstreet = 'test street';
        acc.billingcity = 'test city';
        acc.billingcountry = 'india';
        insert acc;

        Opportunity testOpp = new Opportunity(Name='Test Opp',StageName='Qualification',CloseDate=Date.Today());
        testOpp.AccountId=acc.id;
        insert testOpp;
        
        Opportunity testOpp1 = new Opportunity(Name='Test Opp',StageName='Qualification',CloseDate=Date.Today());
        testOpp.AccountId=acc.id;
        insert testOpp1;

        Group__c pgrp = new Group__c();
        pgrp.Group_Name__c = 'Test Group';      
        insert pgrp;

        Group__c cgrp = new Group__c();
        cgrp.Group_Name__c = 'Test Group';      
        insert cgrp;
        Group__c cgrp1 = new Group__c();
        cgrp1.Group_Name__c = 'Test Group';     
        insert cgrp1;
        
        Group__c cgrp2 = new Group__c();
        cgrp2.Group_Name__c = 'Test Group';     
        insert cgrp2;

        Groups_Line_Item__c itemObj = new Groups_Line_Item__c();
        itemObj.Parent_Group_ID__c=pgrp.id;
        itemObj.Child_Group_ID__c=cgrp.id;
        itemObj.Location__c='Germany';
        itemObj.LOB__c='Advisory';
        itemObj.Answer_Pattern__c='Yes';
        itemObj.Assessment_Type__c = 'Engagement Assessment';
        insert itemObj;

        Groups_Line_Item__c itemObj1 = new Groups_Line_Item__c();
        itemObj1.Parent_Group_ID__c=cgrp.id;
        itemObj1.Child_Group_ID__c=cgrp1.id;
        itemObj1.Location__c='Germany';
        itemObj1.LOB__c='Advisory';
        itemObj1.Assessment_Type__c = 'Engagement Assessment';
        insert itemObj1;
        
        Groups_Line_Item__c itemObj2 = new Groups_Line_Item__c();
        itemObj2.Parent_Group_ID__c=pgrp.id;
        itemObj2.Child_Group_ID__c=cgrp2.id;
        itemObj2.Location__c='Germany';
        itemObj2.LOB__c='Advisory';
        itemObj2.Answer_Pattern__c='No';
        itemObj2.Assessment_Type__c = 'Engagement Assessment';
        insert itemObj2;

        Question__c qobj1= new Question__c(Question__c='question 1',Type__c='Single Select--Vertical',Group_ID__c=pgrp.id,Choices__c='Yes/nNo');
        insert qobj1;
        Question__c qobj2= new Question__c(Question__c='Revenue for the Opportunity $Opportunity.Name',Type__c='Single Select--Horizontal',Group_ID__c=cgrp.id,Choices__c='Yes/nNo');
        insert qobj2;
        Question__c qobj6= new Question__c(Question__c='Revenue for the Opportunity $Opportunity.Name',Type__c='Single Select--Vertical',Group_ID__c=cgrp.id,Choices__c='Yes/nNo');
        insert qobj6;
        Question__c qobj3= new Question__c(Question__c='Mention the opportunitues of the Account $Account.Name',Type__c='Free Text',Group_ID__c=cgrp1.id);
        insert qobj3;
        Question__c qobj7= new Question__c(Question__c='Revenue for the Opportunity $Opportunity.Name',Type__c='Free Text',Group_ID__c=cgrp1.id);
        insert qobj7;
        Question__c qobj4= new Question__c(Question__c='question 4',Type__c='Attachment',Group_ID__c=cgrp1.id);
        insert qobj4;
        Question__c qobj5= new Question__c(Question__c='question 5',Type__c='Free Text',Group_ID__c=cgrp2.id);
        insert qobj5;

        Assessmentgroup__c agObj = new Assessmentgroup__c(Account__c=acc.id,Assessment_Type__c='Engagement Assessment',Groups_ID__c=cgrp.id,Is_Active__c=true,Opportunity__c=testOpp.id);
        insert agObj;

        Question_Response__c qresObj= new Question_Response__c(Account_ID__c=acc.id,Answer__c='1',Groups__c=pgrp.id,Opportunity_ID__c=testOpp.id,Question_ID__c=qobj1.id,Assess_Grp_ID__c=agObj.id);
        insert qresObj;

        Question_Response__c qresObj1= new Question_Response__c(Account_ID__c=acc.id,Answer__c='',Groups__c=cgrp.id,Opportunity_ID__c=testOpp.id,Question_ID__c=qobj2.id,Assess_Grp_ID__c=agObj.id);
        insert qresObj1;

        Question_Response__c qresObj2= new Question_Response__c(Account_ID__c=acc.id,Answer__c='One',Groups__c=cgrp1.id,Opportunity_ID__c=testOpp.id,Question_ID__c=qobj3.id,Assess_Grp_ID__c=agObj.id);
        insert qresObj2;
        
        Assessmentgroup__c agObj1 = new Assessmentgroup__c(Account__c=acc.id,Assessment_Type__c='Engagement Assessment',Groups_ID__c=cgrp2.id,Is_Active__c=true,Opportunity__c=testOpp1.id);
        insert agObj1;
        
        Question_Response__c qresObj3= new Question_Response__c(Account_ID__c=acc.id,Answer__c='2',Groups__c=pgrp.id,Opportunity_ID__c=testOpp1.id,Question_ID__c=qobj1.id,Assess_Grp_ID__c=agObj1.id);
        insert qresObj3;
        
        Question_Response__c qresObj4= new Question_Response__c(Account_ID__c=acc.id,Answer__c='One',Groups__c=cgrp2.id,Opportunity_ID__c=testOpp1.id,Question_ID__c=qobj5.id,Assess_Grp_ID__c=agObj1.id);
        insert qresObj4;

        ApexPages.currentPage().getParameters().put('oppId',testOpp.id);
        ApexPages.currentPage().getParameters().put('aId',acc.id);
        ApexPages.currentPage().getParameters().put('assessType','Engagement Assessment');
        ApexPages.currentPage().getParameters().put('location','Germany');
        ApexPages.currentPage().getParameters().put('lob','Advisory');


          
    AssessmentSurvey asurveyctr= new AssessmentSurvey();
    asurveyctr.init();
    asurveyctr.nextButton();
    asurveyctr.previousButton();
    asurveyctr.saveButton();
    asurveyctr.SubmitButton();
    }
    
    @isTest static void test_AssessmentSurvey2() {

    Account acc = new Account();
        acc.name = 'Test Account';
        acc.billingstreet = 'test street';
        acc.billingcity = 'test city';
        acc.billingcountry = 'india';
        insert acc;

        Opportunity testOpp = new Opportunity(Name='Test Opp',StageName='Qualification',CloseDate=Date.Today());
        testOpp.AccountId=acc.id;
        insert testOpp;
        

        Group__c pgrp = new Group__c();
        pgrp.Group_Name__c = 'Test Group';      
        insert pgrp;

        Group__c cgrp = new Group__c();
        cgrp.Group_Name__c = 'Test Group';      
        insert cgrp;
        Group__c cgrp1 = new Group__c();
        cgrp1.Group_Name__c = 'Test Group';     
        insert cgrp1;

        Groups_Line_Item__c itemObj = new Groups_Line_Item__c();
        itemObj.Parent_Group_ID__c=pgrp.id;
        itemObj.Child_Group_ID__c=cgrp.id;
        itemObj.Location__c='Germany';
        itemObj.LOB__c='Advisory';
        itemObj.Assessment_Type__c = 'Client Acceptance';
        insert itemObj;

        Groups_Line_Item__c itemObj1 = new Groups_Line_Item__c();
        itemObj1.Parent_Group_ID__c=cgrp.id;
        itemObj1.Child_Group_ID__c=cgrp1.id;
        itemObj1.Location__c='Germany';
        itemObj1.LOB__c='Advisory';
        itemObj1.Assessment_Type__c = 'Client Acceptance';
        insert itemObj1;

        Question__c qobj1= new Question__c(Question__c='question 1',Type__c='Single Select--Vertical',Group_ID__c=pgrp.id,Choices__c='Yes/nNo');
        insert qobj1;
        Question__c qobj2= new Question__c(Question__c='question 2',Type__c='Single Select--Vertical',Group_ID__c=cgrp.id,Choices__c='Yes/nNo');
        insert qobj2;
        Question__c qobj3= new Question__c(Question__c='question 3',Type__c='Attachment',Group_ID__c=cgrp1.id);
        insert qobj3;
 

        Assessmentgroup__c agObj = new Assessmentgroup__c(Account__c=acc.id,Assessment_Type__c='Client Acceptance',Groups_ID__c=cgrp.id,Is_Active__c=true,Opportunity__c=testOpp.id);
        insert agObj;

        Question_Response__c qresObj= new Question_Response__c(Account_ID__c=acc.id,Answer__c='',Groups__c=pgrp.id,Opportunity_ID__c=testOpp.id,Question_ID__c=qobj1.id,Assess_Grp_ID__c=agObj.id);
        insert qresObj;

        Question_Response__c qresObj1= new Question_Response__c(Account_ID__c=acc.id,Answer__c='',Groups__c=cgrp.id,Opportunity_ID__c=testOpp.id,Question_ID__c=qobj2.id,Assess_Grp_ID__c=agObj.id);
        insert qresObj1;

        Question_Response__c qresObj2= new Question_Response__c(Account_ID__c=acc.id,Answer__c='',Groups__c=cgrp1.id,Opportunity_ID__c=testOpp.id,Question_ID__c=qobj3.id,Assess_Grp_ID__c=agObj.id);
        insert qresObj2;
        

        ApexPages.currentPage().getParameters().put('oppId',testOpp.id);
        ApexPages.currentPage().getParameters().put('aId',acc.id);
        ApexPages.currentPage().getParameters().put('assessType','Client Acceptance');
        ApexPages.currentPage().getParameters().put('location','Germany');
        ApexPages.currentPage().getParameters().put('lob','Advisory');


          
    AssessmentSurvey asurveyctr= new AssessmentSurvey();
    asurveyctr.init();
    asurveyctr.nextButton();
    asurveyctr.previousButton();
    asurveyctr.saveButton();
    asurveyctr.SubmitButton();


}

}