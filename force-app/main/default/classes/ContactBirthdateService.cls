public with sharing class ContactBirthdateService {
    public static void validateAge(List<Contact> newContacts) {
        Set<Id> accountIds = new Set<Id>();
        // gets all distinct account Ids
        for (Contact con : newContacts) {
            if (con.AccountId != null && con.Birthdate != null) {
                accountIds.add(con.AccountId);
            }
        }

        Map<Id, Account> accountMap = new Map<Id, Account>();
        // Map for all account countries
        if (!accountIds.isEmpty()) {
            accountMap = new Map<Id, Account>([SELECT Id, BillingCountry FROM Account WHERE ID IN :accountIds]);
        }

        for (Contact con : newContacts) {
            if (con.Birthdate != null) {
                String country = '';
                Integer age = con.Birthdate.monthsBetween(Date.today()) / 12;
                 
                if (con.AccountId != null && accountMap.containsKey(con.AccountId)){
                    country = accountMap.get(con.AccountId).BillingCountry;
                }

                if (country == 'United States' && age < 21) {
                    con.Birthdate.addError('All contact persons should be of legal age! (US: 21+)');
                } else if (country != 'United States' && age < 18) {
                    con.Birthdate.addError('All contact persons should be of legal age! (Non-US: 18+)');
                }
            }
        }
    }
}