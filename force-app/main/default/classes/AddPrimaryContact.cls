public class AddPrimaryContact implements Queueable {
    private Contact contact;
    private String state;
    public AddPrimaryContact(Contact contact, String state){
        this.contact = contact;
        this.state = state;
    }
    
    public void execute(QueueableContext context) {
        List<Account> accounts = [Select Id from Account where BillingState  =: state LIMIT 200];
        for (Account account : accounts) {
         Contact newContact = contact.clone();
         newContact.AccountId = account.Id;
         insert newContact;
        }
    }

}