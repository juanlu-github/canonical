/**
 * Test class created using the Arrange-Act-Assert (AAA) Pattern.
 */
@IsTest
public class LeadsToCampaignsConfigHelperTest {

    @isTest
    static void testgetConfigNonExistingClass() {
        // Arrange
        String cmtRecordName = 'Test_Non-ExistingClass';

        // Act
        Test.startTest();
        Leads_to_Campaigns_Config__mdt retrievedConfig = LeadsToCampaignsConfigHelper.getConfig(cmtRecordName);
        Test.stopTest();

        // Assert
        Assert.isNull(retrievedConfig.DeveloperName, 'DeveloperName should be null, because the corresponding Leads_to_Campaigns_Config__mdt record does not exist.');
        Assert.areEqual(0, retrievedConfig.Time_Interval_in_Minutes__c, 'Time_Interval_in_Minutes__c should be the default 0, because the corresponding Leads_to_Campaigns_Config__mdt record does not exist.');
    }

    @isTest
    static void testgetConfigExistingClass() {
        // Arrange
        String cmtRecordName = 'Foobar';

        // Act
        Test.startTest();
        Leads_to_Campaigns_Config__mdt retrievedConfig = LeadsToCampaignsConfigHelper.getConfig(cmtRecordName);
        Test.stopTest();

        // Assert
        Assert.areEqual(cmtRecordName, retrievedConfig.DeveloperName, 'DeveloperName should match the input.');
    }

    @isTest
    static void testGetTimeIntervalInMinutes() {
        // Arrange
        String cmtRecordName = 'Foobar';
        Integer timeIntervalInMinutes = 5;
        Leads_to_Campaigns_Config__mdt newConfig = new LeadsToCampaignsConfigTestDataFactory()
                                                    .withDeveloperName(cmtRecordName)
                                                    .withTimeIntervalInMinutes(timeIntervalInMinutes)
                                                    .build();

        // Act
        Test.startTest();
        Integer retrievedTimeIntervalInMinutes = (Integer)LeadsToCampaignsConfigHelper.getTimeIntervalInMinutes(newConfig);
        Test.stopTest();

        // Assert
        Assert.areEqual(cmtRecordName, newConfig.DeveloperName, 'DeveloperName should match the input.');
        Assert.areEqual(retrievedTimeIntervalInMinutes, newConfig.Time_Interval_in_Minutes__c, 'Time_Interval_in_Minutes__c should match the input.');
        Assert.areEqual(retrievedTimeIntervalInMinutes, timeIntervalInMinutes, 'Time_Interval_in_Minutes__c should match the input.');
    }

    @isTest
    static void testGetLeadSource() {
        // Arrange
        String cmtRecordName = 'Foobar';
        String leadSource = 'Foobar';
        Leads_to_Campaigns_Config__mdt newConfig = new LeadsToCampaignsConfigTestDataFactory()
                                                    .withDeveloperName(cmtRecordName)
                                                    .withLeadSource(leadSource)
                                                    .build();

        // Act
        Test.startTest();
        String retrievedLeadSource = LeadsToCampaignsConfigHelper.getLeadSource(newConfig);
        Test.stopTest();

        // Assert
        Assert.areEqual(cmtRecordName, newConfig.DeveloperName, 'DeveloperName should match the input.');
        Assert.areEqual(retrievedLeadSource, newConfig.Lead_Source__c, 'Lead_Source__c should match the input.');
        Assert.areEqual(retrievedLeadSource, leadSource, 'Lead_Source__c should match the input.');
    }

    @isTest
    static void testGetCampaignNamePrefix() {
        // Arrange
        String cmtRecordName = 'Foobar';
        String campaignNamePrefix = 'Foobar -';
        Leads_to_Campaigns_Config__mdt newConfig = new LeadsToCampaignsConfigTestDataFactory()
                                                    .withDeveloperName(cmtRecordName)
                                                    .withCampaignNamePrefix(campaignNamePrefix)
                                                    .build();

        // Act
        Test.startTest();
        String retrievedCampaignNamePrefix = LeadsToCampaignsConfigHelper.getCampaignNamePrefix(newConfig);
        Test.stopTest();

        // Assert
        Assert.areEqual(cmtRecordName, newConfig.DeveloperName, 'DeveloperName should match the input.');
        Assert.areEqual(retrievedCampaignNamePrefix, newConfig.Campaign_Name_Prefix__c, 'Campaign_Name_Prefix__c should match the input.');
        Assert.areEqual(retrievedCampaignNamePrefix, campaignNamePrefix, 'Campaign_Name_Prefix__c should match the input.');
    }

    @isTest
    static void testGetCampaignDefaultStatus() {
        // Arrange
        String cmtRecordName = 'Foobar';
        String campaignDefaultStatus = 'Planned';
        Leads_to_Campaigns_Config__mdt newConfig = new LeadsToCampaignsConfigTestDataFactory()
                                                    .withDeveloperName(cmtRecordName)
                                                    .withCampaignDefaultStatus(campaignDefaultStatus)
                                                    .build();

        // Act
        Test.startTest();
        String retrievedCampaignDefaultStatus = LeadsToCampaignsConfigHelper.getCampaignDefaultStatus(newConfig);
        Test.stopTest();

        // Assert
        Assert.areEqual(cmtRecordName, newConfig.DeveloperName, 'DeveloperName should match the input.');
        Assert.areEqual(retrievedCampaignDefaultStatus, newConfig.Campaign_Defaul_Status__c, 'Campaign_Defaul_Status__c should match the input.');
        Assert.areEqual(retrievedCampaignDefaultStatus, campaignDefaultStatus, 'Campaign_Defaul_Status__c should match the input.');
    }

    @isTest
    static void testGetCampaignMemberDefaultStatus() {
        // Arrange
        String cmtRecordName = 'Foobar';
        String campaignMemberDefaultStatus = 'Foobar -';
        Leads_to_Campaigns_Config__mdt newConfig = new LeadsToCampaignsConfigTestDataFactory()
                                                    .withDeveloperName(cmtRecordName)
                                                    .withCampaignMemberDefaultStatus(campaignMemberDefaultStatus)
                                                    .build();

        // Act
        Test.startTest();
        String retrievedCampaignMemberDefaultStatus = LeadsToCampaignsConfigHelper.getCampaignMemberDefaultStatus(newConfig);
        Test.stopTest();

        // Assert
        Assert.areEqual(cmtRecordName, newConfig.DeveloperName, 'DeveloperName should match the input.');
        Assert.areEqual(retrievedCampaignMemberDefaultStatus, newConfig.Campaign_Member_Default_Status__c, 'Campaign_Member_Default_Status__c should match the input.');
        Assert.areEqual(retrievedCampaignMemberDefaultStatus, campaignMemberDefaultStatus, 'Campaign_Member_Default_Status__c should match the input.');
    }
}