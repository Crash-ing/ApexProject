@isTest
public class ContactBirthdayServiceTest {
    @TestSetup
    public static void testSetupData(){
        Account usAcc = new Account(
            Name = 'US Corp',
            BillingCountry = 'United States'
        );
        insert usAcc;

        Account euAcc = new Account(
            Name = 'EU Corp',
            BillingCountry = 'Latvia'
        );
        insert euAcc;
    }

    @isTest
    public static void USUnderageContactTest() {
        Account usAcc = [SELECT Id FROM Account WHERE Name = 'US Corp' LIMIT 1];

        Contact underageCon = new Contact(
            LastName = 'Smith',
            AccountId = usAcc.Id,
            Birthdate = Date.today().addYears(-20)
        );
        // Value to check if there was an error
        Boolean hasError = false;

        Test.startTest();
        try {
            insert underageCon;
        } catch (Exception e) {
            hasError = true;
            // Checking if the error is the same
            System.assert(
                e.getMessage().contains('All contact persons should be of legal age! (US: 21+)'),
                'Error should be the same!');
        }
        Test.stopTest();
        // Checking if the error really worked
        System.assertEquals(true, hasError, 'System should\'ve stopped the 20 year old contact from being assigned to the US Account!');  
    }

    @isTest
    public static void USContactTest() {
        Account usAcc = [SELECT Id FROM Account WHERE Name = 'US Corp' LIMIT 1];

        Contact con = new Contact(
            LastName = 'Walker',
            AccountId = usAcc.Id,
            Birthdate = Date.today().addYears(-21)
        );

        Test.startTest();
        insert con;
        Test.stopTest();

        // Checking if the contact was inserted
        System.assertNotEquals(null, con.Id, 'System should\'ve allowed the 21 year old contact to be assigned to the US Account!');  
    }

    @isTest
    public static void EUUnderageContactTest() {
        Account euAcc = [SELECT Id FROM Account WHERE Name = 'EU Corp' LIMIT 1];
        Contact underageCon = new Contact(
            LastName = 'Krauklis',
            AccountId = euAcc.Id,
            Birthdate = Date.today().addYears(-17)
        );
        // Value to check if there was an error
        Boolean hasError = false;

        Test.startTest();
        try {
            insert underageCon;
        } catch (Exception e) {
            hasError = true;
            // Checking if the error is the same
            System.assert(
                e.getMessage().contains('All contact persons should be of legal age! (Non-US: 18+)'),
                'Error should be the same!');
        }
        Test.stopTest();
        // Checking if the error really worked
        System.assertEquals(true, hasError, 'System should\'ve stopped the 17 year old contact from being assigned to the EU Account!');  
    }

    @isTest
    public static void EUContactTest() {
        Account euAcc = [SELECT Id FROM Account WHERE Name = 'EU Corp' LIMIT 1];
        Contact con = new Contact(
            LastName = 'Priede',
            AccountId = euAcc.Id,
            Birthdate = Date.today().addYears(-18)
        );

        Test.startTest();
        insert con;
        Test.stopTest();

        // Checking if the error really worked
        System.assertNotEquals(null, con.Id, 'System should\'ve allowed the 18 year old contact to be assigned to the EU Account!');  
    }
}