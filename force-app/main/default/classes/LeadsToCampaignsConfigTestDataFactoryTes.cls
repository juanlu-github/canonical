/**
 * Test class created using the Arrange-Act-Assert (AAA) Pattern.
 */
@isTest
private class LeadsToCampaignsConfigTestDataFactoryTes {

    @isTest
    static void testBuildSingleRecord() {
        // Arrange
        String cmtRecordName = 'Foobar';
        Double timeIntervalInMinutes = 0.5;

        LeadsToCampaignsConfigTestDataFactory factory = new LeadsToCampaignsConfigTestDataFactory()
                                                .withDeveloperName(cmtRecordName)
                                                .withTimeIntervalInMinutes(timeIntervalInMinutes);

        // Act
        Leads_to_Campaigns_Config__mdt record = factory.build();

        // Assert
        Assert.areEqual(cmtRecordName, record.DeveloperName, 'DeveloperName should match the input value');
        Assert.areEqual(timeIntervalInMinutes, record.Time_Interval_in_Minutes__c, 'Time_Interval_in_Minutes__c should match the input value');
    }
}