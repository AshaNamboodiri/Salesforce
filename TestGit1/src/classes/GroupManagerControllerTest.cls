@isTest
private class GroupManagerControllerTest {
	@isTest static void testMyController(){
		Group__c grp = new Group__c();
		grp.Group_Name__c = 'Test Group';		
		insert grp;
		
	    ApexPages.StandardController stdGroup = new ApexPages.StandardController(grp);
	    GroupManagerController objGroupController = new GroupManagerController(stdGroup);
	    objGroupController.getEditCSS();
	}
	
}