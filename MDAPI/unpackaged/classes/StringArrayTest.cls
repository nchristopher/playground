public class StringArrayTest {
	
    public static List<String> generateStringArray(Integer numberOfString){
        List<String> stringsToReturn = new List<String>();
        if(numberOfString > 0 ){
            for(Integer i=0; i < numberOfString; i++){
                stringsToReturn.add('Test ' + i);
            }
            return stringsToReturn;
        }else{
        	return null;
        }
    }
}