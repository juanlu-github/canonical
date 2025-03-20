trigger LeadTrigger on Lead (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        LeadTriggerHandler.processFoobarLeads(Trigger.new);
    }
} // POTENTIAL IMPROVEMENT: use an Apex trigger framework (there are dozens to choose from).
// This allows for better code reusing, disabling triggers declaratively, bypassing the trigger for a given user, etc.