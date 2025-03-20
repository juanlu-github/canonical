public class TriggerConfigTestDataFactory {
    private final static String MY_TRIGGER_NAME = 'MyTrigger'; // Default value, can/should be overwritten using withTriggerName
    
    private Trigger_Configuration__mdt record;

    public TriggerConfigTestDataFactory() {
        record = new Trigger_Configuration__mdt();
        record.DeveloperName = MY_TRIGGER_NAME;
        record.Trigger_Name__c = MY_TRIGGER_NAME;
        record.Is_Trigger_Enabled__c = true;
        record.Bypass_User__c = null;
    }

    public TriggerConfigTestDataFactory withTriggerName(String triggerName) {
        record.Trigger_Name__c = triggerName;
        record.DeveloperName = triggerName;
        return this;
    }

    public TriggerConfigTestDataFactory withIsTriggerEnabled(Boolean isTriggerEnabled) {
        record.Is_Trigger_Enabled__c = isTriggerEnabled;
        return this;
    }

    public TriggerConfigTestDataFactory withBypassUserId(String bypassUserId) {
        record.Bypass_User__c = bypassUserId;
        return this;
    }

    public Trigger_Configuration__mdt build() {
        Trigger_Configuration__mdt builtRecord = record.clone(false, false, false, false);
        record = new Trigger_Configuration__mdt();  // Reinitialize to ensure a fresh record for each build
        return builtRecord;
    }
}