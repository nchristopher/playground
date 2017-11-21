@isTest
private class ParkLocatorTest {
    @isTest static void testCallout() {              
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
  
        String country = 'UK';
    
        System.assertEquals(new List<String>{'London', 'Nottingham', 'Sheffield'}, ParkLocator.country(country)); 
    }
}