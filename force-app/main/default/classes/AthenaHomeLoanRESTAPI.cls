@RestResource(urlMapping='/Loan_Application__c/*')
global class AthenaHomeLoanRESTAPI {

	@HttpPost
	global static String createLoanApplication(){
		try{
			RestRequest request = RestContext.request;
			String payload = request.requestBody.toString();
			Map<String, Object> dataCreated = LoanOwnershipController.createLoanApplication(payload);
            System.debug('dataCreated: '+dataCreated);
			return 'Success';
		} catch(Exception e){
			return 'Error';
		}
	}
    
    @HttpGet
    global static String getLoanApplicationData(){
		try{
			RestRequest request = RestContext.request;
            String requestParameter = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
            Map<String, Object> property = new Map<String, Object>();
            List<Object> properties = new List<Object>();
            List<Opportunity> opportunityList = new List<Opportunity>();
            if(requestParameter.startsWith('AHLLAN-')){
                opportunityList = [Select Id, Name, Loan_Amount__c, Loan_Term__c, AccountId, Property__r.Name, Property__r.Type__c From Opportunity Where Loan_Application__r.Name = :requestParameter ];
            } else if(requestParameter.startsWith('AHLLOI-')){
                opportunityList = [Select Id, Name, Loan_Amount__c, Loan_Term__c, AccountId, Property__r.Name, Property__r.Type__c From Opportunity Where AHL_Opportunity_Identifier__c = :requestParameter];
            }
            for(Opportunity opportunity : opportunityList){
                //opportunityopportunity = [Select Id, Name, Loan_Amount__c, Loan_Term__c, AccountId  From Opportunity Where AHL_Opportunity_Identifier__c = :requestParameter ];
                List<Loan_Ownership__c> loanOwnershipList = [Select Id, Name, Account__r.Id, Ownership_Percentage__c  From Loan_Ownership__c Where Opportunity__r.Id = :opportunity.Id ];
                Map<Id, Map<String, String>> applicantData = new Map<Id, Map<String, String>>();
                for(Loan_Ownership__c loanOwnership : loanOwnershipList){
                    Map<String, String> dataFromLoanOwnership = new Map<String, String>();
                    dataFromLoanOwnership.put('ownership', String.valueOf(loanOwnership.Ownership_Percentage__c));
                    applicantData.put(loanOwnership.Account__r.Id, dataFromLoanOwnership); 
                }
                List<Account> applicantsList = [Select Id, Name, Income__c, Expense__c From Account Where Id IN :applicantData.keySet()];
                Map<String, String> applicantMap = new Map<String, String>();
                List<Map<String, String>> applicants = new List<Map<String, String>>();
				for(Account applicant : applicantsList){
                    applicantMap.put('customer', String.valueOf(applicant.Name));
                    applicantMap.put('income', String.valueOf(applicant.Income__c));
                    applicantMap.put('expense', String.valueOf(applicant.Expense__c));
                    applicantMap.put('ownership', applicantData.get(applicant.Id).get('ownership'));
                    if(applicant.Id == opportunity.AccountId){
                        applicantMap.put('primaryApplicant', 'true'); 
                    } else {
                        applicantMap.put('primaryApplicant', 'false'); 
                    } 
                    applicants.add(applicantMap);
                }
                property.put('applicants', applicants);
                property.put('loanAmount', opportunity.Loan_Amount__c);
                property.put('loanTerm',  opportunity.Loan_Term__c);
                property.put('property', opportunity.Property__r.Name);
                property.put('propertyType', opportunity.Property__r.Type__c); 
                properties.add(property);
            }
            Map<String, Object> popertiesInBody = new Map<String, Object>();
            popertiesInBody.put('properties', properties);
            List<Object> propertiesArrayInJSON = new List<Object>();
            propertiesArrayInJSON.add(popertiesInBody);
            Map<String, Object> bodyInJSON = new Map<String, Object>();
            bodyInJSON.put('body', propertiesArrayInJSON);
            String returnString = JSON.serialize(bodyInJSON);
			return returnString;
		} catch(Exception e){
			return 'Error';
		}
	}
    
}