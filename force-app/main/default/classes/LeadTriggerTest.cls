/**
 * Test class created using the Arrange-Act-Assert (AAA) Pattern.
 */
@isTest
private class LeadTriggerTest {

    @isTest
    static void testLeadTrigger() {
        // Arrange
        User currentUser = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        Leads_to_Campaigns_Config__mdt config = LeadsToCampaignsConfigHelper.getConfig(LeadsToCampaignsConfigHelper.CMT_RECORD_NAME_FOOBAR);
        String campaignNamePattern = LeadsToCampaignsConfigHelper.getCampaignNamePrefix(config)
                                        + LeadsToCampaignsConfigHelper.getCampaignNameDelimiter(config)
                                        + currentUser.Name
                                        + LeadsToCampaignsConfigHelper.getCampaignNameDelimiter(config)
                                        + '%';
        List<Lead> leads = new LeadTestDataFactory().withLeadSource(LeadsToCampaignsConfigHelper.getLeadSource(config)).build(3);

        // Act
        Test.startTest();
        insert leads;
        Test.stopTest();

        // Assert
        List<Campaign> campaigns = [SELECT Id, Name FROM Campaign WHERE Name LIKE :campaignNamePattern];
        Assert.areNotEqual(0, campaigns.size(), 'A Campaign should have been created for Foobar leads.');
        List<CampaignMember> campaignMembers = [SELECT Id FROM CampaignMember WHERE CampaignId = :campaigns[0].Id];
        Assert.areEqual(3, campaignMembers.size(), 'There should be 3 CampaignMember records associated with the campaign.');
    }
}