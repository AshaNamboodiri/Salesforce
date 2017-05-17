global with sharing class SurveyGroupsController {
  
  public String surveyDelete                       {get; set;}
  public String newSurveyGroupName                      {get; set;}
  public List<miniSurveyGroup>allSurveyGroups                {get; set;}
  public String username                           {get; set;}
  public String userId                             {get; set;}
  public String surveyAssessmentType                         {get; set;}
  public List<Selectoption>  surveyAssessmentTypePicklist         {get; set;} 
  
  public SurveyGroupsController(ApexPages.StandardController stdController){
    username = System.Userinfo.getUserId();    
    setAllSurveyGroups();
    setupSurveyAssessmentTypePicklist();            
  }
     
  private void setupSurveyAssessmentTypePicklist(){
      surveyAssessmentTypePicklist = new List<Selectoption>();
      surveyAssessmentTypePicklist.add(new Selectoption('Client Acceptance','Client Acceptance'));
      surveyAssessmentTypePicklist.add(new Selectoption('Independence Acceptance','Independence Acceptance'));
      surveyAssessmentTypePicklist.add(new Selectoption('Engagement Acceptance','Engagement Acceptance'));
  }

  private void setAllSurveyGroups(){
   //List<Survey__c> surveys = [Select Id, Name from Survey__c where IsDeleted = false order by Name];
   List<Group__c> groups = [Select id, Group_Name__c, Total_Questions__c From Group__c order by Group_Name__c];
   if(allSurveyGroups == null){
      allSurveyGroups = new List<miniSurveyGroup>();
    }
   else{
      allSurveyGroups.clear(); 
    }
   for(Group__c grp : groups){
      allSurveyGroups.add(new miniSurveyGroup(grp.Group_Name__c, grp.Id, grp.Total_Questions__c));
    }
  }
  
  public Pagereference makeNewSurveyGroup(){   
    if(newSurveyGroupName==null){
     
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.LABS_SF_Survey_Name_Is_Required));
     return null;
    }
    
    Group__c gp = new Group__c();
    gp.Group_Name__c = newSurveyGroupName;
    gp.Assessment_type__c = surveyAssessmentType;   
    
    try{
     insert gp;     
     return new Pagereference('/apex/GroupManagerPage?id='+gp.Id);
    }catch(Exception e){
      return null;
    }
  }
 
  public Pagereference doSurveyReset(){
    setAllSurveyGroups();
    return null;
  }
  
  public static webservice String deleteSurveyGroup(String deleteId){    
    Group__c grp = [Select id,Group_Name__c from Group__c where id =:deleteId];
    delete grp;
    
    return 'true';
  }
 
  public Class miniSurveyGroup{
    public String sgrpName {get; set;}
    public String sgrpId   {get; set;}
    public Decimal sgrpQuesTotal   {get;set;}
    
    public miniSurveyGroup(String miniName, String miniId, Decimal miniQuesTotal){
      sgrpName = miniName;
      sgrpId = miniId;
      sgrpQuesTotal = miniQuesTotal;
    } 
      
  }
}