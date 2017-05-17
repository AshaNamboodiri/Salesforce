global virtual with sharing class SurveyGroupAddQuestionController{
  
  public List<SelectOption> questionTypeOptions {get; set;}
  public String  showBasicValues                {get; set;}
  public String  showSingleSelect               {get; set;}
  public String  showSingleSelectPreview        {get; set;}
  public String  showSingleSelectAttach               {get; set;}
  public String  showSingleSelectAttachPreview        {get; set;}  
  public String  showMultiSelect                {get; set;}
  public String  showMultiSelectPreview         {get; set;}
  public String  showFreeText                   {get; set;}
  public String  showFreeTextPreview            {get; set;}
  public String  showFreeTextAttach                   {get; set;}
  public String  showFreeTextAttachPreview            {get; set;}
  public String  showRowQuestion                {get; set;}
  public String  showRowQuestionPreview         {get; set;}
  public String  showRowQuestionAttach                {get; set;}
  public String  showRowQuestionAttachPreview         {get; set;}
  public String  showAttachment                 {get; set;}
  public String  showAttachmentPreview          {get; set;}
  public String  showSystemValues               {get; set;}
  public String  showSystemValuesPreview        {get; set;}
  public String  showSelectQuestionType         {get; set;}
  public List<SelectOption> singleOptions       {get; set;}
  public List<SelectOption> singleOptionsAttach {get;set;}
  public List<SelectOption> multiOptions        {get; set;}
  public List<SelectOption> rowOptions          {get; set;}
  public String  questionReference              {get; set;}
  public String  reportId                       {get; set;}
  private Boolean saveAndNew;
  private String  groupRef;
  private String surveyOrderNumber;
  private Question__c questionToUpdate;
  /***/
  public String  qQuestion                      {get; set;}
  public Boolean qRequired                      {get; set;}
  public String  qChoices                       {get; set;}
  public String groupName                  {get; set;}
  //public String surveyHeader                {get; set;}
  public String groupId                    {get; set;} 
  //public String renderSurveyPreview         {get; set;}  
  public String questionName                {get; set;}  
  public String questionType                {get; set;}
  public Boolean questionRequired           {get; set;}
  public List<question> allQuestions        {get; set;}
  public List<String> responses             {get; set;}
  public Integer allQuestionsSize           {get; set;}
  public String  templateURL                {get; set;}
  //public String  surveyThankYouText         {get; set;}
  //public String  surveyThankYouURL          {get; set;}
  public String  caseId                     {get; set;}
    public List<String> newOrder {get;set;}
    public String newOrderW {get;set;}
  public string systemVal                {get; set;}
  
   
  public  SurveyGroupAddQuestionController (ApexPages.StandardController stdController){
     /**/
    // Get url parameters
    groupId = Apexpages.currentPage().getParameters().get('id');
    caseId   = Apexpages.currentPage().getParameters().get('caId');
    newOrder = new List<String>();
    if(caseId ==null || caseId.length()<5){
      caseId = 'none';
    }
    // By default the preview is not showing up
    //renderSurveyPreview = 'false';

    if (groupId != null){ 
      // Retrieve all necessary information to be displayed on the page
      allQuestions = new List<question>();
      //setSurveyNameAndThankYou(groupId);
    }
    /**/
    groupRef = groupId;
    setupQuestionTypeOptions();
    resetViewsToFalse(true);
    showSelectQuestionType = 'False';
    ReportFinderUtil rfu = new ReportFinderUtil();
    reportId = rfu.findReportId('Survey with Questions and Responses');
   
  }

  public Pagereference makeNewQuestionLink(){
    questionReference = null;
    resetViewsToFalse(true);
    return null;
  }
  
  public Pagereference editQuestion(){
    if (questionReference == null)
     return null;
    setupEditQuestion();
    showSelectQuestionType = 'True';
    return null;
  }
  
  public Pagereference addQuestion(){
    showSelectQuestionType = 'True';
    resetViewsToFalse(true);
    return null;
  }
  
  private void setupEditQuestion(){
    /*questionToUpdate =     [Select Type__c, Question__c, Id, Choices__c, Required__c, 
                           OrderNumber__c, Survey__c, Name
                           From Survey_Question__c 
                           where Id = :questionReference];*/

    questionToUpdate =     [Select Type__c, Question__c, Id, Choices__c, Required__c, 
                           OrderNumber__c, Group_ID__c, Name
                           From Question__c 
                           where Id = :questionReference];
                                                  
    questionType = questionToUpdate.Type__c;
    setupQuestionFields();
    setupEditFields(questionToUpdate);
  }

  private void setupEditFields(Question__c ques){
    qQuestion = ques.Question__c;
    qRequired = ques.Required__c;
    qChoices = ques.Choices__c;
    groupRef = ques.Group_ID__c;    
  }

  private void setupQuestionTypeOptions(){
  
    //get picklist values
    Schema.DescribeFieldResult fieldResult = Question__c.Type__c.getDescribe();
    List<Schema.PicklistEntry>  ple = fieldResult.getPicklistValues();
  
    //set/add them to selectOption list
    questionTypeOptions = new List<SelectOption>();
    questionTypeOptions.add(new SelectOption('--SELECT--', System.Label.LABS_SF_SELECTTYPE));
    for(Schema.PicklistEntry pe: ple){
      questionTypeOptions.add(new SelectOption(pe.getLabel(), pe.getValue()));
    }
  }

  private void resetViewsToFalse(Boolean clearFields){
    showSingleSelect =        'False';
    showSingleSelectPreview = 'False';
    showSingleSelectAttach =        'False';
    showSingleSelectAttachPreview = 'False';    
    showMultiSelect =         'False';
    showMultiSelectPreview=   'False';
    showFreeText =            'False';
    showAttachment=           'False';
    showAttachmentPreview=    'False';
    showFreeTextPreview=      'False';
    showRowQuestion=          'False';
    showRowQuestionPreview=   'False';
    showSystemValues=         'False';
    showSystemValuesPreview=  'False';
    showFreeTextAttachPreview= 'False';
    showFreeTextAttach=        'False';
    showRowQuestionAttach=      'False';
    showRowQuestionAttachPreview='False';
    qRequired =                false;
    if(clearFields){
      qChoices =                 '';
      qQuestion =                '';
      }
    }

  public Pagereference setupQuestionFields(){
    resetViewsToFalse(false);
    if(questionType=='Multi-Select--Vertical'){
     showMultiSelect='True';
    }
    else if(questionType == 'Single Select--Vertical'){
      showSingleSelect = 'True';
    }
    else if(questionType == 'Single Select--Vertical with Attachment'){
      showSingleSelectAttach = 'True';
    }
    else if(questionType == 'Free Text'){
      showFreeText = 'True';
    }
    else if(questionType == 'Free Text with Attachment'){
      showFreeTextAttach = 'True';
    }
    else if(questionType == 'Single Select--Horizontal'){
      showRowQuestion = 'True';
    }
    else if(questionType == 'Single Select--Horizontal with Attachment'){
      showRowQuestionAttach = 'True';
    }
    else if(questionType == 'Attachment'){
      showAttachment = 'True';
    }
    else if(questionType == 'System Values'){
      showSystemValues = 'True';
    }
    return null;
  }  
 
  public Pagereference saveAndNewQuestion(){
    saveAndNew = True;
    if(questionReference == null || questionReference.length() <5)
      return saveNewQuestion();
    else 
      return updateQuestion();  
  }
  
 
  
  public Pagereference controllerSavQuestion(){
    if(questionReference == null || questionReference.length() <5){
      return saveNewQuestion();
    }
    else{ 
      return updateQuestion();
    }
  }
  
 
  private Pagereference updateQuestion(){
    //questionToUpdate is setup in an earlier call to editQuestion()
    //questionToUpdate.Name = questionToName(qQuestion);
    questionToUpdate.Choices__c = qChoices;
    questionToUpdate.Required__c = qRequired;
    questionToUpdate.Type__c = questionType;
    questionToUpdate.Question__c = qQuestion;
    try{
      update questionToUpdate;
      resetViewsToFalse(true);
      //deleteOldResponses(questionToUpdate.id);
      questionReference = null;
    }catch(Exception e){
      System.debug(e);
      Apexpages.addMessages(e);
    }
    
    return saveOrUpdateReturn();
  }

  /*
  private void deleteOldResponses(String qId){
    List <SurveyQuestionResponse__c> sResponses = [select id, Survey_Question__c from SurveyQuestionResponse__c where Survey_Question__c = :qId];
    if(sResponses != null)
     delete sResponses;
  }
  */

  private Pagereference saveOrUpdateReturn(){
    setupQuestionList();
    Pagereference pr = new Pagereference('/apex/GroupAddQuestion?id='+groupRef);
    questionType = '--SELECT--';
    if(saveAndNew != null  && saveAndNew == true){
      saveAndNew = False;
      showSelectQuestionType = 'True';      
      return pr;
    }
    else{  
      showSelectQuestionType = 'False';      
      return pr; 
    }
  }

  private Integer getNewQuestionNum(){
    if(allQuestions == null)
     return 0;
    else{
     return allQuestions.size();
    }    
  }

  private Pagereference saveNewQuestion(){ 
    Question__c newQuestion = new Question__c();
    newQuestion.Group_ID__c = groupRef;
    //newQuestion.Name = questionToName(qQuestion);
    newQuestion.Choices__c = qChoices;
    newQuestion.Required__c = qRequired;
    newQuestion.Type__c = questionType;
    newQuestion.OrderNumber__c = getNewQuestionNum();
    newQuestion.Question__c = qQuestion;
    resetViewsToFalse(true);
    try{
      insert newQuestion;
    }catch(Exception e){
      System.debug(e);
    }
    return saveOrUpdateReturn();
  }
  
  private String questionToName(String q){
    if(q.length()<75)
     return q;
    else
     return q.substring(0, 75)+'...';
  }
  
  public Pagereference previewQuestion(){
  
      System.debug('$$$$questionType'+questionType);
            
    if(questionType  == 'Multi-Select--Vertical'){
      showMultiSelectPreview = 'True';
      multiOptions = stringToSelectOptions(qChoices);
    }
    else if(questionType == 'Single Select--Vertical'){
     showSingleSelectPreview = 'True';
     singleOptions = stringToSelectOptions(qChoices);
    }
    else if(questionType == 'Single Select--Vertical with Attachment'){
     showSingleSelectAttachPreview = 'True';
     singleOptions = stringToSelectOptions(qChoices);
    }
    else if(questionType =='Free Text'){
      showFreeTextPreview = 'True';
    }
    else if(questionType =='Free Text with Attachment'){
      showFreeTextAttachPreview = 'True';
    }
    else if(questionType == 'Single Select--Horizontal'){
      showRowQuestionPreview = 'True';
      rowOptions = stringToSelectOptions(qChoices);
    }
    else if(questionType == 'Single Select--Horizontal with Attachment'){
      showRowQuestionAttachPreview = 'True';
      rowOptions = stringToSelectOptions(qChoices);
    }
    else if(questionType =='Attachment'){
      System.debug('@@@@@QuestionType '+questionType);
      showAttachmentPreview = 'True';
    }
    return null;
  }

  
  private List<SelectOption> stringToSelectOptions(String str){
    List<String> strList = str.split('\\r|\n');
    List<SelectOption> returnVal = new List<SelectOption>();
    for(String s: strList){
      returnVal.add(new SelectOption(s,s));
    }
    return returnVal;
    
  }
/****/

  /* Called during the setup of the page. 
     Retrieve questions and responses from DB and inserts them in 2 lists. */
  public Integer setupQuestionList(){   
    getAQuestion();
    return allQuestions.size();
  }
  
  
   /** Sets the survey's name variable
  *  param: sID The survey ID as specified in the DB
  */
  /*public void setSurveyNameAndThankYou(String sId){
    Survey__c s = [SELECT Name, Id, URL__c, thankYouText__c, thankYouLink__c, Survey_Header__c FROM Survey__c WHERE Id =:sId];
    groupName = s.Name;
    //surveyHeader = s.Survey_Header__c;
    templateURL = s.URL__c+'id='+sId;//+'&cId={!Contact.Id}'+'&caId='+'{!Case.id}';
    //surveyThankYouText = s.thankYouText__c;
    //surveyThankYouURL = s.thankYouLink__c;
  }*/
  
//------------------------------------------------------------------------------//   
  public Pagereference updateGroupName(){
    //Survey__c s = [SELECT Name, Id, URL__c, thankYouText__c, thankYouLink__c FROM Survey__c WHERE Id =:groupId];
    Group__c grp = [Select Name, ID, Group_Name__c from Group__c where Id =: groupId];
    grp.Group_Name__c = GroupName;
    try{
      update grp;
    }catch (Exception e){
      Apexpages.addMessages(e);
    }
    return null;
  } 
  
 
//------------------------------------------------------------------------------//    
  /*public Pagereference updateSurveyThankYouAndLink(){
    Survey__c s = [SELECT Name, Id, URL__c, thankYouText__c, thankYouLink__c FROM Survey__c WHERE Id =:groupId];
    s.thankYouText__c = surveyThankYouText;
    s.thankYouLink__c = surveyThankYouURL;
    try{
      update s;
    }catch(Exception e){
      Apexpages.addMessages(e);
    }
    return null;
  }*/
 
  
   public PageReference updateOrderList()
  {
    Id grpId;
    if(newOrderW.length() <= 0)
    {
        return null;
    }
    
    newOrderW = newOrderW.substring(0, newOrderW.length() -1);
    
    List<String> idsToUpdate = newOrderW.split(',',-1);
    List<Question__c> qsToUpdate = new List<Question__c>();
    
    Map<Id,Question__c> questionMap = new Map<Id,Question__c>([select Id, OrderNumber__c, Group_ID__c from Question__c where Id in :idsToUpdate]);
    Question__c sqToUpdate;
    
    for (Integer i = 0; i < idsToUpdate.size(); i++)
    {
        sqToUpdate = questionMap.get(idsToUpdate.get(i));
        sqToUpdate.OrderNumber__c = i;
        qsToUpdate.add(sqToUpdate);
        grpId = sqToUpdate.Group_ID__c;
    }
    
    update qsToUpdate;
    
    return null;
  } 
  /*
  public pageReference ShowGrp(){      
      PageReference pageRef = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/'+groupId);
      return pageRef;
  }*/
  //------------------------------------------------------------------------------//  
  /** When requested from the page - when the user clicks on 'Update Order' -
      this function will reorganize the list so that it is displayed in the new order
   */
   public Pagereference refreshQuestionList(){
    setupQuestionList();
    return null;
   }


   /** Redirects the page that displays the detailed results of the survey, 
       from all users who took the survey.
    */
    public PageReference resultPage() {
      return new PageReference('/apex/ResultsPage?id='+groupId);
    }

   
    
  
//------------------------------------------------------------------------------//      
  public Pagereference deleteRefresh(){
    if (questionReference!= null )
    {
         Question__c ques = [Select Id, Name FROM Question__c WHERE Id =: questionReference];
         delete ques;  
         questionReference = null;  
    }
     allQuestions.clear();
     Double j = 0.0;
    List<Question__c> allQuestionsObject = 
                    [Select Type__c, Id, Group_ID__c, Required__c, 
                    Question__c, OrderNumber__c, Name, Choices__c
                    From Question__c  
                    WHERE Group_ID__c =: groupId
                    order by OrderNumber__c];
    for (Integer i =0; i< allQuestionsObject.size(); i++){
      allQuestionsObject[i].OrderNumber__c= j;
      question theQ = new question(allQuestionsObject[i]);
      allQuestions.add(theQ);
      j = j+1.0;
    }
    //responses = getResponses();
    try{
      update allQuestionsObject;
    }catch(Exception e){
      Apexpages.addMessages(e);
    }
      return saveOrUpdateReturn();
  }
  /*
  public List<String> getResponses() {
    List<SurveyQuestionResponse__c> qr = [Select Survey_Question__c, SurveyTaker__c, Response__c, Name From SurveyQuestionResponse__c limit 100];
    List<String> resp = new List<String>();
    for (SurveyQuestionResponse__c r : qr) {
      resp.add(r.Response__c);
    }
    
    return resp;
  }  
  */

   /** Class: question
    *  Retrieves the question information and puts it in the question object
    */    
  public class question{
      public String   name                   {get; set;}
      public String   id                     {get; set;}
      public String   question               {get; set;}
      public String   orderNumber            {get; set;}
      public String   choices                {get; set;}
      public List<SelectOption> singleOptions{get; set;}
      public List<SelectOption> multiOptions {get; set;}
      public Boolean  required               {get; set;}
      public String   questionType           {get; set;}  
      public String   groupName             {get; set;}
      public String   renderFreeText         {get; set;}
      public String   renderFreeTextAttach         {get; set;}
      public String   renderSelectRadioAttach {get;set;}
      public String   renderSelectRadio      {get; set;}
      public String   renderSelectCheckboxes {get; set;} 
      public String   renderSelectRow        {get; set;}
      public String   renderSelectRowAttach        {get; set;}
      public String   renderSelectAttachement {get;set;}
      public String   renderSelectSystemValues{get; set;}
      public String   selectedSysValue       {get; set;}
      public List<String> responses          {get; set;}
      public String   singleOptionsForChart  {get; set;}
      public String   qResultsForChart       {get; set;} 
      public List<String> strList            {get; set;} // The question's option as a list of string
      public List<Integer> resultsCounts     {get; set;} // The count of each response to a question's choices
      public List<SelectOption> rowOptions   {get; set;}
      public boolean  noData                 {get; set;}
                  
      
      
    /** Fills up the question object
     *  param:  Question__c 
       */     
     public question(Question__c ques) {
        //name = ques.Name;
        id = ques.Id;
        System.debug('in Question found one with id '+id);
        question = ques.Question__c;
        orderNumber = String.valueOf(ques.OrderNumber__c+1);
        choices = ques.Choices__c;
        required = ques.Required__c;
        questionType = ques.Type__c;
        singleOptionsForChart = ' ';
        
     if (ques.Type__c=='Single Select--Vertical'){
        renderSelectRadio='true';
        singleOptions = stringToSelectOptions(choices);
        renderSelectCheckboxes='false';
        renderFreeText='false';
        renderSelectRow = 'false';
        renderSelectSystemValues='false';
        renderSelectRadioAttach='false';
        renderFreeTextAttach='false';
        renderSelectRowAttach='false';
        renderSelectAttachement='false';
      }
     /*else if (ques.Type__c=='Multi-Select--Vertical'){    
        renderSelectCheckboxes='true';
        multiOptions = stringToSelectOptions(choices);
        renderSelectRadio='false';
        renderFreeText='false';
        renderSelectRow = 'false';
        renderSelectAttachement='false';
        renderSelectSystemValues='false';
        renderSelectRadioAttach='false';
      }*/
     else if (ques.Type__c=='Single Select--Horizontal'){   
        renderSelectCheckboxes='false';
        rowOptions = stringToSelectOptions(choices);
        renderSelectRadio='false';
        renderFreeText='false';
        renderSelectRow = 'true';
        renderSelectAttachement='false';
        renderSelectSystemValues='false';
        renderSelectRadioAttach='false';
        renderFreeTextAttach='false';
        renderSelectRowAttach='false';
      }
     else if (ques.Type__c=='Single Select--Horizontal with Attachment'){   
        renderSelectCheckboxes='false';
        rowOptions = stringToSelectOptions(choices);
        renderSelectRadio='false';
        renderFreeText='false';
        renderSelectRow = 'false';
        renderSelectAttachement='false';
        renderSelectSystemValues='false';
        renderSelectRadioAttach='false';
        renderFreeTextAttach='false';
        renderSelectRowAttach='true';
      }
     else if (ques.Type__c=='Free Text'){
        renderFreeText='true';
        renderSelectRadio='false';
        renderSelectCheckboxes='false';
        renderSelectRow = 'false';
        renderSelectAttachement='false';
        renderSelectSystemValues='false';
        renderSelectRadioAttach='false';
        renderFreeTextAttach='false';
        renderSelectRowAttach='false';
      }
      else if (ques.Type__c=='Free Text with Attachment'){
        renderFreeText='false';
        renderSelectRadio='false';
        renderSelectCheckboxes='false';
        renderSelectRow = 'false';
        renderSelectAttachement='false';
        renderSelectSystemValues='false';
        renderSelectRadioAttach='false';
        renderFreeTextAttach='true';
        renderSelectRowAttach='false';
      }
     else if (ques.Type__c=='Attachment'){
        renderFreeText='false';
        renderSelectRadio='false';
        renderSelectCheckboxes='false';
        renderSelectRow = 'false';
        renderSelectAttachement='true';
        renderSelectSystemValues='false';
        renderSelectRadioAttach='false';
        renderFreeTextAttach='false';
        renderSelectRowAttach='false';
      }
     else if (ques.Type__c=='Single Select--Vertical with Attachment'){
        renderFreeText='false';
        renderSelectRadio='false';
        renderSelectCheckboxes='false';
        renderSelectRow = 'false';
        renderSelectAttachement='false';
        renderSelectRadioAttach='true';
        singleOptions = stringToSelectOptions(choices);
        renderFreeTextAttach='false';
        renderSelectRowAttach='false';
      } 
        //responses= getResponses();
      }
      
     /** Splits up the string as given by the user and adds each option
      *  to a list to be displayed as option on the Visualforce page
      *  param: str String as submitted by the user
      *  returns the List of SelectOption for the visualforce page
        */  
      private List<SelectOption> stringToSelectOptions(String str){
      if (str == '')
      {
        return new List<SelectOption>();
      }
      strList = str.split('\n');
    
      List<SelectOption> returnVal = new List<SelectOption>();
      for(String s: strList){
        if (s!='') {
          returnVal.add(new SelectOption(s,s));
          if (s != 'null' && s!= null) {
            String sBis = s.replace(' ', '%20');
            singleOptionsForChart += s.trim()+'|';
          }
        }
      }
      singleOptionsForChart = singleOptionsForChart.substring(0, singleOptionsForChart.length()-1);
      return returnVal;
    } 
  }
  
  /** Fills up the List of questions to be displayed on the Visualforce page
   */ 
  public List<question> getAQuestion() {
    List<Question__c> allQuestionsObject = 
                    [Select qs.Type__c, qs.Id, qs.Group_ID__c, qs.Required__c, qs.Question__c, 
                    qs.OrderNumber__c, qs.Name, qs.Choices__c 
                    From Question__c qs 
                    WHERE qs.Group_ID__c =: groupId ORDER BY qs.OrderNumber__c];
    allQuestions = new List<question>();
    
    Double old_OrderNumber = 0;
    Double new_OrderNumber;
    Double difference = 0;
    /* Make sure that the order number follow each other (after deleting a question, orders might not do so) */
    for (Question__c q : allQuestionsObject){ 
      new_OrderNumber = q.OrderNumber__c;
      system.debug('new_OrderNumber '+new_OrderNumber );
      difference = new_OrderNumber - old_OrderNumber - 1;
      if (difference > 0) {
        Double dd = double.valueOf(difference);
        Integer newOrderInt = dd.intValue();
        q.OrderNumber__c -= Integer.valueOf(newOrderInt); 
      }
      old_OrderNumber = q.OrderNumber__c;
      question theQ = new question(q);
      allQuestions.add(theQ);
    }
    allQuestionsSize = allQuestions.size();
    return allQuestions;
  } 

}