public class ContactSearch {
    public static List<Contact> searchForContacts(String lastName, String mailingPostCode){
        return [SELECT Id, Name FROM Contact WHERE lastName =:lastName AND MailingPostalCode =:mailingPostCode];
    }
}