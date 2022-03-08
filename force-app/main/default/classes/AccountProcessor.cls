public class AccountProcessor {

    @future
    public static void countContacts(List<Id> accountIDs){
        List<Account> accs =  new List<Account>();
        for(Id i: accountIDs){           
         // Account acc = [SELECT Id, Name FROM Account Where Id =: i LIMIT 1];
          List<Contact> contacts = [Select Id From Contact where AccountId =: i];
            Integer j = contacts.size();
          Account acc = [SELECT Id FROM Account Where Id =: i LIMIT 1];
          acc.Number_of_Contacts__c = j;
		accs.add(acc);
        }       
        update accs;
    }
    
}