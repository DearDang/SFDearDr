({
	doInit : function(component, event, helper) {
		var accountsAvailable = component.get("v.loanOwnershipRecordList");
        
       
	},
    
    addNewLoanOwnerShipRecord : function(component, helper){
        var loanOwnershipRecordList = component.get("v.loanOwnershipRecordList");
        var indexOfApplicant = loanOwnershipRecordList.length;
        var applicantId = `A${indexOfApplicant+1}`;
        var loanOwnershipRecord = {
            ApplicantID: applicantId,
            Customer: '',
            Ownership : 0.0,
            PrimaryApplicant : false
        };
        loanOwnershipRecordList.push(loanOwnershipRecord);
        component.set("v.loanOwnershipRecordList", loanOwnershipRecordList);
    },
    
    changePrimaryApplicant : function(component, event, helper){
        var selectedApplicantId = event.getSource().get("v.value");
        //if(selectedAsPrimaryApplicant){
			var loanOwnershipRecordList = component.get("v.loanOwnershipRecordList");
            for(var i=0; i<loanOwnershipRecordList.length; i++){
                var loanOwnershipRecord = loanOwnershipRecordList[i];
                if(loanOwnershipRecord.applicantId == selectedApplicantId){
                    loanOwnershipRecord.PrimaryApplicant = true;
                } else {
                    loanOwnershipRecord.PrimaryApplicant = false;
                }
                loanOwnershipRecordList[i] = loanOwnershipRecord;
            }
           // event.getSource().set("v.value", true);
        //}
        component.set("v.loanOwnershipRecordList", loanOwnershipRecordList);
    },
    
    saveNewLoanOpportunity : function(component, helper){
        
    },
    
    cancelDialog : function(component, helper) {
        var homeEvt = $A.get("e.force:navigateToObjectHome");
		homeEvt.setParams({
    		"scope": "Opportunity"
		});
		homeEvt.fire();
	}
})