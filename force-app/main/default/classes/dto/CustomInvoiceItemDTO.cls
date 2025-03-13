/**
 * Created by @PanagiotisEkatos on 31/05/2022.
 */

public inherited sharing class CustomInvoiceItemDTO {
    public String  chargeType         {get; set;}
    public String  description        {get; set;}
    public String  propertyName       {get; set;}
    public String  unitName           {get; set;}
    public String  leaseItem          {get; set;}
    public String  periodStartDateStr {get; set;}
    public String  periodEndDateStr   {get; set;}
    public String  amountInclVAT      {get; set;}
    public String  amountExclVat      {get; set;}
    public String  vatAmount          {get; set;}
    public String  vatRate            {get; set;}
    public String  unitAddress        {get; set;}

    public CustomInvoiceItemDTO() {}

    public CustomInvoiceItemDTO(String chargeType, String description, String leaseItem, Date periodStartDate, Date periodEndDate, Decimal amountInclVAT, Decimal amountExclVat, Decimal vatRate, String unitAddress) {
        this.chargeType = chargeType;
        this.description = description;
        this.leaseItem = leaseItem;
        this.periodStartDateStr = periodStartDate != null ? generateFullDayOrMonthNumber(periodStartDate.day()) + '/' + generateFullDayOrMonthNumber(periodStartDate.month()) + '/' + periodStartDate.year() : null;
        this.periodEndDateStr = periodEndDate != null ? generateFullDayOrMonthNumber(periodEndDate.day()) + '/' + generateFullDayOrMonthNumber(periodEndDate.month()) + '/' + periodEndDate.year() : null;
        this.amountInclVAT = CustomUtilityService.getFormattedDecimalString(amountInclVAT);
        this.amountExclVat = CustomUtilityService.getFormattedDecimalString(amountExclVat);
        this.vatAmount = CustomUtilityService.getFormattedDecimalString(amountInclVAT - amountExclVat);
        this.vatRate = CustomUtilityService.getFormattedDecimalString(vatRate, 1);
        this.unitAddress = unitAddress;
    }

    private String generateFullDayOrMonthNumber(Integer dayOrMonthNumber) {
        return (dayOrMonthNumber < 10 ? '0' : '') + dayOrMonthNumber;
    }

}
