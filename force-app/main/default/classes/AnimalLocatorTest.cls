@IsTest
public class AnimalLocatorTest {
	@IsTest
    static void testAnimalLocator(){
         Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock()); 
       // HttpResponse response = AnimalLocator.getAnimalNameById(1);
        //String contentType = response.getHeader('Content-Type');
         //System.assert(contentType == 'application/json');
        String actualValue = AnimalLocator.getAnimalNameById(1);
        System.debug(actualValue);
        System.assertEquals(actualValue, 'MyAnimal');
    }
}