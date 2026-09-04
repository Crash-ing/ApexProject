public with sharing class ContactTriggerHandler {
    // Handles contact age validation on Contact creation
    public static void beforeInsertHandler(List<Contact> newContacts) {
        ContactBirthdateService.validateAge(newContacts);
    }
    // Handles contact age validation on Contact update
    public static void beforeUpdateHandler(List<Contact> newContacts) {
        ContactBirthdateService.validateAge(newContacts);
    }
    // Handles contact population with cases
    public static void afterInsertHandler(List<Contact> newContacts) {
        // for loop checks if there is an AccountId and Level__c == 'Primary', then populates a contact
        Map<Id, Id> accountToPrimaryContactMap = new Map<Id, Id>();

        for (Contact con : newContacts) {
            if (con.AccountId != null && con.Level__c == 'Primary') {
                accountToPrimaryContactMap.put(con.AccountId, con.Id);
            }
        }

        CaseContactService.updateCases(accountToPrimaryContactMap);
    }
    // Handles contact population with cases
    public static void afterUpdateHandler(List<Contact> newContacts, Map<Id, Contact> oldContactsMap) {
        // for loop checks if there is an AccountId and Level__c == 'Primary', and compares it to oldContactsMap, then populates a contact
        Map<Id, Id> accountToPrimaryContactMap = new Map<Id, Id>();

        for (Contact con : newContacts) {
            if (con.AccountId != null && con.Level__c == 'Primary' && oldContactsMap.get(con.Id).Level__c != 'Primary') {
                accountToPrimaryContactMap.put(con.AccountId, con.Id);
            }
        }

        CaseContactService.updateCases(accountToPrimaryContactMap);
    }
}