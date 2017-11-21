public class AccountHandler{
	public static Account insertNewAccount(String nameOfTheAccount){
		try{
			Account accountToInsert = new Account();
			accountToInsert.Name = nameOfTheAccount;
			insert accountToInsert;
			return accountToInsert;
		}catch(DMLException e){
			return null;
		}
	}
}