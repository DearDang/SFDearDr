public class AnimalLocator {
 	public static String getAnimalNameById(Integer Id) {
        String animalName = '';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+Id);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            // Deserializes the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            // Map<Object> animals = (Map<Object>) results.get('animals');
            
            // Cast the values in the 'animals' key as a list
            Map<String, Object> animal = (Map<String, Object>) results.get('animal');
            System.debug('Received the following animal:');
            animalName = (String)animal.get('name');
            System.debug('animalName');
        }
        return animalName;
    }
}