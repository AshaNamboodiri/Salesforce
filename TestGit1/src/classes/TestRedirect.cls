public with sharing class TestRedirect {

    public boolean toBeValidated{get;set;}
    public String isValid{get;set;}
    
    public Integer code{get;set;}
    
    public void onLoad(){
        toBeValidated=true;
    }
    
    public void validate(){
        if(code==1234){
           isValid='true';
           
        }
        else {
        isValid='false';
        }
        toBeValidated=false;
    }
}