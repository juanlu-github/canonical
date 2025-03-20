public with sharing class LeadHelper {
    
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