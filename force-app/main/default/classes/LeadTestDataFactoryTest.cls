/**
 * Test Data Factory class created using the Arrange-Act-Assert (AAA) Pattern.
 */
@isTest
private class LeadTestDataFactoryTest {

    @isTest
    static void testBuildSingleRecordWithDefaultValues() {
        // Arrange
        String defaultLastName = 'Test Data Factory - LastName'; // Default value in LeadTestDataFactory.cls
        String defaultCompany = 'Test Data Factory - Company'; // Default value in LeadTestDataFactory.cls
        LeadTestDataFactory factory = new LeadTestDataFactory();

        // Act
        Test.startTest();
        Lead record = factory.build();
        Test.stopTest();

        // Assert
        Assert.areEqual(defaultLastName, record.LastName, 'LastName is: "' + record?.LastName ?? '' + '", and should be: "' + defaultLastName + '"');
        Assert.areEqual(defaultCompany, record.Company, 'Company is: "' + record?.Company ?? '' + '", and should be: "' + defaultCompany + '"');
        Assert.isNull(record.LeadSource, 'LeadSource should be null, but instead is: "' + record.LeadSource + '"');
    }

    @isTest
    static void testBuildSingleRecordWithCustomValues() {
        // Arrange
        String lastName = 'Test Data Factory - LastName - TEST';
        String company = 'Test Data Factory - Company - TEST';
        String leadSource = 'Test Data Factory - LeadSource - TEST';
        LeadTestDataFactory factory = new LeadTestDataFactory();

        // Act
        Test.startTest();
        Lead record = factory
                            .withLastName(lastName)
                            .withCompany(company)
                            .withLeadSource(leadSource)
                            .build();
        Test.stopTest();

        // Assert
        Assert.areEqual(lastName, record.LastName, 'LastName is: "' + record?.LastName ?? '' + '", and should be: "' + lastName + '"');
        Assert.areEqual(company, record.Company, 'Company is: "' + record?.Company ?? '' + '", and should be: "' + company + '"');
        Assert.areEqual(leadSource, record.LeadSource, 'Company is: "' + record?.LeadSource ?? '' + '", and should be: "' + leadSource + '"');
    }

    @isTest
    static void testBuildMultipleRecords() {
        // Arrange
        String defaultLastName = 'Test Data Factory - LastName'; // Default value in LeadTestDataFactory.cls
        String defaultCompany = 'Test Data Factory - Company'; // Default value in LeadTestDataFactory.cls
        Integer numberOfRecords = 3;
        LeadTestDataFactory factory = new LeadTestDataFactory();

        // Act
        Test.startTest();
        List<Lead> records = factory.build(numberOfRecords);
        Test.stopTest();

        // Assert
        Assert.areEqual(numberOfRecords, records.size(), 'The number of created records should match the input value');
        for (Lead record : records) {
            Assert.areEqual(defaultLastName, record.LastName, 'LastName is: "' + record?.LastName ?? '' + '", and should be: "' + defaultLastName + '"');
            Assert.areEqual(defaultCompany, record.Company, 'Company is: "' + record?.Company ?? '' + '", and should be: "' + defaultCompany + '"');
            Assert.isNull(record.LeadSource, 'LeadSource should be null, but instead is: "' + record.LeadSource + '"');
        }
    }

    @isTest
    static void testMultipleFreshRecordsAreCreated() {
        // Arrange
        String lastName1 = 'Test Data Factory - LastName - TEST - 1';
        String lastName2 = 'Test Data Factory - LastName - TEST - 2';
        String company1 = 'Test Data Factory - Company - TEST - 1';
        String company2 = 'Test Data Factory - Company - TEST - 2';
        String leadSource1 = 'Test Data Factory - LeadSource - TEST - 1';
        String leadSource2 = 'Test Data Factory - LeadSource - TEST - 2';
        LeadTestDataFactory factory = new LeadTestDataFactory();
    
        // Act
        // Create two records with different values
        Test.startTest();
        Lead record1 = factory
                            .withLastName(lastName1)
                            .withCompany(company1)
                            .withLeadSource(leadSource1)
                            .build();
        Lead record2 = factory
                            .withLastName(lastName2)
                            .withCompany(company2)
                            .withLeadSource(leadSource2)
                            .build();
        Test.stopTest();

        // Assert
        // Verify that the records have different values and are separate instances
        Assert.areEqual(lastName1, record1.LastName, 'LastName is: "' + record1?.LastName ?? '' + '", and should be: "' + lastName1 + '"');
        Assert.areEqual(company1, record1.Company, 'Company is: "' + record1?.Company ?? '' + '", and should be: "' + company1 + '"');
        Assert.areEqual(leadSource1, record1.LeadSource, 'Company is: "' + record1?.LeadSource ?? '' + '", and should be: "' + leadSource1 + '"');

        Assert.areEqual(lastName2, record2.LastName, 'LastName is: "' + record2?.LastName ?? '' + '", and should be: "' + lastName2 + '"');
        Assert.areEqual(company2, record2.Company, 'Company is: "' + record2?.Company ?? '' + '", and should be: "' + company2 + '"');
        Assert.areEqual(leadSource2, record2.LeadSource, 'Company is: "' + record2?.LeadSource ?? '' + '", and should be: "' + leadSource2 + '"');
    
        // Ensure that the records are not the same instance by comparing object references, since the Id field is not set because the record has not been inserted into the database
        Assert.isTrue(record1 != record2, 'The records should be different instances');
    }

    @isTest
    static void testUnintentionalCarryover() {
        // Arrange
        String lastName1 = 'Test Data Factory - LastName - TEST - 1';
        String lastName2 = 'Test Data Factory - LastName - TEST - 2';
        String company1 = 'Test Data Factory - Company - TEST - 1';
        String company2 = 'Test Data Factory - Company - TEST - 2';
        String leadSource1 = 'Test Data Factory - LeadSource - TEST - 1';
        LeadTestDataFactory factory = new LeadTestDataFactory();

        // Act
        // Create the first record with specific values
        Test.startTest();
        Lead record1 = factory
                            .withLastName(lastName1)
                            .withCompany(company1)
                            .withLeadSource(leadSource1)
                            .build();
        // Create the second record without setting LeadSource (per default should be null)
        Lead record2 = factory
                            .withLastName(lastName2)
                            .withCompany(company2)
                            .build();
        Test.stopTest();

        // Assert
        Assert.areEqual(leadSource1, record1.LeadSource, 'LeadSource is: "' + record1?.LeadSource ?? '' + '", and should be: "' + company1 + '"');
        Assert.isNull(record2.LeadSource, 'LeadSource should be null, but instead is: "' + record2.LeadSource + '"');

        // Ensure that the records are not the same instance by comparing object references, since the Id field is not set because the record has not been inserted into the database
        Assert.isTrue(record1 != record2, 'The records should be different instances');
    }
}
