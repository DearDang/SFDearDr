@IsTest
public class AccountProcessorTest {
    @IsTest
    static void testAccountPorcessorWithOneContact(){
        String name = 'NewAccount2';
        Account newAccount = new Account(Name = name);
    	insert newAccount;
    	Contact newContact = new Contact(LastName='NewContact2');
    	Account acc = [Select Id from Account where Name =: name LIMIT 1];
        newContact.AccountId = acc.Id;
    	insert newContact;
        Test.startTest();
        List<Id> ids = new List<Id>{acc.Id};
        AccountProcessor.countContacts(ids);
        Test.stopTest();
        acc = [Select Id, Number_of_Contacts__c from Account where Name =: name LIMIT 1];
        //Decimal i = acc.Number_of_Contacts_c__c;
        System.assertEquals(1, acc.Number_of_Contacts__c);
        
    }
	
    
}