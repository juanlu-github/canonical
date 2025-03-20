public with sharing class LeadsToCampaignsConfigHelper {

    public static final String CMT_RECORD_NAME_FOOBAR = 'Foobar';

    public static Leads_to_Campaigns_Config__mdt getConfig(String cmtRecordName) {
        Leads_to_Campaigns_Config__mdt config;
        try {
            config = [
                SELECT DeveloperName, Lead_Source__c, Campaign_Name_Prefix__c, Campaign_Name_Delimiter__c, Time_Format__c, Time_Interval_in_Minutes__c, Campaign_Defaul_Status__c, Campaign_Member_Default_Status__c
                FROM Leads_to_Campaigns_Config__mdt
                WHERE DeveloperName = :cmtRecordName
                LIMIT 1
            ];
        } catch (System.QueryException qe) {
            System.debug(LoggingLevel.WARN, 'A Leads_to_Campaigns_Config__mdt record with DeveloperName = ' + cmtRecordName + ' does not exist. The default time interval in minutes will be 0.');
            config = new Leads_to_Campaigns_Config__mdt(Time_Interval_in_Minutes__c = 0);
        }
        return config;
    }

    public static Integer getTimeIntervalInMinutes(Leads_to_Campaigns_Config__mdt config) {
        if (config != null && config.Time_Interval_in_Minutes__c != null && config.Time_Interval_in_Minutes__c > 0) {
            return (Integer)config.Time_Interval_in_Minutes__c;
        } else {
            return 0;
        }
    }

    public static String getLeadSource(Leads_to_Campaigns_Config__mdt config) {
        return config?.Lead_Source__c ?? '';
    }

    public static String getCampaignNamePrefix(Leads_to_Campaigns_Config__mdt config) {
        return config?.Campaign_Name_Prefix__c ?? '';
    }

    public static String getCampaignNameDelimiter(Leads_to_Campaigns_Config__mdt config) {
        return config?.Campaign_Name_Delimiter__c ?? '';
    }

    public static String getTimeFormat(Leads_to_Campaigns_Config__mdt config) {
        return config?.Time_Format__c ?? '';
    }

    public static String getCampaignDefaultStatus(Leads_to_Campaigns_Config__mdt config) {
        return config?.Campaign_Defaul_Status__c ?? '';
    }

    public static String getCampaignMemberDefaultStatus(Leads_to_Campaigns_Config__mdt config) {
        return config?.Campaign_Member_Default_Status__c ?? '';
    }
}