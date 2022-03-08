public class LoanOwnershipController {

	public static void updateTotalLoanAmountOnAccountForCreateRecord(List<Loan_Ownership__c> loanOwnershipRecords){
		try{
			System.debug('loanOwnershipRecords: '+loanOwnershipRecords);
			List<Account> accounts = new List<Account>();
			Map<Id, Decimal> accountIds = new Map<Id, Decimal>();
			for(Integer i=0; i<loanOwnershipRecords.size(); i++){
				Loan_Ownership__c loanOwnershipRecord = loanOwnershipRecords[i];
				System.debug('loanOwnershipRecord: '+loanOwnershipRecord);
				if(loanOwnershipRecord.Ownership_Amount__c > 0){
					Id accountId = loanOwnershipRecord.Account__c;
					accountIds.put(accountId, loanOwnershipRecord.Ownership_Amount__c);
				}
			}
			accounts = [Select Id, Total_Loan_Amount__c From Account Where Id IN :accountIds.keySet()];
			for(Account acc: accounts){
				if(acc.Total_Loan_Amount__c == null){
					acc.Total_Loan_Amount__c = 0.0;
				}
				acc.Total_Loan_Amount__c += accountIds.get(acc.Id);
			}
			update accounts;
		} catch (Exception e){
			System.debug('Error in increasing the total loan amount on Account');
		}
	}

	public static void decreaseLoanOwnershipAmountFromAccountForUpdateRecord(List<Loan_Ownership__c> loanOwnershipRecords){
		try{
			List<Account> accounts = new List<Account>();
			Map<Id, Decimal> accountIds = new Map<Id, Decimal>();
			for(Loan_Ownership__c loanOwnershipRecord : loanOwnershipRecords){
				if(loanOwnershipRecord.Ownership_Amount__c > 0){
					Id accountId = loanOwnershipRecord.Account__c;
					accountIds.put(accountId, loanOwnershipRecord.Ownership_Amount__c);
				}
			}
			accounts = [Select Id, Total_Loan_Amount__c From Account Where Id IN :accountIds.keySet()];
			for(Account acc: accounts){
				acc.Total_Loan_Amount__c -= accountIds.get(acc.Id);
			}
			update accounts;   
		} catch (Exception e){
			System.debug('Error in updating the total loan amount on Account');
		}
	}

	public static void increaseLoanOwnershipAmountInAccountForUpdateRecord(List<Loan_Ownership__c> loanOwnershipRecords){
		try{
			List<Account> accounts = new List<Account>();
			Map<Id, Decimal> accountIds = new Map<Id, Decimal>();
			for(Loan_Ownership__c loanOwnershipRecord : loanOwnershipRecords){
				if(loanOwnershipRecord.Ownership_Amount__c > 0){
					Id accountId = loanOwnershipRecord.Account__c;
					accountIds.put(accountId, loanOwnershipRecord.Ownership_Amount__c);
				}
			}
			accounts = [Select Id, Total_Loan_Amount__c From Account Where Id IN :accountIds.keySet()];
			for(Account acc: accounts){
				if(acc.Total_Loan_Amount__c == null){
					acc.Total_Loan_Amount__c = 0.0;
				}
				acc.Total_Loan_Amount__c += accountIds.get(acc.Id);
			}
			update accounts; 
		} catch (Exception e){
			System.debug('Error in updating the total loan amount on Account');
		}
	}

	public static void removeLoanOwnershipAmountFromAccountForDeleteRecord(List<Loan_Ownership__c> loanOwnershipRecords){
		try{
			List<Account> accounts = new List<Account>();
			Map<Id, Decimal> accountIds = new Map<Id, Decimal>();
			for(Loan_Ownership__c loanOwnershipRecord : loanOwnershipRecords){
				if(loanOwnershipRecord.Ownership_Amount__c > 0){
					Id accountId = loanOwnershipRecord.Account__c;
					accountIds.put(accountId, loanOwnershipRecord.Ownership_Amount__c);
				}
			}
			accounts = [Select Id, Total_Loan_Amount__c From Account Where Id IN :accountIds.keySet()];
			for(Account acc: accounts){
				acc.Total_Loan_Amount__c -= accountIds.get(acc.Id);
			}
			update accounts;  
		} catch (Exception e){
			System.debug('Error in decreasing the total loan amount on Accounts');
		}
	}

	public static void resetTotalLoanAmountOnAccounts(){
		try{
			List<Account> accounts = new List<Account>([Select Id, Total_Loan_Amount__c From Account]);
			for(Account acc : accounts){
				System.debug('Before Update: Account Total Loan: '+ acc.Total_Loan_Amount__c);
				acc.Total_Loan_Amount__c = 0.0;
				System.debug('After Reset: Account Total Loan: '+ acc.Total_Loan_Amount__c);
				List<Loan_Ownership__c> loanOwnerShips = [Select Id, Name, Ownership_Amount__c From Loan_Ownership__c Where Account__r.Id = :acc.Id];
				for(Loan_Ownership__c loan : loanOwnerShips){
					acc.Total_Loan_Amount__c += loan.Ownership_Amount__c;
				}
				System.debug('After Update: Account Total Loan: '+ acc.Total_Loan_Amount__c);
			}
			update accounts;
		} catch (Exception e){
			System.debug('Error in resetting the total loan amount on Accounts');
		}
	}

	@AuraEnabled
	public static Map<String, Object> saveLoanOpportunityForAProperty(Map<String, Object> loanApplication, String loanApplicationBundleName){
		try{
			//{applicants=({applicantIdentifier=AHL001_A1, applicantLoanIdentifier=AHL001, customer=, expense=0, income=0, ownership=100, primaryApplicant=false}), loanAmount=0, loanApplicationIdentifier=AHL001, loanApplicationheader=Property Loan 1, loanTerm=0, property=dasdadsadsa}
			system.debug('loanApplication: '+loanApplication);
			Map<String, Object> returnData = new Map<String, Object>();
			Decimal loanAmount = Decimal.valueOf((String)loanApplication.get('loanAmount'));
			Integer loanTerm =  Integer.valueOf((String)loanApplication.get('loanTerm'));
			String propertyName = (String) loanApplication.get('property');
			String propertyType = (String) loanApplication.get('propertyType');
			List<Object> applicants =  (List<Object>) loanApplication.get('applicants');
			List<String> sObjectsList = new List<String>{'Loan_Application__c', 'Property__c', 'Opportunity', 'Account'};
			RecordType[] ahlRecordTypes = [Select Id, Name, SobjectType From RecordType Where Name = 'Athena Home Loan' And SobjectType IN :sObjectsList];
			Id loanApplicationRecordTypeId, popertyRecordTypeId, opportunityRecordTypeId, accountRecordTypeId, propertyId, opportunityId, loandApplicationBundleId;
			for(Integer i=0; i<ahlRecordTypes.size(); i++){
				switch on (ahlRecordTypes[i].SobjectType){
				when 'Loan_Application__c' {
					loanApplicationRecordTypeId = ahlRecordTypes[i].Id;
				}
				when 'Property__c' {
					popertyRecordTypeId = ahlRecordTypes[i].Id;
				}
				when 'Opportunity' {
					opportunityRecordTypeId = ahlRecordTypes[i].Id;
				}
				when 'Account' {
					accountRecordTypeId = ahlRecordTypes[i].Id;
				}
				}
			}
			Property__c property = new Property__c();
			property.Type__c = propertyType;
			property.Name = propertyName;
			property.RecordTypeId = popertyRecordTypeId;
			Database.SaveResult propertySaveResult = Database.insert(property, true);
			propertyId = propertySaveResult.getId();
			property = [Select Id, Name From Property__c Where Id = :propertyId LIMIT 1];
			returnData.put('Property__c', property);
			returnData.put('propertyId', propertyId);
			system.debug('propertyId: '+propertyId);
			if(propertySaveResult.isSuccess()){
				List<Loan_Application__c> loanApplicationBundles = [Select Id, Name From Loan_Application__c Where Name =: loanApplicationBundleName];
				Loan_Application__c loanApplicationBundle;
				system.debug('loanApplicationBundles: '+loanApplicationBundles);
				if(loanApplicationBundles.size() == 0){   
					loanApplicationBundle = new Loan_Application__c();
					loanApplicationBundle.RecordTypeId = loanApplicationRecordTypeId;
					Database.SaveResult loanApplicationBundleSaveResult = Database.insert(loanApplicationBundle, true);
					loandApplicationBundleId = loanApplicationBundleSaveResult.getId();
					loanApplicationBundle =  [Select Id, Name From Loan_Application__c Where Id =: loandApplicationBundleId];
				} else {
					loanApplicationBundle = loanApplicationBundles[0];
					loandApplicationBundleId = loanApplicationBundle.Id;
				}
				system.debug('loanApplicationBundleId: '+loandApplicationBundleId);
				returnData.put('Loan_Application__c', loanApplicationBundle);
				returnData.put('loanApplicationBundleId', loandApplicationBundleId);
                returnData.put('loanApplicationBundleName', loanApplicationBundle.Name);
				List<Loan_Ownership__c> loanOwnershipList = new List<Loan_Ownership__c>();
				for(Object applicantObject : applicants){
					String applicantData = JSON.serialize(applicantObject);
					Map<String, Object> applicant = (Map<String, Object>) JSON.deserializeUntyped(applicantData);
					String applicantIdentifier = (String) applicant.get('applicantIdentifier');
					String applicantLoanIdentifier = (String) applicant.get('applicantLoanIdentifier');
					String applicantName = (String) applicant.get('customer');
					Decimal applicantExpense = Decimal.valueOf((String) applicant.get('expense'));
					Decimal applicantIncome = Decimal.valueOf((String) applicant.get('income'));
					Decimal applicantLoanOwnership = Decimal.valueOf((String)applicant.get('ownership'));
					Boolean isPrimaryApplicant = Boolean.valueOf(applicant.get('primaryApplicant'));
					system.debug('isPrimaryApplicant.Id: '+isPrimaryApplicant);
					List<Account> applicantAccounts = [Select Id, Name, Income__c, Expense__c From Account Where Name = :applicantName And RecordTypeId =:accountRecordTypeId];
					Account applicantAccount;
					if(applicantAccounts.size() == 0){
						applicantAccount = new Account();
						applicantAccount.Name = applicantName;
						applicantAccount.Income__c = applicantIncome;
						applicantAccount.Expense__c = applicantExpense;
						applicantAccount.RecordTypeId = accountRecordTypeId;
						Database.SaveResult accountSaveResult = Database.insert(applicantAccount, true);
						applicantAccount.Id = accountSaveResult.getId();  
						system.debug('applicantAccount.Id: '+applicantAccount.Id);

					} else{
						applicantAccount = applicantAccounts[0];
					}
					System.debug('applicantAccount: '+applicantAccount);
					if(isPrimaryApplicant && opportunityId==null){
						Opportunity opportunity = new Opportunity();
						opportunity.Name = 'OpprtunityDraftName';
						opportunity.Loan_Amount__c = loanAmount;
						opportunity.Loan_Term__c = loanTerm;
						opportunity.Loan_Application__c = loandApplicationBundleId;
						opportunity.StageName = 'New';
						opportunity.Property__c = propertyId;
						opportunity.RecordTypeId = opportunityRecordTypeId;
						opportunity.AccountId = applicantAccount.Id;
						opportunity.CloseDate = Date.parse('12/12/2021');
						Database.SaveResult opportunitySaveResult = Database.insert(opportunity, false);
						opportunityId = opportunitySaveResult.getId();
						system.debug('opportunityId: '+opportunityId);
						opportunity = [Select Id, Name, Loan_Amount__c, Loan_Term__c, StageName, AccountId, AHL_Opportunity_Identifier__c From Opportunity Where Id = :opportunityId LIMIT 1];
						opportunity.Name = opportunity.AHL_Opportunity_Identifier__c;
						update opportunity;
						returnData.put('Opportunity', opportunity);
						returnData.put('opportunityId', opportunityId);   
						Account account = [Select Id, Name From Account Where Id = :applicantAccount.Id LIMIT 1];
						returnData.put('Account', account);
					}
					Loan_Ownership__c loanOwnership = new Loan_Ownership__c();
					loanOwnership.Account__c = applicantAccount.Id;
					loanOwnership.Ownership_Percentage__c = applicantLoanOwnership;
					loanOwnershipList.add(loanOwnership);
				}
				for(Loan_Ownership__c loanOwnership : loanOwnershipList){
					loanOwnership.Opportunity__c = opportunityId;
				}
				Database.SaveResult[] loanOwnershipSaveResult = Database.insert(loanOwnershipList, true);
				system.debug('loanOwnershipSaveResult: '+loanOwnershipSaveResult);
			} 
			return returnData;
		} catch (Exception e){
			throw new AuraHandledException('Error in Saving Loan Application');
		}
	}

	@AuraEnabled
	public static Map<String, String> createLoanApplicationBundle(){  
		try{
			Map<String, String> returnData = new Map<String, String>();
			String loandApplicationBundleId = '';
			RecordType[] ahlRecordTypes = [Select Id, Name, SobjectType From RecordType Where Name = 'Athena Home Loan' And SobjectType = 'Loan_Application__c'];
			Id loanApplicationRecordTypeId;
			if(ahlRecordTypes.size()>0){
				loanApplicationRecordTypeId = ahlRecordTypes[0].Id;
			}
			Loan_Application__c loanApplicationBundle = new Loan_Application__c();
			loanApplicationBundle.RecordTypeId = loanApplicationRecordTypeId;
			Database.SaveResult loanApplicationBundleSaveResult = Database.insert(loanApplicationBundle, true);
			loandApplicationBundleId = loanApplicationBundleSaveResult.getId();
			loanApplicationBundle  = [Select Id, Name From Loan_Application__c Where Id =:loandApplicationBundleId LIMIT 1];
			returnData.put('loandApplicationBundleId', loanApplicationBundle.Id);
			returnData.put('loandApplicationBundleName', loanApplicationBundle.Name);
			return returnData;
		} catch (Exception e){
			throw new AuraHandledException('Error in Creating Loan Application Bundle');
		}
	}

	@AuraEnabled
	public static List<String> getPropertyTypePicklistValues(){
		try{
			List<String> propertyTypes = new List<String>();
			Schema.DescribeFieldResult fieldResult = Property__c.Type__c.getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for( Schema.PicklistEntry pickListVal : ple){
				propertyTypes.add(pickListVal.getLabel());
			}            
			System.debug('propertyTypes: '+propertyTypes);
			return propertyTypes;
		} catch (Exception e){
			throw new AuraHandledException('Error in Initializing Property Type picklist values');
		}
	}

	public static void handleAthenaHomeLoanEvent(List<AthenaHomeLoanPE__e>  athenaHomeLoanPEs ){
        try{
            for(AthenaHomeLoanPE__e athenaHomeLoanPE : athenaHomeLoanPEs){
                String payload = athenaHomeLoanPE.LoanPayload__c;
                AthenaHomeLoanAPIQueuable athenaHomeLoanAPIQueuable = new AthenaHomeLoanAPIQueuable(payload);
                ID jobID = System.enqueueJob(athenaHomeLoanAPIQueuable);
                System.debug('Job enqueued with Job Id as: '+jobID);
            }
        } catch (Exception e){
			System.debug('Error in processing Platfrom Event');
		}
	}
    
    public static Map<String, Object> createLoanApplication(String payload){
        Map<String, Object> dataCreated = new Map<String, Object>();
        try{
            AthenaHomeLoanAPIWrapper.AHLAPIRoot root = (AthenaHomeLoanAPIWrapper.AHLAPIRoot) JSON.deserialize(payload, AthenaHomeLoanAPIWrapper.AHLAPIRoot.class);
			List<AthenaHomeLoanAPIWrapper.Body> body = root.body;
			for(Integer i=0; i<body.size(); i++){
				List<AthenaHomeLoanAPIWrapper.Properties> loanApplicationBundlePayload = body[i].properties;
				Map<String, String> loanApplicationBundle = createLoanApplicationBundle(); 
				String loanApplicationBundleName = loanApplicationBundle.get('loandApplicationBundleName');
				dataCreated.put('loanApplicationBundleName', loanApplicationBundleName);
            	for(Integer j=0; j<loanApplicationBundlePayload.size(); j++){
					AthenaHomeLoanAPIWrapper.Properties loanApplicationPlayload = loanApplicationBundlePayload[j];
					Map<String, Object> loanApplication = new Map<String, Object>();
					loanApplication.put('property', loanApplicationPlayload.property);
					loanApplication.put('propertyType', loanApplicationPlayload.propertyType);
					loanApplication.put('loanAmount', loanApplicationPlayload.loanAmount);
					loanApplication.put('loanTerm', loanApplicationPlayload.loanTerm);
					loanApplication.put('applicants', loanApplicationPlayload.applicants);
					dataCreated = saveLoanOpportunityForAProperty(loanApplication, loanApplicationBundleName);
				}
			}
            return dataCreated;
        } catch (Exception e){
			System.debug('Error in processing Platfrom Event');
             return null;
		}
    }
}