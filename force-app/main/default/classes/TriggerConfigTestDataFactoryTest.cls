@isTest
private class TriggerConfigTestDataFactoryTest {

    @isTest
    static void testBuildSingleRecord() {
        // Arrange
        String triggerName = 'PvpTrigger';
        Boolean isTriggerEnabled = true;
        String bypassUserId = '005123456789012345';

        TriggerConfigTestDataFactory factory = new TriggerConfigTestDataFactory()
                                                .withTriggerName(triggerName)
                                                .withIsTriggerEnabled(isTriggerEnabled)
                                                .withBypassUserId(bypassUserId);

        // Act
        Trigger_Configuration__mdt record = factory.build();

        // Assert
        Assert.areEqual(triggerName, record.DeveloperName, 'DeveloperName should match the input value');
        Assert.areEqual(triggerName, record.Trigger_Name__c, 'Trigger_Name__c should match the input value');
        Assert.areEqual(isTriggerEnabled, record.Is_Trigger_Enabled__c, 'Is_Trigger_Enabled__c should match the input value');
        Assert.areEqual(bypassUserId, record.Bypass_User__c, 'Bypass_User__c should match the input value');
    }
}