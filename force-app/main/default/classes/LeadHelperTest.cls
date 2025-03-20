/**
 * Test class created using the Arrange-Act-Assert (AAA) Pattern.
 */
@isTest
private class LeadHelperTest {

    @isTest
    static void testFilterLeadsBySourcePositive() {
        // Arrange
        String leadSource1 = 'Foobar';
        String leadSource2 = 'Other';
        String leadSource3 = 'Foobar';
        String filteredLeadSource = 'Foobar';
        LeadTestDataFactory factory = new LeadTestDataFactory();
        List<Lead> testLeads = new List<Lead>();
        testLeads.add(factory
                            .withLeadSource(leadSource1)
                            .build()
        );
        testLeads.add(factory
                            .withLeadSource(leadSource2)
                            .build()
        );
        testLeads.add(factory
                            .withLeadSource(leadSource3)
                            .build()
        );

        // Act
        List<Lead> filteredLeads = LeadHelper.filterLeadsBySource(testLeads, filteredLeadSource);

        // Assert
        Assert.areEqual(2, filteredLeads.size(), 'Expected 2 leads with LeadSource "Foobar"');
        for (Lead lead : filteredLeads) {
            Assert.areEqual(filteredLeadSource, lead.LeadSource, 'Every lead in the filtered list must have LeadSource "Foobar"');
        }
    }

    @isTest
    static void testFilterLeadsBySourceNegative() {
        // Arrange
        String leadSource1 = 'NotFoobar';
        String leadSource2 = 'Other';
        String filteredLeadSource = 'Foobar';
        LeadTestDataFactory factory = new LeadTestDataFactory();
        List<Lead> testLeads = new List<Lead>();
        testLeads.add(factory
                            .withLeadSource(leadSource1)
                            .build()
        );
        testLeads.add(factory
                            .withLeadSource(leadSource2)
                            .build()
        );

        // Act
        List<Lead> filteredLeads = LeadHelper.filterLeadsBySource(testLeads, filteredLeadSource);

        // Assert
        Assert.areEqual(0, filteredLeads.size(), 'Expected no leads to be returned when none have LeadSource "Foobar"');
    }
}
