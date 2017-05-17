public with sharing class UploadFileController {

    public Attachment attObj {get;set;}
    String parentId {get;set;}
    List<Attachment> attList {get;set;}

    public UploadFileController() {
         attObj = new Attachment();
         parentId=Apexpages.currentPage().getParameters().get('qRespId');
         attList=[select id ,name,body from Attachment where parentId=:parentId order by createddate desc];
         if(!attList.isEmpty()){
            attObj.name=attList[0].name;
            attObj.body=attList[0].body;

         }
    }

    public void  uploadAttach(){
          System.debug('&&&& parentId'+parentId);
          attObj.ParentId=parentId;
          insert attObj;
         }


}