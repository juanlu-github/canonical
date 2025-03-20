@isTest
private class TriggerConfigHelperTest {

    @isTest
    static void testGetTriggerConfigNonExistingTrigger() {
        // Arrange
        String triggerName = 'Test_Non-ExistingTrigger';
        Boolean isTriggerEnabled = true;
        String bypassUserId = '005123456789012345';
        Trigger_Configuration__mdt newTriggerConfig = new TriggerConfigTestDataFactory()
                                                    .withTriggerName(triggerName)
                                                    .withIsTriggerEnabled(isTriggerEnabled)
                                                    .withBypassUserId(bypassUserId)
                                                    .build();
        // insert newTriggerConfig; // DML operations on CMT are unfortunately not allowed in Apex as of 27.08.2024.

        // Act
        Test.startTest();
        Trigger_Configuration__mdt retrievedTriggerConfig = TriggerConfigHelper.getTriggerConfig(triggerName);
        Test.stopTest();

        // Assert
        Assert.isFalse(retrievedTriggerConfig.Is_Trigger_Enabled__c, 'Is_Trigger_Enabled__c should be false, i.e., the trigger should be set as disabled, because the corresponding Trigger_Config__mdt record does not exist.');
        Assert.isNull(retrievedTriggerConfig.DeveloperName, 'DeveloperName should be null, because the corresponding Trigger_Configuration__mdt record does not exist.');
        Assert.isNull(retrievedTriggerConfig.Trigger_Name__c, 'Trigger_Name__c should be null, because the corresponding Trigger_Configuration__mdt record does not exist.');
        Assert.isNull(retrievedTriggerConfig.Bypass_User__c, 'Bypass_User__c should be null, because the corresponding Trigger_Configuration__mdt record does not exist.');
    }

    @isTest
    static void testTriggerEnabled() {
        // Arrange
        String triggerName = 'PvpTrigger';
        Boolean isTriggerEnabled = true;
        String bypassUserId = '005123456789012345';
        Trigger_Configuration__mdt triggerConfig = new TriggerConfigTestDataFactory()
                                                    .withTriggerName(triggerName)
                                                    .withIsTriggerEnabled(isTriggerEnabled)
                                                    .withBypassUserId(bypassUserId)
                                                    .build();

        // Act
        Test.startTest();
        Boolean isEnabled = TriggerConfigHelper.isTriggerEnabled(triggerConfig);
        Test.stopTest();

        // Assert
        Assert.isTrue(isEnabled, 'The trigger should be enabled');
    }

    @isTest
    static void testTriggerNotEnabled() {
        // Arrange
        String triggerName = 'PvpTrigger';
        Boolean isTriggerEnabled = false;
        String bypassUserId = '005123456789012345';
        Trigger_Configuration__mdt triggerConfig = new TriggerConfigTestDataFactory()
                                                    .withTriggerName(triggerName)
                                                    .withIsTriggerEnabled(isTriggerEnabled)
                                                    .withBypassUserId(bypassUserId)
                                                    .build();

        // Act
        Test.startTest();
        Boolean isEnabled = TriggerConfigHelper.isTriggerEnabled(triggerConfig);
        Test.stopTest();

        // Assert
        Assert.isFalse(isEnabled, 'The trigger should not be enabled');
    }

    @isTest
    static void testTriggerBypassed() {
        // Arrange
        String triggerName = 'PvpTrigger';
        Boolean isTriggerEnabled = true;
        String bypassUserId = UserInfo.getUserId();
        Trigger_Configuration__mdt triggerConfig = new TriggerConfigTestDataFactory()
                                                    .withTriggerName(triggerName)
                                                    .withIsTriggerEnabled(isTriggerEnabled)
                                                    .withBypassUserId(bypassUserId)
                                                    .build();

        // Act
        Test.startTest();
        Boolean shouldBypass = TriggerConfigHelper.shouldBypassTrigger(triggerConfig);
        Test.stopTest();

        // Assert
        Assert.isTrue(shouldBypass, 'The trigger should be bypassed');
    }

    @isTest
    static void testTriggerNotBypassedWrongUser() {
        // Arrange
        String triggerName = 'PvpTrigger';
        Boolean isTriggerEnabled = true;
        String bypassUserId = '005123456789012345';
        Trigger_Configuration__mdt triggerConfig = new TriggerConfigTestDataFactory()
                                                    .withTriggerName(triggerName)
                                                    .withIsTriggerEnabled(isTriggerEnabled)
                                                    .withBypassUserId(bypassUserId)
                                                    .build();

        // Act
        Test.startTest();
        Boolean shouldBypass = TriggerConfigHelper.shouldBypassTrigger(triggerConfig);
        Test.stopTest();

        // Assert
        Assert.isFalse(shouldBypass, 'The trigger should not be bypassed');
    }

    @isTest
    static void testTriggerNotBypassedNull() {
        // Arrange
        String triggerName = 'PvpTrigger';
        Boolean isTriggerEnabled = true;
        String bypassUserId = null;
        Trigger_Configuration__mdt triggerConfig = new TriggerConfigTestDataFactory()
                                                    .withTriggerName(triggerName)
                                                    .withIsTriggerEnabled(isTriggerEnabled)
                                                    .withBypassUserId(bypassUserId)
                                                    .build();

        // Act
        Test.startTest();
        Boolean shouldBypass = TriggerConfigHelper.shouldBypassTrigger(triggerConfig);
        Test.stopTest();

        // Assert
        Assert.isFalse(shouldBypass, 'The trigger should not be bypassed');
    }
}