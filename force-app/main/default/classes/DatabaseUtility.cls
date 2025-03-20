public with sharing class DatabaseUtility {
    
    public static void insertMultipleRecords(List<SObject> recordsToBeInserted) {
        if (recordsToBeInserted != null && !recordsToBeInserted.isEmpty()) {
            try {
                Database.SaveResult[] srList = Database.insert(recordsToBeInserted, false); // Allow partial success
                
                List<String> databaseErrorMessages = new List<String>();
                for (Database.SaveResult sr : srList) {
                    if (!sr.isSuccess()) {
                        String errorMessage = sr.getId() + ' - ' + sr.getErrors()[0].getMessage();
                        System.debug(errorMessage);
                        databaseErrorMessages.add(errorMessage);
                    }
                }
    
                if (!databaseErrorMessages.isEmpty()) {
                    System.debug('Number of failed records: ' + databaseErrorMessages.size());
                    // SEE POTENTIAL IMPROVEMENT BELOW
                    //if (!Leads_to_Campaigns_Settings__c.getInstance().Bypass_ID_Log__c) {
                        //System.enqueueJob(new ErrorLoggingQueueable(LeadTriggerHandler.class.getName(), databaseErrorMessages));
                    //}
                }
            } catch (Exception e) {
                System.debug('Error in ' + LeadTriggerHandler.class.getName() + ': ' + e.getMessage() + ' | ' +  e.getLineNumber() + ' | ' + e.getStackTraceString());
                throw e;
            }
        }
    } // POTENTIAL IMPROVEMENT: use a logging framework to add async logging to a Custom Object or Big Object. The best approach would be to install a Managed Package such as NebulaLogger. 
        // NebulaLogger offers features for sync/async logging, async with/without platform events, storing to custom object/big object. Considerations:
        // If async, limit DailyAsyncApexExecutions: 250,000 or (number of user licenses * 200).
        // If using Platform Events, limit HourlyPublishedPlatformEvents: 250,000.
        // If using Big Objects: records in Big Objects can only be inserted asynchronously.
}