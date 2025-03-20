public with sharing class LeadTriggerHandler {

    // This constant values should be created in a CMT or a Custom Setting.
    public static final String FOOBAR_LEAD_SOURCE = 'Foobar';
    public static final Integer FOOBAR_WINDOW_MINUTES = 15;
    public static final String CAMPAIGN_NAME_PREFIX = 'Foobar - ';
    public static final String CAMPAIGN_DEFAULT_STATUS = 'Planned';
    public static final String CAMPAIGN_MEMBER_DEFAULT_STATUS = 'Sent';

    /**
     * Main entry point to process newly inserted Leads.
     * Filters for Foobar leads, groups them by sales rep, finds or creates an appropriate campaign,
     * and associates each lead with its campaign via CampaignMember records.
     */
    public static void processFoobarLeads(List<Lead> newLeads) { // handleAfterInsert
        // Step 1: Filter leads injected by Foobar.
        List<Lead> foobarLeads = LeadHelper.filterLeadsBySource(newLeads, FOOBAR_LEAD_SOURCE);
        if (foobarLeads.isEmpty()) {
            return;
        }

        // Step 2: Retrieve the user performing the insertion.
        User currentUser = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

        // Step 3: Find or create a campaign for the inserting user.
        DateTime currentTime = System.now();
        Campaign userCampaign = CampaignHelper.findOrCreateCampaign(currentUser, currentTime);

        // Step 4: Create CampaignMember records to associate leads with the campaign.
        CampaignHelper.createCampaignMembers(foobarLeads, userCampaign);
    }
}