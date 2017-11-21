public class SubmitRaceController {
	@AuraEnabled
    public static Race__c newRaceDB(Race__c race){
        insert race;
        return race;
    }
    
    @AuraEnabled
    public static Race__c updateRaceDB(Race__c race){
        update race;
        return race;
    }
}