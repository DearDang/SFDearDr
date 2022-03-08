public class AccountUtils {
    public static List<Account> accountsByState (String state){
        List<Account> accounts = [Select ID, Name from Account where BillingState =: state ];
    	return accounts;
    }
}