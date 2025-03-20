public with sharing class CampaignHelper {
 
    public static Campaign findOrCreateCampaign(User user, DateTime currentTime) {
        Campaign recentCampaign = getRecentCampaign(user, currentTime);
        if (recentCampaign != null) {
            return recentCampaign;
        }

        return insertNewCampaign(user.Name, currentTime);
    }

    public static Campaign getRecentCampaign(User user, DateTime currentTime) {
        Leads_to_Campaigns_Config__mdt config = LeadsToCampaignsConfigHelper.getConfig(LeadsToCampaignsConfigHelper.CMT_RECORD_NAME_FOOBAR);
        String campaignNamePattern = LeadsToCampaignsConfigHelper.getCampaignNamePrefix(config) + user.Name + ' - %';
        DateTime cutoffTime = currentTime.addMinutes(-(Integer)LeadsToCampaignsConfigHelper.getTimeIntervalInMinutes(config));
        List<Campaign> recentCampaigns = [
            SELECT Id, Name, CreatedDate
            FROM Campaign
            WHERE Name LIKE :campaignNamePattern
              AND CreatedDate >= :cutoffTime
              AND CreatedById = :user.Id // If two people with the same name (e.g. Jane Doe) start loading Leads at the same time, we want to differentiate the campaigns based on who they belong to. 
              // This is irrelevant when the sharing model for Campaigns is set to Private, because this class is declared as "public with sharing" and Campaigns from other users would not be visible.
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];
        return recentCampaigns.isEmpty() ? null : recentCampaigns[0];
    }

    public static Campaign insertNewCampaign(String repName, DateTime currentTime) {
        Leads_to_Campaigns_Config__mdt config = LeadsToCampaignsConfigHelper.getConfig(LeadsToCampaignsConfigHelper.CMT_RECORD_NAME_FOOBAR);
        String campaignName = LeadsToCampaignsConfigHelper.getCampaignNamePrefix(config) + repName + ' - ' + currentTime.format('yyyyMMddHHmmss');
        Campaign newCampaign = new Campaign(
            Name = campaignName,
            Status = LeadsToCampaignsConfigHelper.getCampaignDefaultStatus(config)
        );
        try {
            insert newCampaign;
        } catch (Exception e) {
            // For potential improvements in logging, see POTENTIAL IMPROVEMENT in the method insertRecords.
            System.debug('Error in ' + CampaignHelper.class.getName() + ': ' + e.getMessage() + ' | ' +  e.getLineNumber() + ' | ' + e.getStackTraceString());
            throw e;    
        }
        return newCampaign;
    } // POTENTIAL IMPROVEMENT: set the campaignName not only in the Name, but also in a custom External Id field. 
    // This field would then be used in the SOQL to fetch the campaigns instead of using the Name. Advantages:
    // In case of a new requirement to set a different campaing naming convention, or to allow users to rename the campaigns, the automations would still work.
    // The External Id field wouldn't need to be displayed in the Page. It would make sense to make it an External Id if there are hundreds of thousands or even millions of Campaigns,
    // so that the field is indexed.

    public static void createCampaignMembers(List<Lead> leads, Campaign campaign) {
        Leads_to_Campaigns_Config__mdt config = LeadsToCampaignsConfigHelper.getConfig(LeadsToCampaignsConfigHelper.CMT_RECORD_NAME_FOOBAR);
        List<CampaignMember> campaignMembers = new List<CampaignMember>();
        for (Lead lead : leads) {
            campaignMembers.add(new CampaignMember(
                CampaignId = campaign.Id,
                LeadId = lead.Id,
                Status = LeadsToCampaignsConfigHelper.getCampaignMemberDefaultStatus(config)
            ));
        }
        if (!campaignMembers.isEmpty()) {
            DatabaseUtility.insertMultipleRecords(campaignMembers); //Uses Database.insert to allow partial inserts, error-handling and logging.
        }
    }
}