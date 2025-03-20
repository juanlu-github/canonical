/**
 * Test class created using the Arrange-Act-Assert (AAA) Pattern.
 */
@isTest
private class LeadsToCampaignsConfigTestDataFactoryTes {

    @isTest
    static void testBuildSingleRecord() {
        // Arrange
        String cmtRecordName = 'MycmtRecordName';
        Integer timeIntervalInMinutes = 1;
        String leadSource = 'MyleadSource';
        String campaignNamePrefix = 'MycampaignNamePrefix';
        String campaignNameDelimiter = '#';
        String timeFormat = 'HHmmss yyyyMMdd';
        String campaignDefaultStatus = 'In Progress';
        String campaignMemberDefaultStatus = 'Received';

        LeadsToCampaignsConfigTestDataFactory factory = new LeadsToCampaignsConfigTestDataFactory()
                                                .withDeveloperName(cmtRecordName)
                                                .withTimeIntervalInMinutes(timeIntervalInMinutes)
                                                .withLeadSource(leadSource)
                                                .withCampaignNamePrefix(campaignNamePrefix)
                                                .withCampaignNameDelimiter(campaignNameDelimiter)
                                                .withTimeFormat(timeFormat)
                                                .withCampaignDefaultStatus(campaignDefaultStatus)
                                                .withCampaignMemberDefaultStatus(campaignMemberDefaultStatus);

        // Act
        Test.startTest();
        Leads_to_Campaigns_Config__mdt record = factory.build();
        Test.stopTest();

        // Assert
        Assert.areEqual(cmtRecordName, record.DeveloperName, 'DeveloperName should match the input value');
        Assert.areEqual(timeIntervalInMinutes, record.Time_Interval_in_Minutes__c, 'Time_Interval_in_Minutes__c should match the input value');
        Assert.areEqual(leadSource, record.Lead_Source__c, 'Lead_Source__c should match the input value');
        Assert.areEqual(campaignNamePrefix, record.Campaign_Name_Prefix__c, 'Campaign_Name_Prefix__c should match the input value');
        Assert.areEqual(campaignNameDelimiter, record.Campaign_Name_Delimiter__c, 'Campaign_Name_Delimiter__c should match the input value');
        Assert.areEqual(timeFormat, record.Time_Format__c, 'Time_Format__c should match the input value');
        Assert.areEqual(campaignDefaultStatus, record.Campaign_Defaul_Status__c, 'Campaign_Defaul_Status__c should match the input value');
        Assert.areEqual(campaignMemberDefaultStatus, record.Campaign_Member_Default_Status__c, 'Campaign_Member_Default_Status__c should match the input value');
    }
}