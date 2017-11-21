global class AnimalLocator{
    public class Animal {
        public Integer id;
        public String name;
        public String eats;
        public String says;
    }
    
    public class AnimalResult {
    	public Animal animal;
    }

    public Static String getAnimalNameById(integer id){
        List<Object> animal;
        String returnValue ;
        AnimalResult result;
        Http http=new Http();
        HttpRequest request =new HttpRequest();
        request.setEndPoint('https://th-apex-http-callout.herokuapp.com/animals/'+id);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        HttpResponse response= http.send(request);
        if(response.getStatusCode()==200){
	       result = (AnimalResult) JSON.deserialize(response.getBody(), AnimalResult.class);
       	}
        return result.animal.name;

    }
    
}