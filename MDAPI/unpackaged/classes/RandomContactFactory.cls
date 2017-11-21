public class RandomContactFactory {
    public static List<Contact> generateRandomContacts(Integer count, String name) {
        List<Contact> contactList = new List<Contact>();
        
        for(Integer index = 1; index <= count; index++) {
            Contact contact = new Contact();
            contact.FirstName = name + index;
            contactList.add(contact);
        }
        
        return contactList;
    }
}