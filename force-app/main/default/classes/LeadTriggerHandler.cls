public with sharing class LeadTriggerHandler {

    public static void handler(
                            Boolean isBefore,
                            Boolean isAfter,
                            Boolean isDelete,
                            Boolean isInsert,
                            Boolean isUpdate,
                            List<Lead> newList,
                            Map<Id, Lead> newMap,
                            List<Lead> oldList,
                            Map<Id, Lead> oldMap) {
        // Check whether the trigger is enabled or bypassed
        Trigger_Configuration__mdt triggerConfig = TriggerConfigHelper.getTriggerConfig('LeadTrigger');
        if (!TriggerConfigHelper.isTriggerEnabled(triggerConfig) 
            || TriggerConfigHelper.shouldBypassTrigger(triggerConfig)) {
            return;
        }
        //if (Trigger.isBefore) {
            //if (Trigger.isInsert) LeadTriggerHandler.handleBeforeInsert(oldList, newList, oldMap, newMap);
            //if (Trigger.isUpdate) LeadTriggerHandler.handleBeforeUpdate(oldList, newList, oldMap, newMap);
            //if (Trigger.isDelete) LeadTriggerHandler.handleBeforeDelete(oldList, newList, oldMap, newMap);
        /*} else*/ if (Trigger.isAfter) {
            if (Trigger.isInsert) LeadTriggerHandler.handleAfterInsert(oldList, newList, oldMap, newMap);
            //if (Trigger.isUpdate) LeadTriggerHandler.handleAfterUpdate(oldList, newList, oldMap, newMap);
            //if (Trigger.isDelete) LeadTriggerHandler.handleAfterDelete(oldList, newList, oldMap, newMap);
            //if (Trigger.isDelete) LeadTriggerHandler.handleAfterUndelete(oldList, newList, oldMap, newMap);
        }
    }

    //public static void handleBeforeInsert(List<Lead> oldList, List<Lead> newList, Map<Id, Lead> oldMap, Map<Id, Lead> newMap) {}
    
    //public static void handleBeforeUpdate(List<Lead> oldList, List<Lead> newList, Map<Id, Lead> oldMap, Map<Id, Lead> newMap) {}
    
    //public static void handleBeforeDelete(List<Lead> oldList, List<Lead> newList, Map<Id, Lead> oldMap, Map<Id, Lead> newMap) {}
    
    public static void handleAfterInsert(List<Lead> oldList, List<Lead> newList, Map<Id, Lead> oldMap, Map<Id, Lead> newMap) {
        LeadHelper.processFoobarLeads(newList);
    }
    
    //public static void handleAfterUpdate(List<Lead> oldList, List<Lead> newList, Map<Id, Lead> oldMap, Map<Id, Lead> newMap) {}
    
    //public static void handleAfterDelete(List<Lead> oldList, List<Lead> newList, Map<Id, Lead> oldMap, Map<Id, Lead> newMap) {}
    
    //public static void handleAfterUndelete(List<Lead> oldList, List<Lead> newList, Map<Id, Lead> oldMap, Map<Id, Lead> newMap) {}
}// POTENTIAL IMPROVEMENT: use an Apex trigger framework (there are dozens to choose from).
// This allows for better code reusing, disabling triggers declaratively, bypassing the trigger for a given user, etc.