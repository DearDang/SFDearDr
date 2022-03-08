@IsTest
public class AthenaHomeLoanAPIQueuable_Test {
	
    @IsTest
    public static void testAthenaHomeLoanAPIQueuable() {
        StaticResource file = [Select s.Body From StaticResource s Where s.Name = 'AHLAPIPayload'];
		blob tempFile = file.Body;
		String payload = tempFile.toString();
        AthenaHomeLoanAPIQueuable athenaHomeLoanAPIQueuable = new AthenaHomeLoanAPIQueuable(payload);
        Test.startTest();
        System.enqueueJob(athenaHomeLoanAPIQueuable);
        Test.stopTest();
        Property__c property = [Select Id, Name From Property__c Where Name = 'AHL Property 01001' LIMIT 1];
        System.assert(property != null);
        System.debug('property: '+property);
        Opportunity opportunity = [Select Id, Name, Loan_Amount__c, Loan_Term__c, StageName, AccountId, AHL_Opportunity_Identifier__c, Property__c From Opportunity Where Property__r.Id = :property.Id LIMIT 1];
        System.assert(opportunity != null);
        System.debug('opportunity: '+opportunity);
        Account account = [Select Id, Name From Account Where Id = :opportunity.AccountId LIMIT 1];
        System.debug('account: '+account);
        System.assertEquals(account.Name, 'AHL Account 11');
    }
}