trigger ContactTrigger on Contact (before insert, before update, after insert, after update) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            ContactTriggerHandler.beforeInsertHandler(Trigger.new);
        }
        when BEFORE_UPDATE {
            ContactTriggerHandler.beforeUpdateHandler(Trigger.new);
        }
        when AFTER_INSERT {
            ContactTriggerHandler.afterInsertHandler(Trigger.new);
        }
        when AFTER_UPDATE {
            ContactTriggerHandler.afterUpdateHandler(Trigger.new, Trigger.oldMap);
        }
    }
}