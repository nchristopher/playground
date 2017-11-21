public class LDSController {
    @AuraEnabled
    public static List < Lead > getHitsLead(string srchstring) {
        list < Lead > c = [select Name, Id, Email from Lead limit 4];
        return c;
    }
    @AuraEnabled
    public static List < Account > getHitsAcc(string srchstring) {
        System.DEBUG('srchstring : ' + srchstring);
        String searchQueryString = '%' + srchstring + '%';
        list < Account > c = [select Name, Id from Account WHERE Name LIKE :searchQueryString LIMIT 100];
        return c;
    }
    @AuraEnabled
    public static void connectToER(list < id > Ids) {
        System.DEBUG('Ids : ' + Ids);
    }
}