public with sharing class AssessmentSurvey {

//TestGitSetup
    public String oppId {get;set;}

    public String accId {get;set;}
    public String assessType {get;set;}
    public String caseId {get;set;}
    public Assessmentgroup__c assessGroup {get;set;}
    public Boolean isNewRecord {get;set;}
    public Map<Id,List<Id>> groupTreeMap {get;set;}
    public Map<Id,List<Question__c>> groupDetailsMap {get;set;}
    public Set<Id> childIdGroupSet {get;set;}
    public Id currentGroupId {get;set;}
    public Id nextGroupId {get;set;}
    public Id previousGroupId {get;set;}
    public wrapperClass wrapperObj {get;set;}
    public Map<Id,Id> childToParentMap {get;set;}
    public Boolean showSave {get;set;}
    public Boolean showPrevious {get;set;}
    public Map<Id,Map<String,Question_Response__c>> groupAnswerMap {get;set;}
    public Map<id,List<Question_Response__c>> answerRes {get;set;}
    public Map<Id,String> groupNameMap {get;set;}
    public Map<Id,String> answerResponse {get;set;}
    public String lob {get;set;}
    public String location {get;set;}
    public Map<Id,List<Groups_Line_Item__c>> parentToChildLineItemMap {get;set;}
    public Map<Id,Group__c> groupInfoMap {get;set;}
    public String oppName;
    private Opportunity opp;
    private Account acc;
    public String accName;
    public Attachment uploadAtt {get;set;}
    private Map<Id,Attachment> mapQuesWihAttach = new map<Id,Attachment>();
    public Map<String,String> SystemValueMap=new map<String,String>();
    public Boolean isAssessmentSubmitted {get;set;}
    private Map<Id,String> questionRequiredMap=new Map<Id,String>();
    private boolean errorMsg;
    private boolean nextClicked;

    //public Attachment uploadAtt1 {get;set;}
    public Attachment uploadAtt1 {
  get {
      if (uploadAtt1 == null)
        uploadAtt1 = new Attachment();
      return uploadAtt1;
    }
  set;
  }
 
    public AssessmentSurvey() {
        //set the parameter in to class level variable
        //s
        showSave=false;
        uploadAtt = new Attachment();
        errorMsg=false;
        //uploadAtt1 = new Attachment();
        showPrevious=false;
        answerRes= new Map<id,List<Question_Response__c>>{};
        groupNameMap = new Map<Id,String>();
        answerResponse=new Map<Id,String>();
        parentToChildLineItemMap=new Map<Id,List<Groups_Line_Item__c>>();
        groupAnswerMap = new Map<id,Map<String,Question_Response__c>>{};
        groupDetailsMap=new Map<Id,List<Question__c>>();
         nextClicked=false;
        groupTreeMap= new Map<Id,List<Id>>();
        childIdGroupSet = new Set<Id>();
        childToParentMap = new Map<Id,Id>();
        caseId   =  Apexpages.currentPage().getParameters().get('caId');
        //accId   =   Apexpages.currentPage().getParameters().get('aId');
        //oppId= Apexpages.currentPage().getParameters().get('oppId');
        assessType = Apexpages.currentPage().getParameters().get('assessType');
        lob = Apexpages.currentPage().getParameters().get('lob');
        location = Apexpages.currentPage().getParameters().get('location');
        /*opp=[Select id,name from Opportunity where id=:oppId];
        if(opp!=null)
         oppname=opp.name;
        acc=[select id,name from Account where id=:accId];
        if(acc!=null)
         accName=acc.name;*/
        SystemValueMap.put('$Opportunity.Name',oppname);
        SystemValueMap.put('$Account.Name',accName);
        System.debug('###SystemValueMap'+SystemValueMap);

        //assessType='Engagement Acceptance';

        getAllGroupLineItem();
        getGroupDetails();
        groupInformation();
        System.debug('==============groupTreeMap================='+groupTreeMap);
        /*System.debug('====================groupDetailsMap==========='+groupDetailsMap);
        System.debug('===============childIdGroupSet================'+childIdGroupSet);
        System.debug('=================+=============='); **/
    }

        public void init(){
            System.debug('---------------------Start of  init---------------------------------------');
            Map<String,Question_Response__c> answerQuestionFromDBMap = new Map<String,Question_Response__c>();
        //check if we have any existing assessment for related case,opp,account
        Map<Id,Assessmentgroup__c> assGroupMap = new Map<Id,Assessmentgroup__c>([select id,Is_Active__c,Groups_ID__c,IsComplete__c from Assessmentgroup__c where Assessment_Type__c=:assessType and Opportunity__c =:oppId ]);
        //iterate through all the fetched record . Assumption is there will always be one single record
        for(Assessmentgroup__c obj:assGroupMap.values()){

            if((obj.Is_Active__c) && (!obj.IsComplete__c)){
                assessGroup=obj;
                break;
            }else {
                assessGroup=obj;
                isAssessmentSubmitted=true;
            }


        }

        if(assGroupMap.isEmpty()) {
            System.debug('========== Inside new block , going to create new Assessmentgroup__c');
            isNewRecord=true;
             assessGroup = new Assessmentgroup__c();
            assessGroup.Opportunity__c=oppId;
            assessGroup.Assessment_Type__c=assessType;
            assessGroup.Is_Active__c=true;
            //assessGroup.Account__c=accId;
            currentGroupId=getStartingGroup();
            System.debug('%%%%%%%CurrentGroup'+currentGroupid);

        }else{
            isNewRecord=false;
            System.debug('==========  Assessmentgroup__c Group found... going to fetch question response from database'+assessGroup.id);

            for(Question_Response__c qResObj:[select id,Answer__c,Groups__c,Question_ID__c,Question_ID__r.OrderNumber__c from Question_Response__c where Assess_Grp_ID__c=:assessGroup.id order by Question_ID__r.OrderNumber__c]){

                    answerQuestionFromDBMap = new Map<String,Question_Response__c>();
                     if(answerResponse.containsKey(qResObj.Groups__c)){

                     answerResponse.put(qResObj.Groups__c,answerResponse.get(qResObj.Groups__c)+'|'+qResObj.Answer__c);
                     }else{
                        answerResponse.put(qResObj.Groups__c,qResObj.Answer__c);
                     }

                if(groupAnswerMap.containsKey(qResObj.Groups__c)){

                    answerQuestionFromDBMap=groupAnswerMap.get(qResObj.Groups__c);

                    if(!(answerQuestionFromDBMap.containsKey(qResObj.Question_ID__c))){

                        answerQuestionFromDBMap.put(qResObj.Question_ID__c,qResObj);
                    }

                }else{


                    answerQuestionFromDBMap.put(qResObj.Question_ID__c,qResObj);
                    groupAnswerMap.put(qResObj.Groups__c,answerQuestionFromDBMap);

                }



            }

            currentGroupId=assessGroup.Groups_ID__c;
        }
            System.debug('%%%currentGroupId'+currentGroupId);
            if(currentGroupId==null){
                   ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Not able to find survey against this LOB,Location,Assessment');
                   ApexPages.addMessage(myMsg1);
            }else{
                 System.debug('==========  Displaying response saved in salesforce in Question Response object'+groupAnswerMap);
                 //saveAnswerinMap();
                  LoadGroupData(currentGroupId);
            
            }

        System.debug('---------------------Start of  init---------------------------------------');
    }

    /**
    *
    *
    */
    public void groupInformation(){
        System.debug('---------------------Start of  groupInformation---------------------------------------');
        groupInfoMap=new Map<Id,Group__c>([select id,Assessment_type__c,calculated__c,Group_Name__c,IsCalculated__c from Group__c where id in :groupNameMap.keySet()]);
         System.debug('---------------------End of  groupInformation---------------------------------------');
    }

    /**
    *   This method get Map<Id,Group> of all the group along with questions based on assessment type
    *
    *
    */
        public void getGroupDetails(){
            System.debug('---------------------Start of  getGroupDetails---------------------------------------');
            List<Question__c> qList ;
            for(Question__c obj:[Select id,Type__c,required__c ,Question__c, Group_ID__c,Choices__c From Question__c where Group_ID__c in:groupNameMap.keySet() order by OrderNumber__c]){


                if(groupDetailsMap.containsKey(obj.Group_ID__c)){
                    qList=groupDetailsMap.get(obj.Group_ID__c);
                    qList.add(obj);


                }else{
                    qList= new List<Question__c>();
                    qList.add(obj);
                    groupDetailsMap.put(obj.Group_ID__c,qList);
                }

            }
    System.debug('---------------------End of  getGroupDetails---------------------------------------');
        }
        //This method is use to load question
        public void LoadGroupData(String groupId){
              System.debug('---------------------Start of  LoadGroupData---------------------------------------');
            Map<String,Question_Response__c> groupQuestionResponseMap;
            //get current group id
            List<Question__c> qesList=groupDetailsMap.get(currentGroupId);
            System.debug('!!!SystemValueMap'+SystemValueMap);
            Integer compaireValue=0;
            //get previous group id

            previousGroupId=childToParentMap.get(currentGroupId);
            //if(previousGroupId!=null){
            //  if(answerResponse.containsKey(previousGroupId)){
                // answerResponse.put(previousGroupId,'');
                //}
            //}

            if(childToParentMap.containsKey(currentGroupId)){
                showPrevious=true;
            }else{
                showPrevious=false;
            }



            List<Id> cList=groupTreeMap.get(currentGroupId);
             //right now assuming one parent and one chlild
            //System.debug('Getting child list from map ############ '+cList.size());
             if(cList==null || cList.isEmpty()){
                // no chlild found , closed the survey
            //nextGroupId='';
            showSave=true;
             }else if(cList.size() ==1 && !(cList.isEmpty())){
                //Single child found , blindly fetch next child
                nextGroupId=cList[0];
                showSave=false;

             }else if(cList.size() > 1 && !(cList.isEmpty())){
                System.debug('Logic for child################# Multiple child found-- going to find correct child - '+cList.size());

                //multiple child found , perform logic to get correct child
                if(answerResponse.containsKey(currentGroupId)){

                    string pipeString = '|';
                    String preAnswer=answerResponse.get(currentGroupId).replace(pipeString,'');
                    Boolean matchLineItem = false;

                    groupQuestionResponseMap=groupAnswerMap.get(currentGroupId);
                    for(Question_Response__c questionresObj:groupQuestionResponseMap.values()){

                             if(questionresObj.Answer__c!=null){
                                System.debug('**************answer is  '+questionresObj.Answer__c);
                                System.debug('**************answer compaire is  '+questionresObj.Answer__c.equalsIgnoreCase('Yes'));
                                if('Yes'.equalsIgnoreCase(questionresObj.Answer__c.trim())){
                                     compaireValue=100;
                                        break;
                                }else if('No'.equalsIgnoreCase(questionresObj.Answer__c.trim())){
                                     compaireValue=50;
                                    break;
                                }
                            }


                    }

                    for(Groups_Line_Item__c lineItemObj:parentToChildLineItemMap.get(currentGroupId)){
                        System.debug(' ################# line item'+lineItemObj);
                        if(lineItemObj.Evaluation_criteria__c.equalsIgnoreCase('None')){
                            System.debug(' ################# inside none block'+lineItemObj.Evaluation_criteria__c);
                            ApexPages.Message myMsg23 = new ApexPages.Message(ApexPages.Severity.INFO,'Answer Pattern field of Group Line Item for Current Group is blank. Please update the field');
                            ApexPages.addMessage(myMsg23);

                        }else if(lineItemObj.Evaluation_criteria__c.equalsIgnoreCase('Answer Pattern')){
                            
                        System.debug(' ################# inside Answer Pattern block'+lineItemObj.Evaluation_criteria__c);
                        /*String[] pattern=lineItemObj.Answer_Pattern__c.split('||');
                        String patternToMatch;
                        Integer pat;
                        for(integer i=0;i<pattern.size();i++){
                            if(pattern[i]!='*'){
                               pat=Integer.valueOf(pattern[i]);
                               pat=pat-1;
                               if(patternToMatch!=)
                               patternToMatch= 
                            }
                        }*/
                        
                        String patternToMatch=lineItemObj.Answer_Pattern__c.replace(pipeString,'');
                        patternToMatch=patternToMatch.trim().replace('*','([a-zA-Z0-9_\\-\\.]+)');  
                        Pattern MyPattern = Pattern.compile(patternToMatch.trim());
                        System.debug('^^^^^^^^^answer Pattern'+preAnswer+patternToMatch);
                        Matcher MyMatcher = MyPattern.matcher(preAnswer.trim());
                        System.debug('Logic for child################# patternToMatch '+patternToMatch +'lenght is'+patternToMatch.length());
                        System.debug('Logic for child################# preAnswer '+preAnswer +' lenght is '+preAnswer.length());
                        System.debug('Logic for child################# Reuslt'+MyMatcher.matches());
                        if(MyMatcher.matches()){
                            nextGroupId=lineItemObj.Child_Group_ID__c;
                            System.debug('Logic for child################# next child is'+nextGroupId);
                            matchLineItem=true;
                            break;
                        }
                        //else{
                        //  ApexPages.Message myMsg22 = new ApexPages.Message(ApexPages.Severity.INFO,'Answer Pattern of Current Response does not matched with any of next Group Response. Please check Group Line Item Anwser Pattern field for Current Group.');
                        //  ApexPages.addMessage(myMsg22);
                        //}
                        } else if(lineItemObj.Evaluation_criteria__c.equalsIgnoreCase('Numeric Calculation')){
                            System.debug(' ################# inside Numeric Calculation block'+lineItemObj.Evaluation_criteria__c);
                            System.debug(' ################# inside Numeric Calculation block compaireValue value'+compaireValue);
                        if(lineItemObj.Numeric_comparison__c==compaireValue){
                              System.debug(' ################# inside Numeric Calculation block compaireValue found****'+compaireValue);
                                nextGroupId=lineItemObj.Child_Group_ID__c;
                                matchLineItem=true;
                                break;
                            }


                        }

                    }

                    if(!matchLineItem && nextClicked){
                            nextGroupId=currentGroupId;
                            ApexPages.Message myMsg22 = new ApexPages.Message(ApexPages.Severity.INFO,'Answer Pattern of Current Response does not matched with any of next Group Response. Please check Group Line Item Anwser Pattern field for Current Group.');
                            ApexPages.addMessage(myMsg22);
                    }



                showSave=false;
             }
                    }
             System.debug('------groupAnswerMap.get(CurrentGroupId)'+groupAnswerMap.get(CurrentGroupId));       
            /*if(groupAnswerMap.get(currentGroupId)==null)   
            {
                   ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Not able to find survey against this LOB,Location,Assessment');
                   ApexPages.addMessage(myMsg1);
            }     
            else*/
            wrapperObj = new wrapperClass(currentGroupId,nextGroupId,previousGroupId,qesList,groupAnswerMap,groupInfoMap.get(currentGroupId),groupNameMap,SystemValueMap);

            //saveAnswerinMap();

            System.debug('_______________++++++++++++++++++++'+wrapperObj);
            //check if it already present in quesiton response

            //if present get it in list with answer and show in screen

            //else

            //get list of question and insert in response questions
              System.debug('---------------------End of  LoadGroupData---------------------------------------');
        }

    /**
    *   This method gives Map<ParentGroupId,List<childGroupId>> structure. That will help to run the Survey based on assessment type
    *   It also create list of all child groups
    */
    public void getAllGroupLineItem(){
         System.debug('---------------------Start of  getAllGroupLineItem---------------------------------------');
        List<id> chlidGroupList = new List<id>();
        List<Groups_Line_Item__c> chlidGroupLineItemList = new List<Groups_Line_Item__c>();
        List<Groups_Line_Item__c>  groupLineItemList=new List<Groups_Line_Item__c>();
        groupLineItemList=[select Child_Group_ID__r.calculated__c,Child_Group_ID__r.IsCalculated__c,Child_Group_ID__r.Group_Name__c,Child_Group_ID__c,Parent_Group_ID__r.calculated__c,Parent_Group_ID__r.IsCalculated__c,Parent_Group_ID__r.Group_Name__c,Parent_Group_ID__c,Answer_Pattern__c,Evaluation_criteria__c,Numeric_comparison__c from Groups_Line_Item__c where Assessment_Type__c=:assessType and Location__c=:location and LOB__c=:lob];
        
        /*if(!groupLineItemList.isEmpty()){*/
    
            for(Groups_Line_Item__c obj : groupLineItemList){
    
                groupNameMap.put(obj.Child_Group_ID__c,obj.Child_Group_ID__r.Group_Name__c);
                groupNameMap.put(obj.Parent_Group_ID__c,obj.Parent_Group_ID__r.Group_Name__c);
    
    
                if(parentToChildLineItemMap.containsKey(obj.Parent_Group_ID__c)){
                    chlidGroupLineItemList=parentToChildLineItemMap.get(obj.Parent_Group_ID__c);
                    chlidGroupLineItemList.add(obj);
    
    
    
                }else{
                    chlidGroupLineItemList = new List<Groups_Line_Item__c>();
                    chlidGroupLineItemList.add(obj);
                    parentToChildLineItemMap.put(obj.Parent_Group_ID__c,chlidGroupLineItemList);
    
    
                }
                //need to remove the below logic as use the above logic that contain list of line item as below logic is not scaleable
                if(groupTreeMap.containsKey(obj.Parent_Group_ID__c)){
                    chlidGroupList=groupTreeMap.get(obj.Parent_Group_ID__c);
                    chlidGroupList.add(obj.Child_Group_ID__c);
                    }else{
                        chlidGroupList= new List<Id>();
                        chlidGroupList.add(obj.Child_Group_ID__c);
                        groupTreeMap.put(obj.Parent_Group_ID__c,chlidGroupList);
                    }
                    //This logic will create list of all child groups
                    if((obj.Child_Group_ID__c != null) && !(childIdGroupSet.contains(obj.Child_Group_ID__c))){
                            childIdGroupSet.add(obj.Child_Group_ID__c);
                    }
    
                    //logic to populate childToParentMap
                    if(!childToParentMap.containsKey(obj.child_Group_ID__c)){
                        childToParentMap.put(obj.Child_Group_ID__c,obj.Parent_Group_ID__c);
                    }
    
                }
          /*}
          else{
                  ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Not able to find survey against this LOB,Location,Assessment');
                   ApexPages.addMessage(myMsg1);
          } */ 

        System.debug('---------------------End of  getAllGroupLineItem---------------------------------------');
        }


    //This method will find the first group which will be the starting group. Logic is that the starting group will not be chlid of any group
    public Id getStartingGroup(){

        //get list of all parent group and search it in list of child group
        for(Id parentId:groupTreeMap.keySet()){
            if(!childIdGroupSet.contains(parentId)){
                currentGroupId=parentId;
            }
        }
        System.debug('$$curentGroup'+currentGroupId);
        return currentGroupId;
        }


    public List<Question_Response__c> getQuestionResponse(String assessType,String groupId){
         System.debug('---------------------Start of  getQuestionResponse---------------------------------------');
            List<Question_Response__c> questionResponseList = [select id,Groups__c,Response__c, Question_Title__c from Question_Response__c where Assess_Grp_ID__c=:assessGroup.id and Groups__c =:assessGroup.Groups_ID__c];
        System.debug('---------------------End of  getQuestionResponse---------------------------------------');
            return questionResponseList;

    }

    public void saveAnswerinMap(){
        System.debug('---------------------Calling saveAnswerinMap---------------------------------------');
        Map<String,Question_Response__c> answerQuestionIdMap = new Map<String,Question_Response__c>();
        Question_Response__c qResp;
        String responseAnswer='';
        boolean flag=false;
        boolean flagToWrite=false;
        System.debug('inside in saveAnswerinMap---------------------');
        errorMsg=false;
            //answerResponse=new Map<Id,String>();
            
        if(wrapperObj!=null){
        
         
            if(groupAnswerMap.containsKey(wrapperObj.currentGroupId)){
    
                answerQuestionIdMap=groupAnswerMap.get(wrapperObj.currentGroupId);
    
            }else {
    
                groupAnswerMap.put(wrapperObj.currentGroupId,answerQuestionIdMap);
    
    
            }
            String option_ans;
            Integer i=1;
            System.debug('$$$questionList'+wrapperObj.questionList);
            for(question qObj:wrapperObj.questionList){
    
                System.debug(qObj.id+'======================'+qObj.attObj);
                
                qResp = new Question_Response__c();
    
                if(answerQuestionIdMap.containsKey(qObj.id)){
    
                    qResp=answerQuestionIdMap.get(qObj.id);
                }else{
    
                        qResp.Question_ID__c=qObj.id;
                        //qResp.Account_ID__c=accId;
                            qResp.Opportunity_ID__c=oppId;
    
                                qResp.Assess_Grp_ID__c=assessGroup.id;
                                qResp.Groups__c=ID.valueOf(wrapperObj.currentGroupId);
    
                        answerQuestionIdMap.put(qObj.id,qResp);
    
                }
    
                if(qObj.renderSelectRadio== 'true'){
                     if(((qObj.selectedOption == null || qObj.selectedOption == '') && qObj.required==true)){
                         System.debuG('#####Inside renderSelectRadio');
                          ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'Kindly answer the required questions to navigate further' );
                          ApexPages.addmessage(msg); 
                          qResp.Answer__c='';
                          errorMsg=true;
                          option_ans='';
                          
                     }
    
                     else if (qObj.selectedOption == null || qObj.selectedOption == ''&& qObj.required==false)
                    {
                        //answerQuestionIdMap.put(qObj.id,'');
                        //errorMsg=false;
                        qResp.Answer__c='';
                        option_ans='';
                    }
                    else
                    {
                        //errorMsg=false;
                        System.debug('>>>>>>>>>>>>>>>>>>>'+qObj.selectedOption);
                        qResp.Answer__c=qObj.singleOptions.get(Integer.valueOf(qObj.selectedOption)).getLabel();
                         System.debug('###Integer'+qObj.singleOptions.get(Integer.valueOf(qObj.selectedOption)).getLabel());
                          //answerQuestionIdMap.put(qObj.id,qObj.singleOptions.get(Integer.valueOf(qObj.selectedOption)).getLabel());
                         String ans=qObj.singleOptions.get(Integer.valueOf(qObj.selectedOption)).getValue();
                       Integer pat=Integer.valueOf(ans.trim());
                       pat=pat+1;
                       option_ans=String.valueOf(pat);
    
                    }
                    //answerQuestionIdMap.put(qObj.id,qobj.singleOptions.get(Integer.valueOf(qObj.selectedOption)).getLabel());
    
                } /*else if(qObj.renderSelectCheckboxes== 'true') {
    
                         String totalOption='';
                     for (String opt : qObj.selectedOptions){
                     
                          if(((opt == '' || opt == null) && qObj.required==true)){
                         //System.debuG('#####Inside renderSelectRadio');
                          ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'Kindly answer the required questions to navigate further' );
                          ApexPages.addmessage(msg); 
                          qResp.Answer__c='';
                          errorMsg=true;
                          
                          
                     }
    
                        if ((opt == '' || opt == null ) && qObj.required==false)
                        {
                            //answerQuestionIdMap.put(qObj.id,'');
                            qResp.Answer__c='';
                        }
                        else
                        {
    
                            if((totalOption.trim()).length() ==0){
                             totalOption=qobj.multiOptions.get(Integer.valueOf(opt)).getLabel();
                            }else{
                                 totalOption=totalOption+','+ qobj.multiOptions.get(Integer.valueOf(opt)).getLabel();
                            }
    
    
                            //answerQuestionIdMap.put(qObj.id,qobj.multiOptions.get(Integer.valueOf(opt)).getLabel());
    
                        }
                     }
                    //answerQuestionIdMap.put(qObj.id,totalOption);
                     qResp.Answer__c=totalOption;
                }*/ else if (qObj.renderFreeText== 'true') {
                
                    if((qobj.choices==null ||qobj.choices.trim()=='') && qobj.required==true)
                    {
                        ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'Kindly answer the required questions to navigate further' );
                          ApexPages.addmessage(msg); 
                          qResp.Answer__c='';
                          errorMsg=true;
                          option_ans='';
                    }
                    else{
                        qResp.Answer__c=qobj.choices;
                        option_ans=qResp.Answer__c;
                    }
                    //answerQuestionIdMap.put(qObj.id,qobj);
    
                } 
                else if (qObj.renderFreeTextAttach== 'true') {
                
                    if((qobj.choices==null ||qobj.choices.trim()=='') && qobj.required==true)
                    {
                        ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'Kindly answer the required questions to navigate further' );
                          ApexPages.addmessage(msg); 
                          qResp.Answer__c='';
                          errorMsg=true;
                          option_ans='';

                    }
                    else{
    
                        qResp.Answer__c=qobj.choices;
                        option_ans=qResp.Answer__c;
                    }
                    //answerQuestionIdMap.put(qObj.id,qobj);
    
                }else if (qObj.renderSelectRow== 'true') {
                
                     if ((qObj.selectedOptionRow == null || qObj.selectedOptionRow == '') && qObj.required==true){
                         ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'Kindly answer the required questions to navigate further' );
                          ApexPages.addmessage(msg); 
                          qResp.Answer__c='';
                          errorMsg=true;
                          option_ans='';
                         
                     }
                     else if ((qObj.selectedOptionRow == null || qObj.selectedOptionRow == '') && qObj.required==false)
                    {
                        //answerQuestionIdMap.put(qObj.id,'');
                        qResp.Answer__c='';
                        option_ans='';
                    }
                    else
                    {
                       System.debug('>>>>>>>>>>>>>>>>>>>'+qObj.selectedOptionRow);
                       qResp.Answer__c=qObj.rowOptions.get(Integer.valueOf(qObj.selectedOptionRow)).getLabel();
                       String ans=qObj.rowOptions.get(Integer.valueOf(qObj.selectedOptionRow)).getValue();
                       Integer pat=Integer.valueOf(ans.trim());
                       pat=pat+1;
                       option_ans=String.valueOf(pat);
                       // answerQuestionIdMap.put(qObj.id,qObj.rowOptions.get(Integer.valueOf(qObj.selectedOptionRow)).getLabel());
                        //answerQuestionIdMap.put(qObj.id,qObj.selectedOptionRow);
                    }
    
                    //answerQuestionIdMap.put(qObj.id,qobj.rowOptions.get(Integer.valueOf(qObj.selectedOption)).getLabel());
                }
                else if (qObj.renderSelectRowAttach== 'true') {
                
                    if ((qObj.selectedOptionRow == null || qObj.selectedOptionRow == '') && qObj.required==true){
                         ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'Kindly answer the required questions to navigate further' );
                          ApexPages.addmessage(msg); 
                          qResp.Answer__c='';
                          errorMsg=true;
                          option_ans='';
                     }
                     else if (qObj.selectedOptionRow == null || qObj.selectedOptionRow == '')
                    {
                        //answerQuestionIdMap.put(qObj.id,'');
                        qResp.Answer__c='';
                        option_ans='';
                    }
                    else
                    {
                       System.debug('>>>>>>>>>>>>>>>>>>>'+qObj.selectedOptionRow);
                       qResp.Answer__c=qObj.rowOptions.get(Integer.valueOf(qObj.selectedOptionRow)).getLabel();
                       String ans=qObj.rowOptions.get(Integer.valueOf(qObj.selectedOptionRow)).getValue();
                       Integer pat=Integer.valueOf(ans.trim());
                       pat=pat+1;
                       option_ans=String.valueOf(pat);

                       // answerQuestionIdMap.put(qObj.id,qObj.rowOptions.get(Integer.valueOf(qObj.selectedOptionRow)).getLabel());
                        //answerQuestionIdMap.put(qObj.id,qObj.selectedOptionRow);
                    }
    
                    //answerQuestionIdMap.put(qObj.id,qobj.rowOptions.get(Integer.valueOf(qObj.selectedOption)).getLabel());
                } else if(qObj.renderAttachment=='true'){
    
                    System.debug('============================@@@'+qObj.renderAttachment);
                     System.debug('============================@@@'+qObj.qResponse);
                        qResp.id=qObj.qResponse.id;
                        qResp.Answer__c='file already uploaded';
                        option_ans='attached';
    
       
                  //answerResponse.put(wrapperObj.currentGroupId,String.isBlank(wrapperObj.answerPat)?qResp.Answer__c:wrapperObj.answerPat+'|'+qResp.Answer__c);
                }else if(qObj.renderSelectRadioAttachment=='true'){
    
                    System.debug('============================@@@'+qObj.renderAttachment);
                     System.debug('============================@@@'+qObj.qResponse);
                        qResp.id=qObj.qResponse.id;
                        
                        
                    if(((qObj.selectedOption == null || qObj.selectedOption == '') && qObj.required==true)){
                         System.debuG('#####Inside renderSelectRadio');
                          ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'Kindly answer the required questions to navigate further' );
                          ApexPages.addmessage(msg); 
                          qResp.Answer__c='';
                          errorMsg=true;
                          option_ans='';
                          
                     }
                     else if ((qObj.selectedOption == null || qObj.selectedOption == '') && qObj.required==false)
                    {
                        //answerQuestionIdMap.put(qObj.id,'');
                        qResp.Answer__c='';
                        option_ans='';
                    }
                    else
                    {
                        System.debug('>>>>>>>>>>>>>>>>>>>'+qObj.selectedOption);
                        qResp.Answer__c=qObj.singleOptions.get(Integer.valueOf(qObj.selectedOption)).getLabel();  
                        System.debug('$$$Option NUmber'+qObj.singleOptions.get(Integer.valueOf(qObj.selectedOption)));
                        String ans=qObj.singleOptions.get(Integer.valueOf(qObj.selectedOption)).getValue();
                       Integer pat=Integer.valueOf(ans.trim());
                       pat=pat+1;
                       option_ans=String.valueOf(pat);                        
                    }
    
                  //answerResponse.put(wrapperObj.currentGroupId,String.isBlank(wrapperObj.answerPat)?qResp.Answer__c:wrapperObj.answerPat+'|'+qResp.Answer__c);
                }
                
                //below logic is use to create the answer pattern selected by user on screen and then this answer pattern is used to select next group if multtiple group
                //present for same parent group
                 if(answerResponse.containsKey(wrapperObj.currentGroupId)){
                    System.debug('***********Flag*******'+flag);
                    System.debug('***********flagToWrite*******'+flagToWrite);
                    if(flag){
                        responseAnswer=answerResponse.get(wrapperObj.currentGroupId).trim()+'|'+option_ans.trim();
                        answerResponse.put(wrapperObj.currentGroupId,responseAnswer.trim());
                      }else{
                            if(flagToWrite){
                                    responseAnswer=answerResponse.get(wrapperObj.currentGroupId).trim()+'|'+option_ans.trim();
                                    answerResponse.put(wrapperObj.currentGroupId,responseAnswer.trim());
                                }else{
                                    responseAnswer=option_ans.trim();
                                    answerResponse.put(wrapperObj.currentGroupId,responseAnswer.trim());
                                flagToWrite=true;
                                }
    
                      }
                 }else{
                         if(option_ans!=null)
                         {
                             responseAnswer=option_ans;
                            System.debug('============*********===answerResponse first time========='+answerResponse);
                            answerResponse.put(wrapperObj.currentGroupId,responseAnswer.trim());
                            flag=true;
                         
                         }
                         
                 }
    
                  // wrapperObj.answerPat=String.isBlank(wrapperObj.answerPat)?qResp.Answer__c:wrapperObj.answerPat+'|'+qResp.Answer__c;
                groupAnswerMap.put(wrapperObj.currentGroupId,answerQuestionIdMap);
                System.debug('============*********===answerResponse========='+answerResponse);
                //System.debug('=============wrapperObj.currentGroupId==========='+groupAnswerMap);
    
    
                option_ans=null;
    
            }
        
      }  
        System.debug('---------------------End of  saveAnswerinMap---------------------------------------');

    }

    public void nextButton(){
         System.debug('---------------------Start of  nextButton---------------------------------------');
         system.debug('mapQuesWihAttach'+mapQuesWihAttach);
        System.debug('==========next button clicked=========='+uploadAtt.name);
        //if(isNewRecord){
            //insert assessGroup;
    //  }
        nextClicked=true;
        saveAnswerinMap();
        LoadGroupData(currentGroupId);
        system.debug('$$$$errorMsg'+errorMsg);
        //String tempPrevious=previousGroupId;
        //String tempCurrent=currentGroupId;
        //String tempNextId=nextGroupId;
        if(errorMsg==false){
            previousGroupId=currentGroupId;
            currentGroupId=nextGroupId;
            LoadGroupData(currentGroupId);
        }
         System.debug('---------------------End of  nextButton---------------------------------------');
    }
    public void SubmitButton(){
        System.debug('---------------------Start of  SubmitButton---------------------------------------');
        try{
        //saveButton();
        saveAnswerinMap();
        assessGroup.Is_Active__c=true;
        assessGroup.IsComplete__c=true;
        //assessGroup.Groups_ID__c='';
        if(errormsg==false){
            upsert assessGroup;
            saveRecord();
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.INFO,'Assessment submitted sucessfully.');
            ApexPages.addMessage(myMsg1);
        }
        }catch(DmlException e){}
    System.debug('---------------------End of  SubmitButton---------------------------------------');
    }

    public void previousButton(){
         System.debug('---------------------Start of  previousButton---------------------------------------');
        saveAnswerinMap();
            LoadGroupData(currentGroupId);
        //if(isNewRecord){
            //insert assessGroup;
    //  }
        String tempPrevious=previousGroupId;
        String tempCurrent=currentGroupId;
        String tempNextId=nextGroupId;
        //previousGroupId=currentGroupId;
        if(errormsg==false){
            currentGroupId=previousGroupId;
            nextGroupId=currentGroupId;
            LoadGroupData(currentGroupId);
        }
    System.debug('---------------------End of  previousButton---------------------------------------');
    }
    public void saveButton(){
    System.debug('---------------------Start of  saveButton---------------------------------------');
      try{
        System.debug('-------Save Button clicked');
        saveAnswerinMap();
        assessGroup.Groups_ID__c=ID.valueOf(currentGroupId);
        System.debug('-------Save Button clicked');
        upsert assessGroup;

        System.debug('---Record inserted in Assessment Group');
        saveRecord();
        System.debug('---Record inserted in Question Response');
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Data Saved Sucessfully.');
        ApexPages.addMessage(myMsg);
        }catch(DmlException e){

        }
    System.debug('---------------------End of  saveButton---------------------------------------');
    }
    public void saveRecord(){
    System.debug('---------------------Start of  saveRecord---------------------------------------');
        Map<String,Question_Response__c> answerQuestionIdMap;
        List<Question_Response__c> respList= new List<Question_Response__c>();
        Question_Response__c resObj= new Question_Response__c();

        for(ID gId:groupAnswerMap.keySet()){
            answerQuestionIdMap=groupAnswerMap.get(gId);
                for(String str:answerQuestionIdMap.keySet()){
                        resObj= answerQuestionIdMap.get(str);
                        //resObj.Account_ID__c=accId;
                        //resObj.Opportunity_ID__c=oppId;
                        //resObj.Answer__c=answerQuestionIdMap.get(str);
                            resObj.Assess_Grp_ID__c=assessGroup.id;
                            //resObj.Groups__c=ID.valueOf(gId);
                            //resObj.Question_ID__c=str;
                            //Question_Title__c

                    respList.add(resObj);

                }
             if(errormsg==false)
                upsert answerQuestionIdMap.values();
        }
        //upsert respList;
System.debug('---------------------End of  saveRecord---------------------------------------');
    }


 public class question{
      public String   name                   {get; set;}
       public Attachment attObj {get;set;}
      public String   id                           {get; set;}
      public String   questionDetail               {get; set;}
      public String   orderNumber            {get; set;}
      public String   choices                {get; set;}
      public String   selectedOption         {get;set;}
      public List<String> selectedOptions {get;set;}
      public List<SelectOption> singleOptions{get; set;}
      public List<SelectOption> multiOptions {get; set;}
      public Boolean  required               {get; set;}
      public String   questionType           {get; set;}
      public String   surveyName               {get; set;}
      public String   renderFreeText             {get; set;}
      public string   renderSystemValues       {get; set;}
        public String   renderSelectRadio      {get; set;}
        public String   renderSelectCheckboxes {get; set;}
        public String   renderSelectRow        {get; set;}
        public String   renderAttachment        {get; set;}
      public String renderSelectRadioAttachment  {get;set;}  
      public String renderFreeTextAttach         {get;set;}
      public String renderSelectRowAttach        {get;set;}
      public string sysVal;
      public List<String> responses             {get; set;}
      public String   singleOptionsForChart  {get; set;}
      public String   qResultsForChart         {get; set;}
      public List<String> strList              {get; set;} // The question's option as a list of string
      public List<Integer> resultsCounts       {get; set;} // The count of each response to a question's choices
      public List<SelectOption> rowOptions   {get; set;}
      public boolean  noData                 {get; set;}
     public String selectedOptionRow {get;set;}
     public Question_Response__c qResponse {get;set;}
     //public Map<string,string>sysValMap=new map<string,string>();



      /** Fills up the question object
       *  param:    Survey_Question__c
       */
     public question(Question__c sq,Question_Response__c quesResponse,map<string,string>sysValMap) {

        String ans=quesResponse!=null?(quesResponse.Answer__c!=null?quesResponse.Answer__c:null):null;
        qResponse=quesResponse!=null?quesResponse:new Question_Response__c();
        System.debug('=================Ans============'+ans);
       // name = sq.Name;
        attObj=new Attachment();
        id = sq.Id;
        questionDetail = sq.Question__c;
        required=sq.Required__c;
        //if(sq.Required__c==true)
          //questionDetail=questionDetail+'<B>(required)</B>';  
        
       // orderNumber = String.valueOf(sq.OrderNumber__c+1);
        choices = sq.Choices__c;
       //required = sq.Required__c;
        questionType = sq.Type__c;
        singleOptionsForChart = ' ';
        selectedOption = (ans!=null?ans.replaceAll(' \r\n',''):'');
        selectedOptionRow=(ans!=null?ans.replaceAll(' \r\n',''):'');
        selectedOptions = new List<String>();
        
        system.debug('@@@@required'+required);
     if (sq.Type__c=='Single Select--Vertical'){
                renderSelectRadio='true';
                singleOptions = stringToSelectOptions(choices);
                renderSelectRadioAttachment='false';
                renderSelectCheckboxes='false';
                renderFreeText='false';
                renderSelectRow = 'false';
                renderAttachment = 'false';
                renderSystemValues='false';
                renderFreeTextAttach='false';
                renderSelectRowAttach='false';
        //selectedOption = '';
                if(sq.Question__c.contains('$Opportunity.Name')&& !sysValMap.isEmpty() ){
                  questionDetail=fetchPattern(questionDetail,sysValMap);
                 }
                if(sq.Question__c.contains('$Account.Name')&& !sysValMap.isEmpty() ){
                  questionDetail=fetchPattern(questionDetail,sysValMap);
                }
                selectedOptions = new List<String>();
      }
      else if (sq.Type__c=='Single Select--Vertical with Attachment'){
                upsert qResponse;  
                renderSelectRadio='false';
                singleOptions = stringToSelectOptions(choices);
                renderSelectRadioAttachment='true';
                renderSelectCheckboxes='false';
                renderFreeText='false';
                renderSelectRow = 'false';
                renderAttachment = 'false';
                renderSystemValues='false';
                renderFreeTextAttach='false';
                renderSelectRowAttach='false';
        //selectedOption = '';
                if(sq.Question__c.contains('$Opportunity.Name')&& !sysValMap.isEmpty() ){
                  questionDetail=fetchPattern(questionDetail,sysValMap);
                 }
                if(sq.Question__c.contains('$Account.Name')&& !sysValMap.isEmpty() ){
                  questionDetail=fetchPattern(questionDetail,sysValMap);
                }
                selectedOptions = new List<String>();
      }
     /*else if (sq.Type__c=='Multi-Select--Vertical'){
                renderSelectCheckboxes='true';
                multiOptions = stringToSelectOptions(choices);
                renderSelectRadio='false';
                renderFreeText='false';
                renderSelectRow = 'false';
                renderAttachment = 'false';
                renderSystemValues='false';
        //selectedOption = '';
        selectedOptions = new List<String>();
               if(sq.Question__c.contains('$Opportunity.Name')&& !sysValMap.isEmpty() ){
                  questionDetail=fetchPattern(questionDetail,sysValMap);
                }
               if(sq.Question__c.contains('$Account.Name')&& !sysValMap.isEmpty() ){
                  questionDetail=fetchPattern(questionDetail,sysValMap);
                }
      }*/
     else if (sq.Type__c=='Single Select--Horizontal'){
          renderSelectCheckboxes='false';
          rowOptions = stringToSelectOptions(choices);
          renderSelectRadio='false';
          renderFreeText='false';
          renderAttachment = 'false';
          renderSelectRow = 'true';
          renderSelectRadioAttachment='false';
          renderFreeTextAttach='false';
          renderSelectRowAttach='false';
          if(sq.Question__c.contains('$Opportunity.Name')&& !sysValMap.isEmpty() ){
                  questionDetail=fetchPattern(questionDetail,sysValMap);
            }
          if(sq.Question__c.contains('$Account.Name')&& !sysValMap.isEmpty() ){
                  questionDetail=fetchPattern(questionDetail,sysValMap);
            }
        //selectedOption = '';
        selectedOptions = new List<String>();
      }
      else if (sq.Type__c=='Single Select--Horizontal with Attachment'){
          upsert qResponse;
          renderSelectCheckboxes='false';
          rowOptions = stringToSelectOptions(choices);
          renderSelectRadio='false';
          renderFreeText='false';
          renderAttachment = 'false';
          renderSelectRow = 'false';
          renderSelectRadioAttachment='false';
          renderFreeTextAttach='false';
          renderSelectRowAttach='true';
          if(sq.Question__c.contains('$Opportunity.Name')&& !sysValMap.isEmpty() ){
                  questionDetail=fetchPattern(questionDetail,sysValMap);
            }
          if(sq.Question__c.contains('$Account.Name')&& !sysValMap.isEmpty() ){
                  questionDetail=fetchPattern(questionDetail,sysValMap);
            }
        //selectedOption = '';
        selectedOptions = new List<String>();
      }
     else if (sq.Type__c=='Free Text'){
            renderFreeText='true';
            renderSelectRadio='false';
            renderSelectCheckboxes='false';
          renderSelectRow = 'false';
          renderAttachment= 'false';
          renderSelectRadioAttachment='false';
          renderFreeTextAttach='false';
          renderSelectRowAttach='false';
          if(sq.Question__c.contains('$Opportunity.Name')&& !sysValMap.isEmpty() ){
                  questionDetail=fetchPattern(questionDetail,sysValMap);
            }
          if(sq.Question__c.contains('$Account.Name')&& !sysValMap.isEmpty() ){
                  questionDetail=fetchPattern(questionDetail,sysValMap);
            }
          choices=ans;
      }
      else if (sq.Type__c=='Free Text with Attachment'){
            upsert qResponse;
            renderFreeText='false';
            renderSelectRadio='false';
            renderSelectCheckboxes='false';
          renderSelectRow = 'false';
          renderAttachment= 'false';
          renderSelectRadioAttachment='false';
          renderFreeTextAttach='true';
          renderSelectRowAttach='false';
          if(sq.Question__c.contains('$Opportunity.Name')&& !sysValMap.isEmpty() ){
                  questionDetail=fetchPattern(questionDetail,sysValMap);
            }
          if(sq.Question__c.contains('$Account.Name')&& !sysValMap.isEmpty() ){
                  questionDetail=fetchPattern(questionDetail,sysValMap);
            }
          choices=ans;
      }
      else if (sq.Type__c=='Attachment'){
            upsert qResponse;
            renderFreeText='false';
            renderSelectRadio='false';
            renderSelectCheckboxes='false';
          renderSelectRow = 'false';
          renderAttachment='true';
          renderSelectRadioAttachment='false';
          renderFreeTextAttach='false';
          renderSelectRowAttach='false';
          if(sq.Question__c.contains('$Opportunity.Name')&& !sysValMap.isEmpty() ){
                  questionDetail=fetchPattern(questionDetail,sysValMap);
            }
          if(sq.Question__c.contains('$Account.Name')&& !sysValMap.isEmpty() ){
                  questionDetail=fetchPattern(questionDetail,sysValMap);
            }
          choices=ans;
      }    
          System.debug('####renderSelectRowAttach'+renderSelectRowAttach);
        //responses= getResponses();
      }

      private string fetchPattern(String question,Map<String,String>sysValMap){
        String questionUpdated;
        if(question.contains('$Opportunity.Name')){
        Pattern regexPattern = Pattern.compile('$Opportunity.Name');
        Matcher regexMatcher = regexPattern.matcher(question);
        questionUpdated=question.replace('$Opportunity.Name',sysValMap.get('$Opportunity.Name'));
        }
        if(question.contains('$Account.Name')){
        Pattern regexPattern = Pattern.compile('$Account.Name');
        Matcher regexMatcher = regexPattern.matcher(question);
        questionUpdated=question.replace('$Account.Name',sysValMap.get('$Account.Name'));
        }
        return questionUpdated;
    }


       /** Splits up the string as given by the user and adds each option
        *  to a list to be displayed as option on the Visualforce page
        *  param: str   String as submitted by the user
        *  returns the List of SelectOption for the visualforce page
        */
      private List<SelectOption> stringToSelectOptions(String str){
        if (str == '')
        {
            return new List<SelectOption>();
        }
        strList = str.split('\n');

        List<SelectOption> returnVal = new List<SelectOption>();
        Integer i = 0;
        for(String s: strList){
            if (s!='') {
                if (s != 'null' && s!= null) {
                    String sBis = s.replace(' ', '%20');
                    singleOptionsForChart += s.trim()+'|';

                    /*RSC2012-02-20
                    String st = s.replace (' ', '&nbsp;');
                    returnVal.add(new SelectOption(String.valueOf(i),st));
                    */
                    returnVal.add(new SelectOption(String.valueOf(i),s));
                    // returnVal.add(new SelectOption(s,s));
                    System.debug('*****VALUES: ' + s);

                    System.debug('*****AVALUES: ' + selectedOption );
                    System.debug('*****CVALUES: ' + ((selectedOption.trim()).equalsIgnoreCase(s.trim())));
                    if(selectedOption!=''){
                        if(((selectedOption.trim()).equalsIgnoreCase(s.trim()))){

                            selectedOption=String.valueOf(i);
                            System.debug('*****VALUES: ' + selectedOption + '==========index is' + String.valueOf(i));
                        }

                    }
                    if(selectedOptionRow!=''){

                        if((selectedOptionRow.trim()).equalsIgnoreCase(s.trim())){

                            selectedOptionRow=String.valueOf(i);
                            System.debug('*****VALUES: ' + selectedOptionRow + '==========index is' + String.valueOf(i));
                        }

                    }
                    //if(selectedOptions)
                    i++;
                }
            }
        }
        singleOptionsForChart = singleOptionsForChart.substring(0, singleOptionsForChart.length()-1);
        return returnVal;
      }
    }

    public class wrapperClass{

        public List<question> questionList {get;set;}
        public String currentGroupId;
        public String currentGroupName {get;set;}
        public String nextGroupId;
        public String previousGroupId;
        public String answerPat {get;set;}
        public Map<String,Question_Response__c> questionAnsMap;
        public Question_Response__c qResObj {get;set;}
        public Group__c currentGroup {get;set;}
        public String scoreValue {get;set;}
        public Map<String,string> sysValMap=new Map<string,string>();
       //public AssessmentSurvey assessment;

        Map<String,Question_Response__c> questionAnsMapForPerviousGrp;

        public wrapperClass(String cGroup,String nGroup,String pGroup,List<Question__c> qList,Map<Id,Map<String,Question_Response__c>> grpQuestionAnsMap,Group__c groupObj,Map<Id,String> groupNameMap,Map<string,string>SystemValueMap){
            questionAnsMap = new Map<String,Question_Response__c>();
            this.currentGroupId=cGroup;
            this.nextGroupId=nGroup;
            this.previousGroupId=pGroup;
            this.currentGroup=groupObj;
            //System.debug('$$$$SystemValueMap'+SystemValueMap);
            
            this.currentGroupName=groupNameMap.get(ID.valueOf(cGroup));

            if( !(grpQuestionAnsMap.isEmpty()) || grpQuestionAnsMap.size() > 0){

                if(grpQuestionAnsMap.containsKey(cGroup)){

                    questionAnsMap=grpQuestionAnsMap.get(Id.valueOf(cGroup));

                }

            }

            if(!SystemValueMap.isEmpty()){
                this.sysValMap=SystemValueMap;
            }
            System.debug('.......inside the wrapper class current group id----------------.......'+currentGroupId);

            questionList = new List<question>();
            question qObj ;
            if(!currentGroup.IsCalculated__c){
                //get previous response --> check of quesiton type

            for(Question__c obj: qList){

                if(!questionAnsMap.isEmpty()){
                     if(questionAnsMap.containsKey(obj.id)){
                        qResObj=questionAnsMap.get(obj.id);

                        qObj = new question(obj,qResObj,sysValMap);
                        System.debug('======when record found in map=============='+questionAnsMap.get(obj.id));
                     }

                }else {
                    qResObj= new Question_Response__c();
                    qObj = new question(obj,qResObj,sysValMap);
                }


                this.questionList.add(qObj);


            }
        /*}*/
    }else{
                System.debug('**************Id of previous group is '+previousGroupId);
                questionAnsMapForPerviousGrp=grpQuestionAnsMap.get(Id.valueOf(previousGroupId));
                System.debug('**************Id of previous group is '+grpQuestionAnsMap.get(Id.valueOf(previousGroupId)));
                for(Question_Response__c questionresObj:questionAnsMapForPerviousGrp.values()){

                     if(questionresObj.Answer__c!=null){
                            System.debug('**************answer is  '+questionresObj.Answer__c);
                            System.debug('**************answer compaire is  '+questionresObj.Answer__c.equalsIgnoreCase('Yes'));
                        if('Yes'.equalsIgnoreCase(questionresObj.Answer__c.trim())){
                            this.scoreValue='180';
                            break;
                        }else if('No'.equalsIgnoreCase(questionresObj.Answer__c.trim())){
                            this.scoreValue='100';
                            break;
                        }
                    }

                }

    }

        }
    }


}