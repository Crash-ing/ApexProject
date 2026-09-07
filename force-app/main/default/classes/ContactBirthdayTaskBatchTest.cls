@isTest
private class ContactBirthdayTaskBatchTest {

    @TestSetup
    static void setupTestData() {
        Account testAcc = new Account(
            Name = 'Invention Corp',
            Industry = 'Technology'
        );
        insert testAcc;

        // Get the target date
        Date targetDate = Date.today().addDays(2);

        // Contact which has a birthday after 2 days
        Contact testCon1 = new Contact(
            LastName = 'Tesla',
            AccountId = testAcc.Id,
            Birthdate = Date.newInstance(1990, targetDate.month(), targetDate.day()),
            MailingStreet = '123 Innovation Way',
            MailingCity = 'Riga',
            MailingCountry = 'Latvia'
        );

        Contact testCon2 = new Contact(
            LastName = 'Einstein',
            AccountId = testAcc.Id,
            Birthdate = Date.newInstance(1990, targetDate.month(), targetDate.day())
        );
        insert new List<Contact>{ testCon1, testCon2 };
    }

    @isTest
    public static void BatchExecutionTest() {
        Test.startTest();
        ContactBirthdayTaskBatch batchJob = new ContactBirthdayTaskBatch();
        Database.executeBatch(batchJob);
        Test.stopTest();

        List<Task> createdTasks = [SELECT Id, Subject, Priority, ActivityDate, WhatId, Description FROM Task ORDER BY Subject];

        System.assertEquals(2, createdTasks.size(), 'There should be 2 Birthday task!');
        
        Task t1 = createdTasks[0];
        System.assertEquals('Tesla\'s Birthday!', t1.Subject, 'Incorrect subject!');
        System.assertEquals('Low', t1.Priority, 'Task priority should be \'Low\'!');
        System.assertEquals(Date.today().addDays(2), t1.ActivityDate, 'Due date should be exactly after 2 days!');
        System.assert(t1.Description.contains('123 Innovation Way'), 'Description should cointain the address!');
        System.assert(t1.Description.contains('Technology'), 'Description should contain the industry!');

        Task t2 = createdTasks[1];
        System.assert(t2.Description.contains('The mailing address is unknown!'), 'Description should state that the address is unknown!');
    }

    @isTest
    public static void SchedulableExecutionTest() {
        Test.startTest();
        String cronExp = '0 0 9 * * ?';
        System.schedule('Test Birthday Batch Schedule', cronExp, new ContactBirthdayTaskBatch());
        Test.stopTest();

        List<AsyncApexJob> scheduledJobs = [SELECT Id, JobType FROM AsyncApexJob WHERE JobType = 'ScheduledApex'];

        System.assert(scheduledJobs.size() > 0, 'Schedulable job should be registered in the system!');
    }
}