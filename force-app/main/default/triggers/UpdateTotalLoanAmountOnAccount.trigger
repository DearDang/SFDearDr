trigger UpdateTotalLoanAmountOnAccount on Loan_Ownership__c (after insert, before update, after update, before delete) {
    if(Trigger.isInsert){
        LoanOwnershipController.updateTotalLoanAmountOnAccountForCreateRecord(Trigger.New);
    }
    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            LoanOwnershipController.decreaseLoanOwnershipAmountFromAccountForUpdateRecord(Trigger.Old);
        }
       	if(Trigger.isAfter){
            LoanOwnershipController.increaseLoanOwnershipAmountInAccountForUpdateRecord(Trigger.New);
        }
    }
    if(Trigger.isDelete){
        LoanOwnershipController.removeLoanOwnershipAmountFromAccountForDeleteRecord(Trigger.Old);
    }
    
}