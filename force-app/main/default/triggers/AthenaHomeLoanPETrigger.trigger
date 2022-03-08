trigger AthenaHomeLoanPETrigger on AthenaHomeLoanPE__e (after insert) {
    if(Trigger.isAfter){
        LoanOwnershipController.handleAthenaHomeLoanEvent(Trigger.New);
    }
}