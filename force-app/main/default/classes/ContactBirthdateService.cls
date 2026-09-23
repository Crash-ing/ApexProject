public with sharing class ContactBirthdateService {
    public static void validateAge(List<Contact> newContacts) {
        Integer usAccLimit = 21;
        Integer nonUsAccLimit = 18;
        Date today = Date.today();
        Date usLimitDate = today.addYears(-(usAccLimit));
        Date nonUsLimitDate = today.addYears(-(nonUsAccLimit));

        Set<Id> accountIds = new Set<Id>();
        // gets all distinct account Ids
        for (Contact contact : newContacts) {
            if (contact.AccountId != null && contact.Birthdate != null) {
                accountIds.add(contact.AccountId);
            }
        }

        Map<Id, Account> accountMap = new Map<Id, Account>();
        // Map for all account countries
        if (!accountIds.isEmpty()) {
            accountMap = new Map<Id, Account>([SELECT Id, BillingCountry FROM Account WHERE ID IN :accountIds]);
        }

        for (Contact contact : newContacts) {
            if (contact.Birthdate != null) {
                String country = '';
                 
                if (contact.AccountId != null && accountMap.containsKey(contact.AccountId)){
                    country = accountMap.get(contact.AccountId).BillingCountry;
                }

                if (country == 'United States' && contact.Birthdate > usLimitDate) {
                    contact.Birthdate.addError('All contact persons should be of legal age! (US: 21+)');
                } else if (country != 'United States' && contact.Birthdate > nonUsLimitDate) {
                    contact.Birthdate.addError('All contact persons should be of legal age! (Non-US: 18+)');
                }
            }
        }
    }
}