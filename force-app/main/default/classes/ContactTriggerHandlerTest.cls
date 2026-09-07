@isTest
public class ContactTriggerHandlerTest {
    @testSetup
    static void setupTestData(){
        // Account which will create a case
        Account testAcc = new Account(Name = 'Wayne Enterprises', CustomerPriority__c = 'High', BillingCountry = 'Latvia');
        insert testAcc;

        // Extra case to guarantee that the ContactId is empty
        Case testCase = new Case(AccountId = testAcc.Id, Subject = 'Extra case', Origin = 'System');
        insert testCase;
    }

    @isTest
    public static void afterInsertHandlerTest() {
        Account testAcc = [SELECT Id FROM Account LIMIT 1];

        Contact primaryCon = new Contact(LastName = 'Wayne', AccountId = testAcc.Id, Level__c = 'Primary', Birthdate = Date.today().addYears(-30));

        Test.startTest();
        // Calls afterInsertHandler which should get all empty cases and assign them to this contact
        insert primaryCon;
        Test.stopTest();

        List<Case> updatedCases = [SELECT Id, ContactId FROM Case WHERE AccountId = :testAcc.Id];

        // Checks if empty cases have been assigned to the contact
        for (Case c : updatedCases) {
            System.assertEquals(primaryCon.Id, c.ContactId, 'Inserting the Primary contact, it should get assigned all empty account cases.');
        }
    }

    @isTest
    public static void afterUpdateHandlerTest () {
        Account testAcc = [SELECT Id FROM Account LIMIT 1];

        Contact secCon = new Contact(
            LastName = 'Kent',
            AccountId = testAcc.Id,
            Level__c = 'Secondary',
            Birthdate = Date.today().addYears(-30)
        );
        insert secCon;

        // Checking if before updating Case is still without a Contact
        List<Case> casesBefore = [SELECT Id, ContactId FROM Case WHERE AccountId = :testAcc.Id AND ContactId = null];
        System.assert(casesBefore.size() > 0, 'There should be at least one Case which doesn\'t have a ContactId');

        Test.startTest();
        secCon.Level__c = 'Primary';
        update secCon;
        Test.stopTest();

        List<Case> casesAfter = [SELECT Id, ContactId FROM Case WHERE AccountId = :testAcc.Id];

        for (Case c : casesAfter) {
            System.assertEquals(secCon.Id, c.ContactId, 'After Contact Level change to Primary, it should have been populated with a case.');
        }
    }
    
}