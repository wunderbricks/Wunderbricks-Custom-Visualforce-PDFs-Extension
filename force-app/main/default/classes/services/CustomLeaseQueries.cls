public with sharing class CustomLeaseQueries {
    public static List<wunderbricks__Contract__c> selectWithLeaseItemsForPDF(Id leaseId) {
        return [
            SELECT
                Id,
                Name,
                wunderbricks__Account__c,
                wunderbricks__Demarcation_List__c,
                wunderbricks__Status__c,
                wunderbricks__Current_Indefinite_Period__c,
                wunderbricks__Current_Start_Date__c,
                wunderbricks__End_Date__c,
                wunderbricks__Current_Lease_Period__c,
                wunderbricks__Current_Expiry_Date__c,
                wunderbricks__Effective_Expiry_Date__c,
                wunderbricks__Invoicing_Start_Date__c,
                wunderbricks__Country__c,
                wunderbricks__Billing_Period__c,
                wunderbricks__Main_Property__c,
                wunderbricks__Property_Owner__c,
                wunderbricks__Lease_Type__c,
                wunderbricks__Administration_Fee_Tax_Code__c,
                (SELECT
                    Id,
                    wunderbricks__Component__c,
                    wunderbricks__Total_Price__c,
                    wunderbricks__Invoice_Frequency__c,
                    wunderbricks__Contract__r.wunderbricks__Indexation_Letter_Amounts_Occurrence__c,
                    wunderbricks__Unit__c,
                    wunderbricks__Unit__r.wunderbricks__Name__c
                 FROM wunderbricks__Contract_Line_Items__r
                 WHERE wunderbricks__Apply_Indexation__c = false
                     AND wunderbricks__Invoice_Frequency__c != 'Only Once'
                     AND (wunderbricks__End_Date__c = null OR wunderbricks__End_Date__c >= TODAY)),
                (SELECT
                    wunderbricks__Tenant__c,
                    wunderbricks__Tenant__r.Name
                 FROM wunderbricks__Lease_Tenants__r
                 WHERE wunderbricks__End_Date__c = null OR wunderbricks__End_Date__c >= TODAY)
            FROM wunderbricks__Contract__c
            WHERE Id = :leaseId
        ];
    }
}
