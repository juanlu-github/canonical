/**
 * Test Data Factory class created using the Arrange-Act-Assert (AAA) Pattern.
 */
@isTest
private class LeadTestDataFactoryTest {

    // ----- Test Setup -----
    @testSetup
    static void setupTestData() {
        // ARRANGE: Create a test user for context.
        User testUser = new User(
            Alias = 'tuser',
            Email = 'tuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'User',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'tuser@example.com'
        );
        insert testUser;
    }

    // ----- processFoobarLeads Tests -----

    @isTest
    static void testProcessFoobarLeads_Positive() {
        // ARRANGE: Build multiple leads with the Foobar LeadSource.
        List<Lead> leads = new LeadTestDataFactory().build(3);
        for (Lead l : leads) {
            l.LeadSource = LeadTriggerHandler.FOOBAR_LEAD_SOURCE;
        }
        // ACT: Insert leads and call processFoobarLeads.
        Test.startTest();
        insert leads;
        LeadTriggerHandler.processFoobarLeads(leads);
        Test.stopTest();
        // ASSERT: Verify that a Campaign was created and 3 CampaignMember records were associated.
        User currentUser = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        String campaignNamePattern = LeadTriggerHandler.CAMPAIGN_NAME_PREFIX + currentUser.Name + ' - %';
        List<Campaign> campaigns = [SELECT Id, Name FROM Campaign WHERE Name LIKE :campaignNamePattern];
        System.assertNotEquals(0, campaigns.size(), 'A Campaign should have been created for Foobar leads.');
        List<CampaignMember> cms = [SELECT Id FROM CampaignMember WHERE CampaignId = :campaigns[0].Id];
        System.assertEquals(3, cms.size(), 'There should be 3 CampaignMember records associated with the campaign.');
    }

    @isTest
    static void testProcessFoobarLeads_NoFoobarLeads() {
        // ARRANGE: Build leads with a non-Foobar LeadSource.
        List<Lead> leads = new LeadTestDataFactory().build(2);
        for (Lead l : leads) {
            l.LeadSource = 'NotFoobar';
        }
        // ACT: Insert leads and call processFoobarLeads.
        Test.startTest();
        insert leads;
        LeadTriggerHandler.processFoobarLeads(leads);
        Test.stopTest();
        // ASSERT: Verify that no Campaign was created.
        List<Campaign> campaigns = [SELECT Id FROM Campaign WHERE Name LIKE :LeadTriggerHandler.CAMPAIGN_NAME_PREFIX + '%'];
        System.assertEquals(0, campaigns.size(), 'No Campaign should be created for non-Foobar leads.');
    }

    // ----- findOrCreateCampaign / getRecentCampaign / insertNewCampaign Tests -----

    @isTest
    static void testFindOrCreateCampaign_ExistingCampaign() {
        // ARRANGE: Create a campaign for the current user so it can be reused.
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
        // ARRANGE: Build Foobar leads.
        List<Lead> leads = new LeadTestDataFactory().build(2);
        for (Lead l : leads) {
            l.LeadSource = LeadTriggerHandler.FOOBAR_LEAD_SOURCE;
        }
        // ACT: Insert leads and invoke processFoobarLeads.
        Test.startTest();
        insert leads;
        LeadTriggerHandler.processFoobarLeads(leads);
        Test.stopTest();
        // ASSERT: Verify that the existing campaign was reused (no new campaign with that name).
        List<Campaign> campaigns = [SELECT Id FROM Campaign WHERE Name = :campaignName];
        System.assertEquals(1, campaigns.size(), 'The existing campaign should have been reused.');
    }

    @isTest
    static void testInsertNewCampaign_Error() {
        // ARRANGE: Create an overly long rep name to force a DML exception.
        String longRepName = '';
        for (Integer i = 0; i < 260; i++) {
            longRepName += 'X';
        }
        DateTime currentTime = System.now();
        Boolean exceptionThrown = false;
        // ACT:
        try {
            Test.startTest();
            LeadTriggerHandler.insertNewCampaign(longRepName, currentTime);
            Test.stopTest();
        } catch (Exception e) {
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        // ASSERT:
        System.assertEquals(true, exceptionThrown, 'An exception should be thrown for an invalid campaign name.');
    }

    // ----- createCampaignMembers Tests -----

    @isTest
    static void testCreateCampaignMembers_Positive() {
        // ARRANGE: Create a valid campaign.
        Campaign campaign = new Campaign(
            Name = LeadTriggerHandler.CAMPAIGN_NAME_PREFIX + 'TestUser - ' + System.now().format('yyyyMMddHHmmss'),
            Status = LeadTriggerHandler.CAMPAIGN_DEFAULT_STATUS
        );
        insert campaign;
        // ARRANGE: Build multiple Foobar leads and insert them.
        List<Lead> leads = new LeadTestDataFactory().build(3);
        for (Lead l : leads) {
            l.LeadSource = LeadTriggerHandler.FOOBAR_LEAD_SOURCE;
        }
        insert leads;
        // ACT: Invoke createCampaignMembers.
        Test.startTest();
        LeadTriggerHandler.createCampaignMembers(leads, campaign);
        Test.stopTest();
        // ASSERT: Verify that CampaignMember records are created.
        List<CampaignMember> cms = [SELECT Id FROM CampaignMember WHERE CampaignId = :campaign.Id];
        System.assertEquals(3, cms.size(), '3 CampaignMember records should have been created.');
    }

    // ----- insertRecords Tests -----

    @isTest
    static void testInsertRecords_Positive() {
        // ARRANGE: Build a list of valid leads.
        List<Lead> leads = new LeadTestDataFactory().build(3);
        // ACT: Call insertRecords.
        Test.startTest();
        LeadTriggerHandler.insertRecords(leads);
        Test.stopTest();
        // ASSERT: Verify that 3 leads were inserted.
        Integer leadCount = [SELECT COUNT() FROM Lead WHERE LastName LIKE 'Test Data Factory%' ];
        System.assertEquals(3, leadCount, '3 valid leads should have been inserted.');
    }

    @isTest
    static void testInsertRecords_ErrorCase() {
        // ARRANGE: Build a list with valid leads and an invalid record (null).
        List<Lead> leads = new LeadTestDataFactory().build(2);
        leads.add(null);
        Boolean exceptionThrown = false;
        // ACT:
        try {
            Test.startTest();
            LeadTriggerHandler.insertRecords(leads);
            Test.stopTest();
        } catch (Exception e) {
            exceptionThrown = true;
            System.debug('Expected exception in insertRecords: ' + e.getMessage());
        }
        // ASSERT:
        System.assertEquals(true, exceptionThrown, 'An exception should be thrown when inserting invalid records.');
    }
}
