public with sharing class CustomLeaseItemIndexationDTO {
    public String chargeType { get; set; }
    public String unitName { get; set; }
    public String currentAmount { get; set; }
    public String currentAmountNoTax { get; set; }
    public String adjustmentRate { get; set; }
    public String adjustment { get; set; }
    public String newAmount { get; set; }
    public String newAmountNoTax { get; set; }

    public Decimal currentAmountDec { get; set; }
    public Decimal currentAmountNoTaxDec { get; set; }
    public Decimal adjustmentDec { get; set; }
    public Decimal newAmountDec { get; set; }
    public Decimal newAmountNoTaxDec { get; set; }

    public CustomLeaseItemIndexationDTO(wunderbricks__Lease_Item_Indexation__c leaseItemIndexation, Map<String, String> chargeTypeLabelsByValue) {
        wunderbricks__Contract_Line_Item__c leaseItem = leaseItemIndexation.wunderbricks__Lease_Item__r;
        Decimal freqMultiplier = leaseItemIndexation.wunderbricks__Indexation_Letter_Amount_Multiplier__c;

        this.currentAmountDec = leaseItemIndexation.wunderbricks__Old_Price_Incl_Tax__c * freqMultiplier;
        this.currentAmountNoTaxDec = leaseItemIndexation.wunderbricks__Old_Price__c * freqMultiplier;
        this.adjustmentDec = leaseItemIndexation.wunderbricks__Adjustment__c * freqMultiplier;
        this.newAmountDec = leaseItemIndexation.wunderbricks__Proposed_Price_Incl_Tax__c * freqMultiplier;
        this.newAmountNoTaxDec = leaseItemIndexation.wunderbricks__Proposed_Price__c * freqMultiplier;

        this.chargeType = chargeTypeLabelsByValue.get(leaseItem.wunderbricks__Component__c);
        this.unitName = leaseItem.wunderbricks__Unit__r.wunderbricks__Name__c;
        this.currentAmount = CustomPdfUtils.getFormattedDecimalString(this.currentAmountDec);
        this.currentAmountNoTax = CustomPdfUtils.getFormattedDecimalString(this.currentAmountNoTaxDec);
        this.adjustmentRate = CustomPdfUtils.getFormattedDecimalString(leaseItemIndexation.wunderbricks__Proposed_Rate__c);
        this.adjustment = CustomPdfUtils.getFormattedDecimalString(this.adjustmentDec);
        this.newAmount = CustomPdfUtils.getFormattedDecimalString(this.newAmountDec);
        this.newAmountNoTax = CustomPdfUtils.getFormattedDecimalString(this.newAmountNoTaxDec);
    }
}
