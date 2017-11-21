@isTest
public class AnimalLocatorTest 
{
    public static testMethod void mytestMethod(){
        Test.SetMock(HttpCallOutMock.class, new AnimalLocatorMock());
        
         String res= AnimalLocator.getAnimalNameById(1);
       
        
        String expectedValue = 'chicken';
        System.assertEquals(res, expectedValue);
        


    }

}