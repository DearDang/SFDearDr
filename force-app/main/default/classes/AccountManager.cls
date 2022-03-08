@RestResource(urlMapping='/Accounts/*/contacts')
global with sharing class AccountManager {
@HttpGet
    global static Account getAccount(){
        RestRequest request = RestContext.request;
        String uri = request.requestURI;
        String accountID = uri.substring(uri.indexOf('Accounts')+9, uri.indexOf('contacts')-1);
        System.debug('Account ID:= '+accountID);
        Account account = [Select Id, Name, (Select Id, name from Contacts) from Account where Id =:accountID  ];
        return account;
    }
}