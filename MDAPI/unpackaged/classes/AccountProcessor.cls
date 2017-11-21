public class AccountProcessor {
	@future
    public static void countContacts(List<Id> accountsList){
        List<Account> accountsToUpdate = new List<Account>();
        for(Account account : [SELECT ID, Number_of_Contacts__c,(SELECT ID FROM CONTACTS) FROM Account where id in: accountsList]){
            account.Number_of_Contacts__c = account.contacts.size();
            accountsToUpdate.add(account);
        }
        update accountsToUpdate;
    }
}