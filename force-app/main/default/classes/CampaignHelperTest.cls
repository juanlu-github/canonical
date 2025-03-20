/**
 * Test class created using the Arrange-Act-Assert (AAA) Pattern.
 */
@isTest
private class CampaignHelperTest {

    // -------------------------------------------------- getRecentCampaign --------------------------------------------------

    @isTest
    static void testGetRecentCampaignPositive() {
        // Arrange
        User currentUser = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        DateTime currentTime = System.now();
        Leads_to_Campaigns_Config__mdt config = LeadsToCampaignsConfigHelper.getConfig(LeadsToCampaignsConfigHelper.CMT_RECORD_NAME_FOOBAR);
        String campaignName = LeadsToCampaignsConfigHelper.getCampaignNamePrefix(config)
                                 + LeadsToCampaignsConfigHelper.getCampaignNameDelimiter(config)
                                 + currentUser.Name
                                 + LeadsToCampaignsConfigHelper.getCampaignNameDelimiter(config)
                                 + currentTime.format(LeadsToCampaignsConfigHelper.getTimeFormat(config));
        Campaign newCampaign = new Campaign(
            Name = campaignName,
            Status = LeadsToCampaignsConfigHelper.getCampaignDefaultStatus(config)
        );
        System.runAs(currentUser) {
            insert newCampaign;
        }
        
        // Act
        Test.startTest();
        Campaign result = CampaignHelper.getRecentCampaign(currentUser, currentTime);
        Test.stopTest();
        
        // Assert
        Assert.isNotNull(result, 'Expected to retrieve a recent campaign.');
        Assert.areEqual(newCampaign.Id, result.Id, 'The retrieved campaign should match the inserted campaign.');
    }
    
    @isTest
    static void testGetRecentCampaignNegative() {
        // Arrange
        User currentUser = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        DateTime currentTime = System.now();
        
        // Act
        Test.startTest();
        Campaign result = CampaignHelper.getRecentCampaign(currentUser, currentTime);
        Test.stopTest();
        
        // Assert
        Assert.isNull(result, 'Expected null when no matching recent campaign exists.');
    }

    // -------------------------------------------------- insertNewCampaign --------------------------------------------------

    @isTest
    static void testInsertNewCampaignPositive() {
        // Arrange
        String repName = 'Jane Doe';
        DateTime currentTime = System.now();
        Leads_to_Campaigns_Config__mdt config = LeadsToCampaignsConfigHelper.getConfig(LeadsToCampaignsConfigHelper.CMT_RECORD_NAME_FOOBAR);
        String campaignName = LeadsToCampaignsConfigHelper.getCampaignNamePrefix(config)
                                + LeadsToCampaignsConfigHelper.getCampaignNameDelimiter(config)
                                + repName
                                + LeadsToCampaignsConfigHelper.getCampaignNameDelimiter(config)
                                + currentTime.format(LeadsToCampaignsConfigHelper.getTimeFormat(config));

        // Pre-check
        List<Campaign> campaignsBeforeProcessing = [SELECT Id FROM Campaign WHERE Name = :campaignName];
        Assert.areEqual(0, campaignsBeforeProcessing.size(), 'No campaign should exist.');

        // Act
        Test.startTest();
        CampaignHelper.insertNewCampaign(repName, currentTime);
        Test.stopTest();
        
        // Assert
        List<Campaign> campaignsAfterProcessing = [SELECT Id FROM Campaign WHERE Name = :campaignName];
        Assert.areEqual(1, campaignsAfterProcessing.size(), 'A campaign should have been inserted.');
    }

    @isTest
    static void testInsertNewCampaignError() {
        // Arrange
        // Create an overly long rep name to force a DML exception.
        String longRepName = '';
        for (Integer i = 0; i < 260; i++) {
            longRepName += 'X';
        }
        DateTime currentTime = System.now();
        Boolean exceptionThrown = false;
        
        // Act
        try {
            Test.startTest();
            CampaignHelper.insertNewCampaign(longRepName, currentTime);
            Test.stopTest();
        } catch (Exception e) {
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }

        // Assert
        Assert.isTrue(exceptionThrown, 'An exception should be thrown for an invalid campaign name.');
    }

    // -------------------------------------------------- createCampaignMembers --------------------------------------------------

    @isTest
    static void testCreateCampaignMembersPositive() {
        // Arrange
        Leads_to_Campaigns_Config__mdt config = LeadsToCampaignsConfigHelper.getConfig(LeadsToCampaignsConfigHelper.CMT_RECORD_NAME_FOOBAR);
        Campaign campaign = new Campaign(
            Name = LeadsToCampaignsConfigHelper.getCampaignNamePrefix(config) + 'TestUser - ' + System.now().format('yyyyMMddHHmmss'),
            Status = LeadsToCampaignsConfigHelper.getCampaignDefaultStatus(config)
        );
        insert campaign;

        List<Lead> leads = new LeadTestDataFactory().withLeadSource(LeadsToCampaignsConfigHelper.getLeadSource(config)).build(3);
        insert leads;

        // Act
        Test.startTest();
        CampaignHelper.createCampaignMembers(leads, campaign);
        Test.stopTest();

        // Assert
        List<CampaignMember> cms = [SELECT Id FROM CampaignMember WHERE CampaignId = :campaign.Id];
        Assert.areEqual(3, cms.size(), '3 CampaignMember records should have been created.');
    }

    @isTest
    static void testCreateCampaignMembersNegative() {
        // Arrange
        Leads_to_Campaigns_Config__mdt config = LeadsToCampaignsConfigHelper.getConfig(LeadsToCampaignsConfigHelper.CMT_RECORD_NAME_FOOBAR);
        Campaign campaign = new Campaign(
            Name = LeadsToCampaignsConfigHelper.getCampaignNamePrefix(config) + 'TestUser - ' + System.now().format('yyyyMMddHHmmss'),
            Status = LeadsToCampaignsConfigHelper.getCampaignDefaultStatus(config)
        );
        insert campaign;

        List<Lead> leads = new List<Lead>();

        // Pre-check
        List<CampaignMember> cmsBeforeInserting = [SELECT Id FROM CampaignMember WHERE CampaignId = :campaign.Id];
        Assert.areEqual(0, cmsBeforeInserting.size(), '0 CampaignMember records should have been created.');

        // Act
        Test.startTest();
        CampaignHelper.createCampaignMembers(leads, campaign);
        Test.stopTest();

        // Assert
        List<CampaignMember> cmsAfterInserting = [SELECT Id FROM CampaignMember WHERE CampaignId = :campaign.Id];
        Assert.areEqual(0, cmsAfterInserting.size(), '0 CampaignMember records should have been created.');
    }
}