({
    doInit: function (component, event, helper) {
        var loanApplicationBundle = '';
        var loanApplications = component.get("v.loanApplications");
        if (loanApplications.length == 0) {
            var applicant = {
                loanApplicationBundle: loanApplicationBundle,
                loanApplicationIdentifier: 'AHLPLO001',
                applicantIdentifier: 'AHLPLO001_A1',
                customer: '',
                income: 0,
                expense: 0,
                ownership: 0,
                primaryApplicant: false
            };
            var applicants = [applicant];
            var loanApplication = {
                loanApplicationBundle: loanApplicationBundle,
                loanApplicationIdentifier: 'AHLPLO001',
                property: null,
                propertyType: null,
                loanAmount: 0.0,
                loanTerm: 0,
                applicants: applicants
            };
            loanApplications.push(loanApplication);
            component.set("v.loanApplications", loanApplications);
        }
        var promise = helper.initiatePropertyTypeDropDown(component);
        promise.then(function (result) {
            var propertyTypes = result;
            component.set("v.propertyTypeValues", propertyTypes);
        });
    },

    addApplicant: function (component, event, helper) {
        var loanApplicationBundle = component.get("v.loanApplicationBundle");
        var loanApplication = event.getSource().get("v.value");
        var loanApplicationIdentifier = loanApplication.loanApplicationIdentifier;
        var applicants = loanApplication.applicants;
        var indexOfApplicant = applicants.length;
        var applicantIdentifier = `${loanApplicationIdentifier}_A${indexOfApplicant+1}`;
        var applicant = {
            loanApplicationBundle: loanApplicationBundle,
            loanApplicationIdentifier: loanApplicationIdentifier,
            applicantIdentifier: applicantIdentifier,
            customer: '',
            income: 0,
            expense: 0,
            ownership: 0,
            primaryApplicant: false
        };
        applicants.push(applicant);
        loanApplication.applicants = applicants;
        var loanApplications = component.get("v.loanApplications");
        for (var i = 0; i < loanApplications.length; i++) {
            if (loanApplication.loanApplicationIdentifier == loanApplications[i].loanApplicationIdentifier) {
                loanApplications[i] = loanApplication;
            }
        }
        component.set("v.loanApplications", loanApplications);
    },

    changePrimaryApplicant: function (component, event, helper) {
        var isChecked = event.getSource().get("v.checked");
        var applicant = event.getSource().get("v.value");
        var loanApplications = component.get("v.loanApplications");
        var loanApplicationIdentifier = applicant.loanApplicationIdentifier;
        var applicantIdentifier = applicant.applicantIdentifier;
        for (var i = 0; i < loanApplications.length; i++) {
            var loanApplication = loanApplications[i];
            if (loanApplication.loanApplicationIdentifier == loanApplicationIdentifier) {
                var applicants = loanApplication.applicants;
                for (var j = 0; j < applicants.length; j++) {
                    var applicant = applicants[j];
                    if (applicant.applicantIdentifier == applicantIdentifier) {
                        applicant.primaryApplicant = isChecked;
                    } else {
                        applicant.primaryApplicant = false;
                    }
                    applicants[j] = applicant;
                }
                loanApplication.applicants = applicants;
                loanApplications[i] = loanApplication;
                break;
            }
        }
        component.set("v.loanApplications", loanApplications);
        event.target.checked;
    },

    deleteApplicant: function (component, event, helper) {
        var applicant = event.getSource().get("v.value");
        var loanApplications = component.get("v.loanApplications");
        var loanApplicationIdentifier = applicant.loanApplicationIdentifier;
        var applicantIdentifier = applicant.applicantIdentifier;
        for (var i = 0; i < loanApplications.length; i++) {
            var loanApplication = loanApplications[i];
            if (loanApplication.loanApplicationIdentifier == loanApplicationIdentifier) {
                var applicants = loanApplication.applicants;
                for (var j = 0; j < applicants.length; j++) {
                    if (applicants[j].applicantIdentifier == applicantIdentifier) {
                        applicants.splice(j, 1);
                        break;
                    }
                }
                loanApplication.applicants = applicants;
                loanApplications[i] = loanApplication;
                break;
            }
        }
        component.set("v.loanApplications", loanApplications);
    },

    saveLoanApplication: function (component, event, helper) {
        var loanApplication = event.getSource().get("v.value");
        var isLoanApplicationValid = helper.validateLoanApplication(component, loanApplication);
        if (isLoanApplicationValid) {
            var loanApplicationBundle = component.get("v.loanApplicationBundle");
            if (!loanApplicationBundle) {
                component.set("v.pageLoaded", false);
                var promise = helper.createNewLoanApplicationBundle(component);
                promise.then(function (result) {
                    loanApplicationBundle = result['loandApplicationBundleName'];
                    component.set("v.loanApplicationBundle", loanApplicationBundle);
                    helper.saveLoanApplication(component, event);
                });
                component.set("v.pageLoaded", true);
            } else {
                helper.saveLoanApplication(component, event, helper);
            }
        }

    },

    addOneMoreProperty: function (component, helper) {
        var loanApplicationBundle = component.get("v.loanApplicationBundle");
        var loanApplications = component.get("v.loanApplications");
        var numberOfLoanApplications = loanApplications.length;
        var loanApplicationIdentifier = `AHLPLO00${numberOfLoanApplications+1}`;
        var loanApplicationHeader = `Property Loan ${numberOfLoanApplications+1}`;
        var applicantIdentifier = loanApplicationIdentifier + '_A1';
        var applicant = {
            loanApplicationBundle: loanApplicationBundle,
            loanApplicationIdentifier: loanApplicationIdentifier,
            applicantIdentifier: applicantIdentifier,
            customer: '',
            income: 0,
            expense: 0,
            ownership: 0,
            primaryApplicant: false
        };
        var applicants = [applicant];
        var loanApplication = {
            loanApplicationBundle: loanApplicationBundle,
            loanApplicationIdentifier: loanApplicationIdentifier,
            property: null,
            propertyType: null,
            loanAmount: 0,
            loanTerm: 0,
            applicants: applicants
        };
        loanApplications.push(loanApplication);
        component.set("v.loanApplications", loanApplications);
    },

    deleteLoanApplication: function (component, event, helper) {
        var loanApplication = event.getSource().get("v.value");
        var loanApplicationIdentifier = loanApplication.loanApplicationIdentifier;
        var loanApplications = component.get("v.loanApplications");
        for (var i = 0; i < loanApplications.length; i++) {
            if (loanApplications[i].loanApplicationIdentifier == loanApplicationIdentifier) {
                loanApplications.splice(i, 1);
                break;
            }
        }
        component.set("v.loanApplications", loanApplications);
    },

    cancelDialog: function (component, helper) {
        var homeEvt = $A.get("e.force:navigateToObjectHome");
        homeEvt.setParams({
            "scope": "Loan_Application__c"
        });
        homeEvt.fire();
    },

    setPropertyType: function (component, event, helper) {
        var loanApplicationIdentifier_PicklistValue = event.getSource().get("v.value");
        var values = loanApplicationIdentifier_PicklistValue.split('_');
        var loanApplicationIdentifier = values[0];
        var propertyType = values[1];
        var loanApplications = component.get("v.loanApplications");
        for (var i = 0; i < loanApplications.length; i++) {
            var loanApplication = loanApplications[i];
            if (loanApplication.loanApplicationIdentifier == loanApplicationIdentifier) {
                loanApplication.propertyType = propertyType;
                loanApplications[i] = loanApplication;
                break;
            }
        }
        component.set("v.loanApplications", loanApplications);
        console.log('loanApplication_PicklistValue: ' + loanApplication_PicklistValue);
    }
})