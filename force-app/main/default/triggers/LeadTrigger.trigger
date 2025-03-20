trigger LeadTrigger on Lead (
            before insert, before update, before delete,
            after insert, after update, after delete, after undelete) {

    LeadTriggerHandler.handler(
        Trigger.isBefore,
        Trigger.isAfter,
        Trigger.isDelete,
        Trigger.isInsert,
        Trigger.isUpdate,
        Trigger.new,
        Trigger.newMap,
        Trigger.old,
        Trigger.oldMap);
} // POTENTIAL IMPROVEMENT: use an Apex trigger framework (there are dozens to choose from).
// This allows for better code reusing, disabling triggers declaratively, bypassing the trigger for a given user, etc.