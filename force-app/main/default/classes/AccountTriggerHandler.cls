public with sharing class AccountTriggerHandler {
    public static void afterInsertHandler(List<Account> newAccounts) {
        // List to store cases for bulkification
        List<Case> accountCases = new List<Case>();
        for(Account acc : newAccounts) {
            // Creates a new case
            Case newCase = new Case(AccountId = acc.Id, OwnerId = acc.OwnerId, Origin = 'System', Priority = acc.CustomerPriority__c, Subject = acc.Name + ' - Onboarding');
            accountCases.add(newCase);
        }
        insert accountCases;
    }
}