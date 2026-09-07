public with sharing class ContactBirthdayTaskBatch implements Database.Batchable<sObject>, Schedulable {
    public void execute(SchedulableContext sc) {
        // Calls the batch process
        Database.executeBatch(new ContactBirthdayTaskBatch());
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        Date targetDate = Date.today().addDays(2);
        Integer tMonth = targetDate.month();
        Integer tDay = targetDate.day();

        String query = 'SELECT Id, Name, Birthdate, OwnerId, AccountId, Account.Name, Account.Industry, ' +
                       'MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry ' + 
                       'FROM Contact ' +
                       'WHERE Birthdate != null '+
                       'AND CALENDAR_MONTH(Birthdate) = :tMonth ' +
                       'AND DAY_IN_MONTH(Birthdate) = :tDay';
        
        return Database.getQueryLocator(query);
    }

    public void execute (Database.BatchableContext bc, List<Contact> scope) {
        List<Task> tasksToInsert = new List<Task>();
        Date targetDate = Date.today().addDays(2);

        for (Contact con : scope) {
            Task t = new Task(Subject = con.Name + '\'s Birthday!', OwnerID = con.OwnerId, Priority = 'Low', ActivityDate = targetDate, WhatId = con.AccountId);
            
            // address composition
            List<String> addrParts = new List<String>();
            if (String.isNotBlank(con.MailingStreet)) addrParts.add(con.MailingStreet);
            if (String.isNotBlank(con.MailingCity)) addrParts.add(con.MailingCity);
            if (String.isNotBlank(con.MailingState)) addrParts.add(con.MailingState);
            if (String.isNotBlank(con.MailingPostalCode)) addrParts.add(con.MailingPostalCode);
            if (String.isNotBlank(con.MailingCountry)) addrParts.add(con.MailingCountry);

            String address = '';
            if (!addrParts.isEmpty()) {
                address = String.join(addrParts, ', ');
            }

            Integer conAge = targetDate.year() - con.Birthdate.year();

            String accName = (con.AccountId != null) ? con.Account.Name : 'an unknown account';
            String accIndustry = (con.AccountId != null && con.Account.Industry != null) ? con.Account.Industry : 'unknown';
            
            String comments = 'Today is the birthday of ' + con.Name + '. He/She is now ' + conAge + ' years old. This Contact is an employee of ' + accName + 
                              ', part of the ' + accIndustry + ' industry. Consider making an appropriate gift.';

            if (String.isNotBlank(address)) {
                comments += 'The mailing address of the Contact is: ' + address;
            } else {
                comments += 'The mailing address is unknown.';
            }

            t.Description = comments;
            tasksToInsert.add(t);
        }

        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }

    public void finish (Database.Batchablecontext bc) {
        System.debug('Scheduled Batch job has been finished!');
    }
}