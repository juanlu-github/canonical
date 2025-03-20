/**
 * Test Data Factory class created using the Builder Pattern.
 */
public class LeadTestDataFactory {
    private Lead record;

    public LeadTestDataFactory() {
        resetRecord();
    }

    // Reset the record to ensure a fresh record for each build, i.e., to prevent carry-over values in fields between builds
    private void resetRecord() {
        record = new Lead();
        record.LastName = 'Test Data Factory - LastName';
        record.Company = 'Test Data Factory - Company';
    }
    
    public LeadTestDataFactory withLastName(String lastName) {
        record.LastName = lastName;
        return this;
    }

    public LeadTestDataFactory withCompany(String company) {
        record.Company = company;
        return this;
    }

    public LeadTestDataFactory withLeadSource(String leadSource) {
        record.LeadSource = leadSource;
        return this;
    }

    public Lead build() {
        Lead builtRecord = record.clone(false, false, false, false);
        resetRecord();  // Reset the record to ensure a fresh record for each build, i.e., to prevent carry-over values in fields between builds
        return builtRecord;
    }

    public List<Lead> build(Integer nrOfRecordsToBeCreated) {
        List<Lead> records = new List<Lead>();
        for (Integer i = 0; i < nrOfRecordsToBeCreated; i++) {
            records.add(record.clone(false, false, false, false));
        }
        resetRecord();  // Reset the record to ensure a fresh record for each build, i.e., to prevent carry-over values in fields between builds
        return records;
    }
}