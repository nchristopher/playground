trigger AccountAddressTrigger on Account (before insert) {
	for(Account account : trigger.new){
    	if(account.Match_Billing_Address__c && account.BillingPostalCode != null){
    		 account.ShippingPostalCode = account.BillingPostalCode ;
    	}
    }
}