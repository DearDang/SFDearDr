@IsTest
public class AccountManagerTest {
   
    static Id createTestRecord() {
        Account acc = new Account(Name='Account 1');
        insert acc;
        Contact cont = new Contact(LastName='Contact 1');
        acc = [Select Id from Account where Name = 'Account 1' LIMIT 1];
        cont.AccountId = acc.Id;
        insert cont;  
        System.debug('Inserted Account Id:= '+acc.Id);
        return acc.Id;
    }
    
 @isTest static void testGetCaseById() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = 'https://ap15.lightning.force.com/services/apexrest/Accounts/'+recordId+'/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Account account = AccountManager.getAccount();
        // Verify results
        System.assert(account != null);
        System.assertEquals('Account 1', account.Name);
    }
}