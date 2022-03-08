@IsTest
public class AddPrimaryContactTest {
	@testSetup 
    static void setup() {
        List<Account> accounts = new List<Account>();
        for (Integer i=0;i<50;i++) {
            accounts.add(new Account(Name='Account '+i, BillingState = 'NY'));
            accounts.add(new Account(Name='Account '+(50+i), BillingState = 'CA'));
        }
        insert accounts;       
    }
    @IsTest
    static void testAddPrimaryContact(){
        String state = 'CA';
        AddPrimaryContact addPrimaryContact = new AddPrimaryContact(new Contact(LastName = 'PrimaryContactForAccountsInNY'), state);
        Test.startTest();
        System.enqueueJob(addPrimaryContact);
        Test.stopTest();
        System.assertEquals(50, [select count() from Contact where accountID IN (SELECT id FROM Account WHERE BillingState = :state)]);
    }
}