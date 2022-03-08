@IsTest
public class TestRestrictContactByName {

    @IsTest static void test1(){
        Contact cont = new Contact(LastName = 'INVALIDNAME');
        Test.startTest();
        Database.UpsertResult result = Database.upsert(cont, false);
        Test.stopTest();
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('The Last Name "'+cont.LastName+'" is not allowed for DML',
                             result.getErrors()[0].getMessage());
    }
    
    @IsTest static void test2(){
        Contact cont = new Contact(LastName = 'VALIDNAME');
        Test.startTest();
        Database.UpsertResult result = Database.upsert(cont, false);
        Test.stopTest();
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
    }
    
    
}