/**
 * Test class created using the Arrange-Act-Assert (AAA) Pattern.
 */
@isTest
private class LeadTriggerHandlerTest {

    @testSetup
    static void setupTestData() {
        User testUser = new User(
            Alias = 'user',
            Email = 'user@canonical-is-great.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'User',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'user@canonical-is-great.com'
        );
        insert testUser;
    }

    @isTest
    static void testProcessFoobarLeadsNoPreviousCampaignPositive() {
        // Arrange
        List<Lead> leads = new LeadTestDataFactory().withLeadSource(LeadTriggerHandler.FOOBAR_LEAD_SOURCE).build(3);
        insert leads;

        User currentUser = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        String campaignNamePattern = LeadTriggerHandler.CAMPAIGN_NAME_PREFIX + currentUser.Name + ' - %';

        // Act
        Test.startTest();
        LeadTriggerHandler.processFoobarLeads(leads);
        Test.stopTest();

        // Assert
        List<Campaign> campaigns = [SELECT Id, Name FROM Campaign WHERE Name LIKE :campaignNamePattern];
        Assert.areNotEqual(0, campaigns.size(), 'A Campaign should have been created for Foobar leads.');
        List<CampaignMember> campaignMembers = [SELECT Id FROM CampaignMember WHERE CampaignId = :campaigns[0].Id];
        Assert.areEqual(3, campaignMembers.size(), 'There should be 3 CampaignMember records associated with the campaign.');
    }

    @isTest
    static void testProcessFoobarLeadsExistingCampaignPositive() {
        // Arrange
        User currentUser = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        DateTime currentTime = System.now();
        String campaignName = LeadTriggerHandler.CAMPAIGN_NAME_PREFIX + currentUser.Name + ' - ' + currentTime.format('yyyyMMddHHmmss');
        Campaign existingCampaign = new Campaign(
            Name = campaignName,
            Status = LeadTriggerHandler.CAMPAIGN_DEFAULT_STATUS
        );
        System.runAs(currentUser) {
            insert existingCampaign;
        }

        List<Lead> leads = new LeadTestDataFactory().withLeadSource(LeadTriggerHandler.FOOBAR_LEAD_SOURCE).build(2);
        insert leads;

        // Pre-check
        List<Campaign> campaignsBeforeProcessing = [SELECT Id FROM Campaign WHERE Name = :campaignName];
        Assert.areEqual(1, campaignsBeforeProcessing.size(), 'A campaign should exist.');

        // Act
        Test.startTest();
        LeadTriggerHandler.processFoobarLeads(leads);
        Test.stopTest();
        
        // Assert
        List<Campaign> campaignsAfterProcessing = [SELECT Id FROM Campaign WHERE Name = :campaignName];
        Assert.areEqual(1, campaignsAfterProcessing.size(), 'The existing campaign should have been reused.');
    }

    @isTest
    static void testProcessFoobarLeadsNoFoobarLeadsNegative() {
        // Arrange
        List<Lead> leads = new LeadTestDataFactory().withLeadSource('NotFoobar').build(3);
        insert leads;

        User currentUser = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        String campaignNamePattern = LeadTriggerHandler.CAMPAIGN_NAME_PREFIX + currentUser.Name + ' - %';

        // Act
        Test.startTest();
        LeadTriggerHandler.processFoobarLeads(leads);
        Test.stopTest();

        // Assert
        List<Campaign> campaigns = [SELECT Id FROM Campaign WHERE Name LIKE :campaignNamePattern];
        Assert.areEqual(0, campaigns.size(), 'No Campaign should be created for non-Foobar leads.');
    }
}
