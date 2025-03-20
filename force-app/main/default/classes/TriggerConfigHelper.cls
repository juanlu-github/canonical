/**
 * @author Juan Luis Núñez Cabello
 * @date 2023-07-19
 * @jira SFSC-2560
 * @description See Solution Design in Confluence xxx
 */
public with sharing class TriggerConfigHelper {
    public static Trigger_Configuration__mdt getTriggerConfig(String triggerName) {
        // Query the custom metadata type for this trigger's configuration
        Trigger_Configuration__mdt triggerConfig;
        try {
            triggerConfig = [
                SELECT Is_Trigger_Enabled__c, Bypass_User__c 
                FROM Trigger_Configuration__mdt 
                WHERE Trigger_Name__c = :triggerName
                LIMIT 1
            ];
        } catch (System.QueryException qe) {
            // If the custom metadata type does not exist, then the trigger is disabled
            System.debug(LoggingLevel.WARN, 'A Trigger_Configuration__mdt record with Trigger_Name__c = ' + triggerName + ' does not exist. The trigger is then set as disabled.');
            triggerConfig = new Trigger_Configuration__mdt(Is_Trigger_Enabled__c = false);
        }
        return triggerConfig;
    }

    public static Boolean isTriggerEnabled(Trigger_Configuration__mdt triggerConfig) {
        // Return whether the trigger is enabled
        return triggerConfig != null && triggerConfig.Is_Trigger_Enabled__c;
    }

    public static Boolean shouldBypassTrigger(Trigger_Configuration__mdt triggerConfig) {
        return triggerConfig != null && UserInfo.getUserId().equals(triggerConfig.Bypass_User__c);
    }
}