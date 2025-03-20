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
    static void testGetFullCmt() {
        // Arrange
        String cmtRecordName = 'Foobar';
        Integer timeIntervalInMinutes = 1;
        String leadSource = 'MyleadSource';
        String campaignNamePrefix = 'MycampaignNamePrefix';
        String campaignNameDelimiter = '#';
        String timeFormat = 'HHmmss yyyyMMdd';
        String campaignDefaultStatus = 'In Progress';
        String campaignMemberDefaultStatus = 'Received';

        Leads_to_Campaigns_Config__mdt newConfig = new LeadsToCampaignsConfigTestDataFactory()
                                                    .withDeveloperName(cmtRecordName)
                                                    .withTimeIntervalInMinutes(timeIntervalInMinutes)
                                                    .withLeadSource(leadSource)
                                                    .withCampaignNamePrefix(campaignNamePrefix)
                                                    .withCampaignNameDelimiter(campaignNameDelimiter)
                                                    .withTimeFormat(timeFormat)
                                                    .withCampaignDefaultStatus(campaignDefaultStatus)
                                                    .withCampaignMemberDefaultStatus(campaignMemberDefaultStatus)
                                                    .build();

        // Act
        Test.startTest();
        Leads_to_Campaigns_Config__mdt retrievedConfig = LeadsToCampaignsConfigHelper.getConfig(cmtRecordName);
        Integer retrievedTimeIntervalInMinutes = (Integer)LeadsToCampaignsConfigHelper.getTimeIntervalInMinutes(newConfig);
        String retrievedLeadSource = LeadsToCampaignsConfigHelper.getLeadSource(newConfig);
        String retrievedCampaignNamePrefix = LeadsToCampaignsConfigHelper.getCampaignNamePrefix(newConfig);
        String retrievedCampaignNameDelimiter = LeadsToCampaignsConfigHelper.getCampaignNameDelimiter(newConfig);
        String retrievedTimeFormat = LeadsToCampaignsConfigHelper.getTimeFormat(newConfig);
        String retrievedCampaignDefaultStatus = LeadsToCampaignsConfigHelper.getCampaignDefaultStatus(newConfig);
        String retrievedCampaignMemberDefaultStatus = LeadsToCampaignsConfigHelper.getCampaignMemberDefaultStatus(newConfig);
        Test.stopTest();

        // Assert
        Assert.areEqual(cmtRecordName, newConfig.DeveloperName, 'DeveloperName should match the input.');
        Assert.areEqual(timeIntervalInMinutes, retrievedTimeIntervalInMinutes, 'retrievedTimeIntervalInMinutes should match the input.');
        Assert.areEqual(leadSource, retrievedLeadSource, 'retrievedLeadSource should match the input.');
        Assert.areEqual(campaignNamePrefix, retrievedCampaignNamePrefix, 'retrievedCampaignNamePrefix should match the input.');
        Assert.areEqual(campaignNameDelimiter, retrievedCampaignNameDelimiter, 'retrievedCampaignNameDelimiter should match the input.');
        Assert.areEqual(timeFormat, retrievedTimeFormat, 'retrievedTimeFormat should match the input.');
        Assert.areEqual(campaignDefaultStatus, retrievedCampaignDefaultStatus, 'retrievedCampaignDefaultStatus should match the input.');
        Assert.areEqual(campaignMemberDefaultStatus, retrievedCampaignMemberDefaultStatus, 'retrievedCampaignMemberDefaultStatus should match the input.');
    }
}