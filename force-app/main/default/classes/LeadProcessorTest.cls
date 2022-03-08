@IsTest
public class LeadProcessorTest {
	@testSetup 
    static void setup() {
        List<Lead> leads = new List<Lead>();
        for (Integer i=0;i<200;i++) {
            leads.add(new Lead(FirstName='Lead FN'+i, LastName = 'Lead LN'+i, Company = 'Company '+i));
        }
        insert leads;       
    }
    @IsTest
    static void testLeadProcessor(){
        Test.startTest();
        LeadProcessor lp = new LeadProcessor();
        Id batchId = Database.executeBatch(lp);
        Test.stopTest();
        System.assertEquals(200, [select count() from Lead where LeadSource = 'Dreamforce']);
    }	
}