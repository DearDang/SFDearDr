@IsTest
public class AthenaHomeLoanRESTAPI_Test {
	
    @IsTest
    public static void testCreateLoanApplication(){
        StaticResource file = [Select s.Body From StaticResource s Where s.Name = 'AHLAPIPayload'];
		blob tempFile = file.Body;
		String payload = tempFile.toString();
        RestRequest request = new RestRequest();
        request.requestUri = 'https://deardr-dev-ed.my.salesforce.com/services/apexrest/Loan_Application__c/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(payload);
        RestContext.request = request;
        Test.startTest();
        AthenaHomeLoanRESTAPI.createLoanApplication();
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
    
    @IsTest
    public static void testGetLoanApplicationData(){
        StaticResource file = [Select s.Body From StaticResource s Where s.Name = 'AHLAPIPayload'];
		blob tempFile = file.Body;
		String payload = tempFile.toString();
		Map<String, Object> dataCreated  = LoanOwnershipController.createLoanApplication(payload);
        System.debug('dataCreated: '+ dataCreated);
        String recordId = String.valueof(dataCreated.get('loanApplicationBundleName'));
        System.debug('recordId: '+ recordId);
        RestRequest request = new RestRequest();
		request.requestUri = 'https://deardr-dev-ed.my.salesforce.com/services/apexrest/Loan_Application__c/' + recordId;
		request.httpMethod = 'GET';	
		RestContext.request = request;
        String returnString = AthenaHomeLoanRESTAPI.getLoanApplicationData();
        System.debug('returnString: '+ returnString);
        
    }
}