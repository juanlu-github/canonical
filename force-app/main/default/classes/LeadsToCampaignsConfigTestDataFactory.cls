/**
 * Test Data Factory class created using the Builder Pattern.
 */
public class LeadsToCampaignsConfigTestDataFactory {
    private final static String DEFAULT_CMT_RECORD_NAME = 'Foobar'; // Default value, can/should be overwritten using withDeveloperName and withLeadSource
    private final static String DEFAULT_CAMPAIGN_NAME_PREFIX = 'Foobar -'; // Default value, can/should be overwritten using withCampaignNamePrefix
    private final static String DEFAULT_CAMPAIGN_DEFAULT_STATUS = 'Planned'; // Default value, can/should be overwritten using withCampaignDefaultStatus
    private final static String DEFAULT_CAMPAIGN_MEMBER_DEFAULT_STATUS = 'Sent'; // Default value, can/should be overwritten using withCampaignMemberDefaultStatus
    
    private Leads_to_Campaigns_Config__mdt record;

    public LeadsToCampaignsConfigTestDataFactory() {
        record = new Leads_to_Campaigns_Config__mdt();
        record.DeveloperName = DEFAULT_CMT_RECORD_NAME;
        record.Time_Interval_in_Minutes__c = 5;
        record.Lead_Source__c = DEFAULT_CMT_RECORD_NAME;
        record.Campaign_Name_Prefix__c = DEFAULT_CAMPAIGN_NAME_PREFIX;
        record.Campaign_Defaul_Status__c = DEFAULT_CAMPAIGN_DEFAULT_STATUS;
        record.Campaign_Member_Default_Status__c = DEFAULT_CAMPAIGN_MEMBER_DEFAULT_STATUS;
    }

    public LeadsToCampaignsConfigTestDataFactory withDeveloperName(String cmtRecordName) {
        record.DeveloperName = cmtRecordName;
        return this;
    }

    public LeadsToCampaignsConfigTestDataFactory withTimeIntervalInMinutes(Integer timeIntervalInMinutes) {
        record.Time_Interval_in_Minutes__c = timeIntervalInMinutes;
        return this;
    }

    public LeadsToCampaignsConfigTestDataFactory withLeadSource(String leadSource) {
        record.Lead_Source__c = leadSource;
        return this;
    }

    public LeadsToCampaignsConfigTestDataFactory withCampaignNamePrefix(String campaignNamePrefix) {
        record.Campaign_Name_Prefix__c = campaignNamePrefix;
        return this;
    }

    public LeadsToCampaignsConfigTestDataFactory withCampaignNameDelimiter(String campaignNameDelimiter) {
        record.Campaign_Name_Delimiter__c = campaignNameDelimiter;
        return this;
    }

    public LeadsToCampaignsConfigTestDataFactory withTimeFormat(String timeFormat) {
        record.Time_Format__c = timeFormat;
        return this;
    }

    public LeadsToCampaignsConfigTestDataFactory withCampaignDefaultStatus(String campaignDefaultStatus) {
        record.Campaign_Defaul_Status__c = campaignDefaultStatus;
        return this;
    }

    public LeadsToCampaignsConfigTestDataFactory withCampaignMemberDefaultStatus(String campaignMemberDefaultStatus) {
        record.Campaign_Member_Default_Status__c = campaignMemberDefaultStatus;
        return this;
    }

    public Leads_to_Campaigns_Config__mdt build() {
        Leads_to_Campaigns_Config__mdt builtRecord = record.clone(false, false, false, false);
        record = new Leads_to_Campaigns_Config__mdt();  // Reinitialize to ensure a fresh record for each build
        return builtRecord;
    }
}