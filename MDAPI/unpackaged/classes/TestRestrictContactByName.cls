@isTest
public class TestRestrictContactByName {
    @isTest
    static void RestrictContactByName_Test_CheckIfContactAdded(){
        Contact testContact = new Contact(FirstName = 'TestFirst', LastName = 'TestLast');
        insert testContact;
        
        System.assertEquals([SELECT FirstName FROM Contact WHERE Id =: testContact.Id].FirstName, 'TestFirst');
    }
    
    @isTest
    static void RestrictContactByName_Test_CheckIfContactNotAdded(){
        Contact testContact = new Contact(FirstName = 'TestFirst', LastName = 'INVALIDNAME');
        try{
        	insert testContact;
        }catch(Exception e){
            System.AssertEquals(e.getMessage(),'Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, The Last Name "INVALIDNAME" is not allowed for DML: []');
        }
        
    }
}