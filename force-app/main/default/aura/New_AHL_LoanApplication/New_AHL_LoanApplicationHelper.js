({
    helperMethod: function () {},

    createNewLoanApplicationBundle: function (component) {
        var promise = new Promise($A.getCallback(function (resolve, reject) {
                    var action = component.get("c.createLoanApplicationBundle");
                    action.setParams({});
                    action.setCallback(this, function (response) {
                        var results = response.getReturnValue();
                        var state = response.getState();
                        if (state == "SUCCESS") {
                            resolve(response.getReturnValue());
                        }
                    })
                    $A.enqueueAction(action);
                }));
        return promise;
    },

    saveLoanApplication: function (component, event) {
        var loanApplicationBundleName = component.get("v.loanApplicationBundle");
        var loanApplication = event.getSource().get("v.value");
        var action = component.get("c.saveLoanOpportunityForAProperty");
        action.setParams({
            loanApplication: loanApplication,
            loanApplicationBundleName: loanApplicationBundleName
        });
        component.set("v.pageLoaded", false);
        action.setCallback(this, function (response) {
            var results = response.getReturnValue();
            var state = response.getState();
            if (state == "SUCCESS") {
                var submittedLoanApplications = component.get("v.submittedLoanApplications");
                var submittedLoanApplication = {
                    Loan_Application__c: results['Loan_Application__c'],
                    Account: results['Account'],
                    Opportunity: results['Opportunity'],
                    Property__c: results['Property__c'],
                }
                submittedLoanApplications.push(submittedLoanApplication);
                var loanApplications = component.get("v.loanApplications");
                var loanApplicationIdentifier = loanApplication.loanApplicationIdentifier;
                for (var i = 0; i < loanApplications.length; i++) {
                    if (loanApplications[i].loanApplicationIdentifier == loanApplicationIdentifier) {
                        loanApplications.splice(i, 1);
                        break;
                    }
                }
                component.set("v.submittedLoanApplications", submittedLoanApplications);
                component.set("v.isAtLeastOneApplicationSubmitted", true);
                component.set("v.loanApplications", loanApplications);
                component.set("v.pageLoaded", true);
                component.set("v.showError", false);
                component.set("v.errorMessage", '');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    message: "Congrats, it works!",
                    type: "success"
                });
                toastEvent.fire();
            } else {
                var errorMessage = 'Error in saving Loan Application';
            	component.set("v.showError", true);
            	component.set("v.errorMessage", errorMessage);
                component.set("v.pageLoaded", true);                
            }
        })
        $A.enqueueAction(action);
    },

    validateLoanApplication: function (component, loanApplication) {
        var applicants = loanApplication.applicants;
        var totalOwnership = 0;
        for (var i = 0; i < applicants.length; i++) {
            var applicant = applicants[i];
            totalOwnership += Number(applicant.ownership);
            if (totalOwnership > 100) {
                var errorMessage = 'Total Ownership has exceeded 100%';
                component.set("v.showError", true);
                component.set("v.errorMessage", errorMessage);
                return false;
            }
        }
        if (totalOwnership < 100) {
            var errorMessage = 'Total Ownership is less than 100%';
            component.set("v.showError", true);
            component.set("v.errorMessage", errorMessage);
            return false;
        }
        return true;
    },
    
    initiatePropertyTypeDropDown: function(component){
        var promise = new Promise($A.getCallback(function (resolve, reject) {
            var action = component.get("c.getPropertyTypePicklistValues");
            action.setParams({});
            action.setCallback(this, function (response) {
            	var results = response.getReturnValue();
                var state = response.getState();
                if (state == "SUCCESS") {
                	resolve(response.getReturnValue());
                }
            })
            $A.enqueueAction(action);
   	    }));
        return promise;
    }
})