public with sharing class ListRacesApexController {
	@AuraEnabled
    public static List<Race__c> getRacesDB(){
        return [SELECT Id, Name, Race_Type__c, Date_Time__c, Attended__c, Results__c FROM Race__c];
    }
}