@isTest
public class AccountTriggerHandlerTest {
    @isTest
    public static void afetrInsertHandlerTest() {
        List<Account> testAccounts = new List<Account>();
        Account testAcc1 = new Account(Name = 'Test Account 1', CustomerPriority__c = 'High');
        Account testAcc2 = new Account(Name = 'Test Account 2', CustomerPriority__c = 'High');
        testAccounts.add(testAcc1);
        testAccounts.add(testAcc2);

        Test.startTest();
        insert testAccounts;
        Test.stopTest();

        List<Case> createdCases = [SELECT Id, AccountId, OwnerId, Origin, Account.CustomerPriority__c, Account.Name, Priority, Subject FROM Case WHERE AccountId IN :testAccounts];

        System.assertEquals(2, createdCases.size(), 'Should be 2 case records.');

        for (Case newCase : createdCases) {
            System.assertNotEquals(null, newCase.AccountId, 'Case should be related to an Account.');
            System.assertEquals(UserInfo.getUserId(), newCase.OwnerId, 'Case owner should be the same as Account\'s owner.');
            System.assertEquals('System', newCase.Origin, 'Case Origin should be \'System\'.');
            System.assertEquals(newCase.Account.CustomerPriority__c, newCase.Priority, 'Case priority doesn\'t match Account\'s priority.');
            System.assertEquals(newCase.Account.Name + ' - Onboarding', newCase.Subject, 'Wrong Case Subject info.');
        }
    }
}