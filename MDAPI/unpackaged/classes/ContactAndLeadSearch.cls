public class ContactAndLeadSearch  {
    public static List<List<SObject>> searchContactsAndLeads(String name){
        return [FIND :name IN NAME FIELDS
                   RETURNING Lead,Contact];

    }
}