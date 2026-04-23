public with sharing class CustomLeaseIndexationDTO {
    public CustomAccountDTO leaseAdmin { get; set; }
    public CustomAccountDTO leaseBilling { get; set; }
    public CustomAccountDTO billTo { get; set; }
    public String leaseNumber { get; set; }
    public String leaseStartDate { get; set; }
    public String leaseBillToName { get; set; }
    public String leaseBillToAttention { get; set; }
    public String leaseAddress { get; set; }
    public String leaseType { get; set; }
    public String leaseHousingSector { get; set; }
    public String leasePropOwnerName { get; set; }
    public String leaseOccurrence { get; set; }
    public String indexationRunDate { get; set; }
    public String indexName { get; set; }
    public String indexPeriod { get; set; }
    public String indexOldValue { get; set; }
    public String indexNewValue { get; set; }
    public String calculatedRate { get; set; }
    public String totalCurrentAmountExclTax { get; set; }
    public String totalAdjustment { get; set; }
    public String totalNewAmountExclTax { get; set; }
    public String applyingFrom { get; set; }
    public String totalNewAmountInclTax { get; set; }
    public String totalCurrentAmountInclTax { get; set; }
    public String totalNewTaxAmount { get; set; }

    public List<CustomAccountDTO> tenants { get; set; }
    public List<CustomLeaseItemIndexationDTO> leaseItemIndexations { get; set; }

    public CustomLeaseIndexationDTO(wunderbricks__Lease_Indexation__c leaseIndexation, wunderbricks__Contract__c lease, String documentLanguage) {
        Map<String, String> chargeTypeLabelsByValue = CustomPdfUtils.getPicklistLabelByValue(
            wunderbricks__Contract_Line_Item__c.SObjectType.getDescribe().getName(),
            wunderbricks__Contract_Line_Item__c.wunderbricks__Component__c.getDescribe().getName()
        );

        this.leaseAdmin = new CustomAccountDTO(leaseIndexation.wunderbricks__Lease__r.wunderbricks__Administration_Account__r);
        this.leaseBilling = new CustomAccountDTO(leaseIndexation.wunderbricks__Lease__r.wunderbricks__Billing_Account__r);
        this.billTo = new CustomAccountDTO(leaseIndexation.wunderbricks__Lease__r.wunderbricks__Account__r);
        this.leaseNumber = leaseIndexation.wunderbricks__Lease__r.Name;
        this.leaseStartDate = generateStringDate(leaseIndexation.wunderbricks__Lease__r.wunderbricks__Current_Start_Date__c);
        this.leaseBillToName = leaseIndexation.wunderbricks__Lease__r.wunderbricks__Account__r.Name;
        this.leaseBillToAttention = leaseIndexation.wunderbricks__Lease__r.wunderbricks__Account__r.wunderbricks__Attention__c;
        this.leaseAddress = CustomPropertyUtils.getPropertyAddress(leaseIndexation.wunderbricks__Lease__r.wunderbricks__Main_Property__r);
        this.leaseType = leaseIndexation.wunderbricks__Lease__r.wunderbricks__Type__c;
        this.leaseHousingSector = leaseIndexation.wunderbricks__Lease__r.wunderbricks__Housing_Sector__c;
        this.leasePropOwnerName = leaseIndexation.wunderbricks__Lease__r.wunderbricks__Property_Owner__r.Name;
        this.leaseOccurrence = leaseIndexation.wunderbricks__Indexation_Letter_Amounts_Occurrence__c;
        this.indexationRunDate = generateStringDate(leaseIndexation.wunderbricks__Indexation_Run__r.wunderbricks__Indexation_Date__c);
        this.indexName = leaseIndexation.wunderbricks__Lease__r.wunderbricks__Indexation_Method__r.wunderbricks__Index__r.Name;
        this.indexPeriod = translatePeriod(leaseIndexation.wunderbricks__Index_Periods__c, documentLanguage);
        this.indexOldValue = CustomPdfUtils.getFormattedDecimalString(leaseIndexation.wunderbricks__Old_Index_Value__c);
        this.indexNewValue = CustomPdfUtils.getFormattedDecimalString(leaseIndexation.wunderbricks__New_Index_Value__c);
        this.calculatedRate = CustomPdfUtils.getFormattedDecimalString(leaseIndexation.wunderbricks__Index_Rate__c);
        this.applyingFrom = generateStringDate(leaseIndexation.wunderbricks__Applying_From__c);

        this.leaseItemIndexations = new List<CustomLeaseItemIndexationDTO>();
        for (wunderbricks__Lease_Item_Indexation__c item : leaseIndexation.wunderbricks__Lease_Item_Indexations__r) {
            this.leaseItemIndexations.add(new CustomLeaseItemIndexationDTO(item, chargeTypeLabelsByValue));
        }

        Decimal ltotalCurrentAmountExclTax = 0;
        Decimal ltotalCurrentAmountInclTax = 0;
        Decimal ltotalNewAmountExclTax = 0;
        Decimal ltotalNewAmountInclTax = 0;
        Decimal ltotalAdjustment = 0;
        for (CustomLeaseItemIndexationDTO lii : this.leaseItemIndexations) {
            ltotalCurrentAmountInclTax += lii.currentAmountDec;
            ltotalCurrentAmountExclTax += lii.currentAmountNoTaxDec;
            ltotalNewAmountInclTax += lii.newAmountDec;
            ltotalNewAmountExclTax += lii.newAmountNoTaxDec;
            ltotalAdjustment += lii.adjustmentDec;
        }
        this.totalCurrentAmountExclTax = CustomPdfUtils.getFormattedDecimalString(ltotalCurrentAmountExclTax);
        this.totalCurrentAmountInclTax = CustomPdfUtils.getFormattedDecimalString(ltotalCurrentAmountInclTax);
        this.totalNewAmountExclTax = CustomPdfUtils.getFormattedDecimalString(ltotalNewAmountExclTax);
        this.totalNewAmountInclTax = CustomPdfUtils.getFormattedDecimalString(ltotalNewAmountInclTax);
        this.totalNewTaxAmount = CustomPdfUtils.getFormattedDecimalString(ltotalNewAmountInclTax - ltotalNewAmountExclTax);
        this.totalAdjustment = CustomPdfUtils.getFormattedDecimalString(ltotalAdjustment);

        this.tenants = new List<CustomAccountDTO>();
        for (wunderbricks__Lease_Tenant__c tenant : lease.wunderbricks__Lease_Tenants__r) {
            this.tenants.add(new CustomAccountDTO(tenant.wunderbricks__Tenant__c, tenant.wunderbricks__Tenant__r.Name));
        }
    }

    private String generateStringDate(Date periodStartDate) {
        return generateFullDayOrMonthNumber(periodStartDate.day()) +
            '/' +
            generateFullDayOrMonthNumber(periodStartDate.month()) +
            '/' +
            periodStartDate.year();
    }

    private String generateFullDayOrMonthNumber(Integer dayOrMonthNumber) {
        if (dayOrMonthNumber == null) {
            return null;
        }
        return (dayOrMonthNumber < 10 ? '0' : '') + dayOrMonthNumber;
    }

    private String getTranslatedMonth(String englishMonth, String documentLanguage) {
        String labelName = englishMonth.substring(0, 1).toUpperCase() + englishMonth.substring(1).toLowerCase();
        try {
            String labelValue = Label.get('wunderbricks', labelName);
            return String.isBlank(labelValue) ? englishMonth : labelValue;
        } catch (Exception e) {
            return englishMonth;
        }
    }

    private String translatePeriod(String period, String documentLanguage) {
        if (String.isBlank(period))
            return '';
        List<String> parts = period.split('-');
        List<String> translatedParts = new List<String>();
        for (String part : parts) {
            part = part.trim();
            List<String> monthYear = part.split(' ');
            if (monthYear.size() == 2) {
                String translatedMonth = getTranslatedMonth(monthYear[0], documentLanguage);
                translatedParts.add(translatedMonth + ' ' + monthYear[1]);
            } else {
                translatedParts.add(part);
            }
        }
        return String.join(translatedParts, ' - ');
    }
}
