@IsTest
public class AccountProcessorTest {
    public static testmethod void TestAccountProcessorTest() 
    {
        Account a = new Account();
        a.Name = 'Test Account';
        Insert a;

        Contact cont = New Contact();
        cont.FirstName ='Nimil';
        cont.LastName ='Christopher';
        cont.AccountId = a.Id;
        Insert cont;
        
        List<Id> setAccId = new List<ID>();
        setAccId.add(a.id);
 
        Test.startTest();
            AccountProcessor.countContacts(setAccId);
        Test.stopTest();
        
        Account account = [select Number_of_Contacts__c from Account where id = :a.id LIMIT 1];
        System.assertEquals ( Integer.valueOf(account.Number_of_Contacts__c) ,1);
  }
  
}