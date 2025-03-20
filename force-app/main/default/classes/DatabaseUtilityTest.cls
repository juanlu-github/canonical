/**
 * Test class created using the Arrange-Act-Assert (AAA) Pattern.
 */
@isTest
private class DatabaseUtilityTest {

    @isTest
    static void testInsertMultipleRecordsPositive() {
        // Arrange
        List<Lead> leads = new LeadTestDataFactory().build(3);

        // Pre-check
        Integer leadCountBeforeInserting = [SELECT COUNT() FROM Lead];
        Assert.areEqual(0, leadCountBeforeInserting, '0 valid leads should have been inserted.');
        
        // Act
        Test.startTest();
        DatabaseUtility.insertMultipleRecords(leads);
        Test.stopTest();

        // Assert
        Integer leadCountAfterInserting = [SELECT COUNT() FROM Lead];
        Assert.areEqual(3, leadCountAfterInserting, '3 valid leads should have been inserted.');
    }

    @isTest
    static void testInsertMultipleRecordsPartialNegative() {
        // Arrange
        // Build a list with valid leads and an invalid record (mandatory fields missing, such as LastName).
        List<Lead> leads = new LeadTestDataFactory().build(2);
        leads.add(new Lead());
        Boolean exceptionThrown = false;

        // Pre-check
        Integer leadCountBeforeInserting = [SELECT COUNT() FROM Lead];
        Assert.areEqual(0, leadCountBeforeInserting, '0 valid leads should have been inserted.');

        // Act
        try {
            Test.startTest();
            DatabaseUtility.insertMultipleRecords(leads);
            Test.stopTest();
        } catch (Exception e) {
            exceptionThrown = true;
            System.debug('Expected exception in insertRecords: ' + e.getMessage());
        }

        // Assert
        Integer leadCountAfterInserting = [SELECT COUNT() FROM Lead];
        Assert.areEqual(2, leadCountAfterInserting, '2 valid leads should have been inserted.');
        Assert.isFalse(exceptionThrown, 'An exception should not be thrown when inserting invalid records.');
    }

    @isTest
    static void testInsertMultipleRecordsError() {
        // Arrange
        // Build a list with valid leads and null record.
        List<Lead> leads = new LeadTestDataFactory().build(2);
        leads.add(null);
        Boolean exceptionThrown = false;

        // Pre-check
        Integer leadCountBeforeInserting = [SELECT COUNT() FROM Lead];
        Assert.areEqual(0, leadCountBeforeInserting, '0 valid leads should have been inserted.');

        // Act
        try {
            Test.startTest();
            DatabaseUtility.insertMultipleRecords(leads);
            Test.stopTest();
        } catch (Exception e) {
            exceptionThrown = true;
            System.debug('Expected exception in insertRecords: ' + e.getMessage());
        }

        // Assert
        Integer leadCountAfterInserting = [SELECT COUNT() FROM Lead];
        Assert.areEqual(0, leadCountAfterInserting, '0 valid leads should have been inserted.');
        Assert.isTrue(exceptionThrown, 'An exception should be thrown when inserting null records.');
    }
}