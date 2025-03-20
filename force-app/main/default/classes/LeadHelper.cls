public with sharing class LeadHelper {
    
    public static void processFoobarLeads(List<Lead> newLeads) {
        // Step 1: Filter leads injected by Foobar.
        List<Lead> foobarLeads = LeadHelper.filterLeadsBySource(newLeads, LeadsToCampaignsConfigHelper.getLeadSource(LeadsToCampaignsConfigHelper.getConfig(LeadsToCampaignsConfigHelper.CMT_RECORD_NAME_FOOBAR)));
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

    public static List<Lead> filterLeadsBySource(List<Lead> leads, String source) {
        List<Lead> filtered = new List<Lead>();
        for (Lead lead : leads) {
            if (lead.LeadSource == source) {
                filtered.add(lead);
            }
        }
        return filtered;
    }
}