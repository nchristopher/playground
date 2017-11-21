@isTest
private class TestVerifyDate {

    @isTest static void testin(){
        
        date D = verifydate.CheckDates(date.newInstance(2015, 04, 30),date.newInstance(2015, 05, 15));
        system.assertequals(date.newInstance(2015, 05, 15),D);
    }
    
    @isTest static void testout(){
        
        date M = verifydate.CheckDates(date.newInstance(2015, 04, 27),date.newInstance(2015, 06, 15));
        system.assertEquals(date.newInstance(2015, 04, 30), M);
    }
}