@isTest
private class SurveyGroupsControllerTest {

	@isTest static void testMyController(){
		Group__c grp = new Group__c();
		grp.Group_Name__c = 'Test Group';		
		insert grp;
		
	    ApexPages.StandardController stdGroup = new ApexPages.StandardController(grp);
	    SurveyGroupsController objGroupController = new SurveyGroupsController(stdGroup);

	    objGroupController.makeNewSurveyGroup();
	    objGroupController.newSurveyGroupName = 'Test Group2';
	    objGroupController.makeNewSurveyGroup();
	    objGroupController.doSurveyReset();
	    SurveyGroupsController.deleteSurveyGroup(grp.id);
	    
	}
}