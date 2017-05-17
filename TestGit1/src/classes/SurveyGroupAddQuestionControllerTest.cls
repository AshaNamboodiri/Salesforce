@isTest(SeeAllData=true)
private class SurveyGroupAddQuestionControllerTest {
	@isTest static void testMyController(){
		Group__c grp = new Group__c();
		grp.Group_Name__c = 'Test Group';		
		insert grp;
		
		Question__c ques = new Question__c();		
		ques.Group_ID__c = grp.id;
		ques.Question__c = 'test question';
		ques.Required__c = true;
		ques.Type__c = 'Free Text';
		ques.OrderNumber__c = 0;
		insert ques;

		Question__c ques2 = new Question__c();		
		ques2.Group_ID__c = grp.id;
		ques2.Question__c = 'test question';
		ques2.Required__c = true;
		ques2.Type__c = 'Single Select--Horizontal';
		ques2.Choices__c = 'Yes\nNo';
		ques2.OrderNumber__c = 1;		
		insert ques2;

		Question__c ques4 = new Question__c();		
		ques4.Group_ID__c = grp.id;
		ques4.Question__c = 'test question';
		ques4.Required__c = true;
		ques4.Type__c = 'Single Select--Vertical';
		ques4.Choices__c = 'Yes\nNo';
		ques4.OrderNumber__c = 1;		
		insert ques4;

		Question__c ques3 = new Question__c();		
		ques3.Group_ID__c = grp.id;
		ques3.Question__c = 'test question';
		ques3.Required__c = true;
		ques3.Type__c = 'Multi-Select--Vertical';
		ques3.Choices__c = 'Yes\nNo';
		ques3.OrderNumber__c = 1;		
		insert ques3;

		ApexPages.currentPage().getParameters().put('id',grp.id);
		ApexPages.currentPage().getParameters().put('caId','');		

	    ApexPages.StandardController stdGroup = new ApexPages.StandardController(grp);
	    SurveyGroupAddQuestionController objGroupController = new SurveyGroupAddQuestionController(stdGroup);
	    objGroupController.makeNewQuestionLink();
	    objGroupController.questionReference = ques.id;
	    objGroupController.editQuestion();
	    objGroupController.addQuestion();	    
	    objGroupController.controllerSavQuestion();
	    objGroupController.previewQuestion();
	    objGroupController.updateGroupName();
	    objGroupController.newOrderW = ''+ques.id+',';	    
	    objGroupController.updateOrderList();
	    objGroupController.refreshQuestionList();
	    objGroupController.resultPage();
	    objGroupController.deleteRefresh();
	    objGroupController.questionReference = '';
	    objGroupController.saveAndNewQuestion();
	}
	
}