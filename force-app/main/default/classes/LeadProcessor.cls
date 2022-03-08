global class LeadProcessor implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'Select Id From Lead';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Lead> leadRecords){
        List<Lead> leads = new List<Lead>();
        for(Lead lead: leadRecords){
            lead.LeadSource = 'Dreamforce';
            leads.add(lead);
        }
        update leads;
    }
    global void finish(Database.BatchableContext bc){
       
    }
}