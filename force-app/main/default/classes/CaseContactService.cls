public with sharing class CaseContactService {
    public static void updateCases(Map<Id, Id> accountToPrimaryContactMap) {
        // if no Primary contacts added, then stop the automation
        if (accountToPrimaryContactMap.isEmpty()) {
            System.debug('No contacts with the level \'Primary\' found!');
            return;
        }
        
        List<Case> caseRecords = [SELECT Id, AccountId, ContactId FROM Case WHERE AccountId IN :accountToPrimaryContactMap.keySet() AND ContactId = null];
        List<Case> casesToUpdate = new List<Case>();

        for (Case c : caseRecords) {
            Id primaryContactId = accountToPrimaryContactMap.get(c.AccountId);
            c.ContactId = primaryContactId;
            casesToUpdate.add(c);
        }
        // execute the DML statement only if there are cases to update
        if (!casesToUpdate.isEmpty()) {
            update casesToUpdate;
        }
    }
}