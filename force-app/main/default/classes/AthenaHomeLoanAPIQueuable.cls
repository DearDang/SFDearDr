public class AthenaHomeLoanAPIQueuable implements Queueable {
	private String payload;
    public AthenaHomeLoanAPIQueuable(String payload){
        this.payload = payload;
    }
    
    public void execute(QueueableContext context){
        try{
            Map<String, Object> dataCreated = new Map<String, Object>();
			AthenaHomeLoanAPIWrapper.AHLAPIRoot root = (AthenaHomeLoanAPIWrapper.AHLAPIRoot) JSON.deserialize(payload, AthenaHomeLoanAPIWrapper.AHLAPIRoot.class);
			List<AthenaHomeLoanAPIWrapper.Body> body = root.body;
			for(Integer i=0; i<body.size(); i++){
				List<AthenaHomeLoanAPIWrapper.Properties> loanApplicationBundlePayload = body[i].properties;
				Map<String, String> loanApplicationBundle = LoanOwnershipController.createLoanApplicationBundle(); 
				String loanApplicationBundleName = loanApplicationBundle.get('loandApplicationBundleName');
				for(Integer j=0; j<loanApplicationBundlePayload.size(); j++){
					AthenaHomeLoanAPIWrapper.Properties loanApplicationPlayload = loanApplicationBundlePayload[j];
					Map<String, Object> loanApplication = new Map<String, Object>();
					loanApplication.put('property', loanApplicationPlayload.property);
					loanApplication.put('propertyType', loanApplicationPlayload.propertyType);
					loanApplication.put('loanAmount', loanApplicationPlayload.loanAmount);
					loanApplication.put('loanTerm', loanApplicationPlayload.loanTerm);
					loanApplication.put('applicants', loanApplicationPlayload.applicants);
					dataCreated = LoanOwnershipController.saveLoanOpportunityForAProperty(loanApplication, loanApplicationBundleName);
                    System.debug('dataCreated: '+dataCreated);
				}
			}
        } catch(Exception e){
            
        }
    }
}