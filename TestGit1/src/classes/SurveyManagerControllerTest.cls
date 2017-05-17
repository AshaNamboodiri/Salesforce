@isTest
private class SurveyManagerControllerTest {
	
	@isTest static void testMyController() {
		Survey__c srv = new Survey__c();
		srv.Name = 'Test Survey';	
		srv.Submit_Response__c = 'Yes\nNo';	
		insert srv;
		
	    ApexPages.StandardController stdSurvey = new ApexPages.StandardController(srv);
	    SurveyManagerController objSurveyController = new SurveyManagerController(stdSurvey);
	    objSurveyController.getEditCSS();
	}
	
	
	
}