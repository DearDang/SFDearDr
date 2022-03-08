@IsTest
public class LoanOwnershipController_Test {
	
    @TestSetup
    public static void createAccountAndLoanOwnershiRecords(){
     	Account acc = New Account();
        acc.Name = 'TestAccount_1';
        acc.Total_Loan_Amount__c = 0.0;
        insert acc;
        Opportunity opp = New Opportunity();
        opp.Name = 'TestOpp_1';
        opp.Loan_Amount__c = 1000000.00;
        opp.StageName = 'Prospecting';
        opp.CloseDate = Date.newInstance(2020, 12, 31);
        insert opp;
    }
    
    @IsTest
    public static void testUpdateTotalLoanAmountOnAccountForNewRecords(){
        Account acc = [Select Id, Name, Total_Loan_Amount__c From Account Where Name = 'TestAccount_1' LIMIT 1];
        Decimal existingTotalLoanAmountOnAccount = acc.Total_Loan_Amount__c;
        System.debug('existingTotalLoanAmountOnAccount: '+existingTotalLoanAmountOnAccount);
        Opportunity opp = [Select Id, Name, Loan_Amount__c From Opportunity Where Name = 'TestOpp_1' LIMIT 1];
        System.debug('OpportunityAmount: '+opp.Loan_Amount__c);
       	Loan_Ownership__c loanOwnerShip = new Loan_Ownership__c();
        loanOwnerShip.Account__c = acc.Id;
        loanOwnerShip.Opportunity__c = opp.Id;
        loanOwnerShip.Ownership_Percentage__c = 50.00;
        Test.startTest();
        insert loanOwnerShip;
        Test.stopTest();
        loanOwnerShip  = [Select Id, Ownership_Percentage__c, Ownership_Amount__c From Loan_Ownership__c Where Account__r.Id = :acc.Id LIMIT 1];
        System.debug('loanOwnerShip.Ownership_Amount__c: '+loanOwnerShip.Ownership_Amount__c);
        Decimal expectedTotalLoanAmountOnAccount = existingTotalLoanAmountOnAccount + loanOwnerShip.Ownership_Amount__c;
        System.debug('expectedTotalLoanAmountOnAccount: '+expectedTotalLoanAmountOnAccount);
        acc = [Select Id, Name, Total_Loan_Amount__c From Account Where Name = 'TestAccount_1' LIMIT 1];
        Decimal actualTotalLoanAmountOnAccount = acc.Total_Loan_Amount__c;
        System.debug('actualTotalLoanAmountOnAccount: '+actualTotalLoanAmountOnAccount);
        System.assertEquals(expectedTotalLoanAmountOnAccount, actualTotalLoanAmountOnAccount);
        expectedTotalLoanAmountOnAccount = opp.Loan_Amount__c*loanOwnerShip.Ownership_Percentage__c/100;
        System.debug('expectedTotalLoanAmountOnAccount_Calculated: '+expectedTotalLoanAmountOnAccount);
        System.assertEquals(expectedTotalLoanAmountOnAccount, actualTotalLoanAmountOnAccount);
    }
    
    @IsTest
    public static void testUpdateTotalLoanAmountOnAccountForExistingRecords(){
        Account acc = [Select Id, Name, Total_Loan_Amount__c From Account Where Name = 'TestAccount_1' LIMIT 1];
        Decimal existingTotalLoanAmountOnAccount = acc.Total_Loan_Amount__c;
        System.debug('existingTotalLoanAmountOnAccount: '+existingTotalLoanAmountOnAccount);
        Opportunity opp = [Select Id, Name, Loan_Amount__c From Opportunity Where Name = 'TestOpp_1' LIMIT 1];
        System.debug('OpportunityAmount: '+opp.Loan_Amount__c);
       	Loan_Ownership__c loanOwnerShip = new Loan_Ownership__c();
        loanOwnerShip.Account__c = acc.Id;
        loanOwnerShip.Opportunity__c = opp.Id;
        loanOwnerShip.Ownership_Percentage__c = 50.00;
        insert loanOwnerShip;
        loanOwnerShip  = [Select Id, Ownership_Percentage__c, Ownership_Amount__c From Loan_Ownership__c Where Account__r.Id = :acc.Id LIMIT 1];
        System.debug('loanOwnerShip.Ownership_Amount__c: '+loanOwnerShip.Ownership_Amount__c);               
        loanOwnerShip.Ownership_Percentage__c = 80.00;
        Test.startTest();
        update loanOwnerShip;
        Test.stopTest();
        Decimal expectedTotalLoanAmountOnAccount = opp.Loan_Amount__c*loanOwnerShip.Ownership_Percentage__c/100;
        expectedTotalLoanAmountOnAccount += existingTotalLoanAmountOnAccount;
        acc = [Select Id, Name, Total_Loan_Amount__c From Account Where Name = 'TestAccount_1' LIMIT 1];
        Decimal actualTotalLoanAmountOnAccount = acc.Total_Loan_Amount__c;
        System.assertEquals(expectedTotalLoanAmountOnAccount, actualTotalLoanAmountOnAccount);
    }
    
    @IsTest
    public static void testUpdateTotalLoanAmountOnAccountForDeletingRecords(){
        Account acc = [Select Id, Name, Total_Loan_Amount__c From Account Where Name = 'TestAccount_1' LIMIT 1];
        Decimal existingTotalLoanAmountOnAccount = acc.Total_Loan_Amount__c;
        System.debug('existingTotalLoanAmountOnAccount: '+existingTotalLoanAmountOnAccount);
        Opportunity opp = [Select Id, Name, Loan_Amount__c From Opportunity Where Name = 'TestOpp_1' LIMIT 1];
        System.debug('OpportunityAmount: '+opp.Loan_Amount__c);
       	Loan_Ownership__c loanOwnerShip = new Loan_Ownership__c();
        loanOwnerShip.Account__c = acc.Id;
        loanOwnerShip.Opportunity__c = opp.Id;
        loanOwnerShip.Ownership_Percentage__c = 50.00;
        insert loanOwnerShip;
        loanOwnerShip  = [Select Id, Ownership_Percentage__c, Ownership_Amount__c From Loan_Ownership__c Where Account__r.Id = :acc.Id LIMIT 1];
        System.debug('loanOwnerShip.Ownership_Amount__c: '+loanOwnerShip.Ownership_Amount__c);        
        Test.startTest();
        delete loanOwnerShip;
        Test.stopTest();
        Decimal expectedTotalLoanAmountOnAccount = existingTotalLoanAmountOnAccount;
        acc = [Select Id, Name, Total_Loan_Amount__c From Account Where Name = 'TestAccount_1' LIMIT 1];
        Decimal actualTotalLoanAmountOnAccount = acc.Total_Loan_Amount__c;
        System.debug('actualTotalLoanAmountOnAccount: '+actualTotalLoanAmountOnAccount);
        System.assertEquals(expectedTotalLoanAmountOnAccount, actualTotalLoanAmountOnAccount);
    }
    
    @IsTest
    public static void testHandleAthenaHomeLoanEvent() {
        StaticResource file = [Select s.Body From StaticResource s Where s.Name = 'AHLAPIPayload'];
		blob tempFile = file.Body;
		String payload = tempFile.toString();
        AthenaHomeLoanPE__e athenaHomeLoanPE = new AthenaHomeLoanPE__e();
        athenaHomeLoanPE.LoanPayload__c = payload;
        List<AthenaHomeLoanPE__e> athenaHomeLoanPEList = new List<AthenaHomeLoanPE__e>();
        athenaHomeLoanPEList.add(athenaHomeLoanPE);
        Test.startTest();
        LoanOwnershipController.handleAthenaHomeLoanEvent(athenaHomeLoanPEList); 
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