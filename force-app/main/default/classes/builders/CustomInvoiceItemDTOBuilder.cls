/**
 * Created by @VitalyGaiduchok on 10/08/2023.
 */
public class CustomInvoiceItemDTOBuilder {
    private CustomInvoiceItemDTO invoiceItem;
    
    Decimal amountInclVAT;
    Decimal amountExclVat;

    public CustomInvoiceItemDTOBuilder() {
        invoiceItem = new CustomInvoiceItemDTO();
    }

    public CustomInvoiceItemDTOBuilder setChargeType(String chargeType) {
        this.invoiceItem.chargeType = chargeType;
        return this;
    }
    
    public CustomInvoiceItemDTOBuilder setDescription(String description) {
        this.invoiceItem.description = description;
        return this;
    }
    
    public CustomInvoiceItemDTOBuilder setPropertyName(String propertyName) {
        this.invoiceItem.propertyName = propertyName;
        return this;
    }
    
    public CustomInvoiceItemDTOBuilder setUnitName(String unitName) {
        this.invoiceItem.unitName = unitName;
        return this;
    }
    
    public CustomInvoiceItemDTOBuilder setLeaseItem(String leaseItem) {
        this.invoiceItem.leaseItem = leaseItem;
        return this;
    }
    
    public CustomInvoiceItemDTOBuilder setPeriodStartDateStr(Date periodStartDate) {
        this.invoiceItem.periodStartDateStr = periodStartDate != null ? generateFullDayOrMonthNumber(periodStartDate.day()) + '/' + generateFullDayOrMonthNumber(periodStartDate.month()) + '/' + periodStartDate.year() : null;
        return this;
    }
    
    public CustomInvoiceItemDTOBuilder setPeriodEndDateStr(Date periodEndDate) {
        this.invoiceItem.periodEndDateStr = periodEndDate != null ? generateFullDayOrMonthNumber(periodEndDate.day()) + '/' + generateFullDayOrMonthNumber(periodEndDate.month()) + '/' + periodEndDate.year() : null;
        return this;
    }
    
    public CustomInvoiceItemDTOBuilder setAmountInclVAT(Decimal amountInclVAT) {
        this.amountInclVAT = amountInclVAT;
        this.invoiceItem.amountInclVAT = CustomUtilityService.getFormattedDecimalString(amountInclVAT);
        return this;
    }
    
    public CustomInvoiceItemDTOBuilder setAmountExclVat(Decimal amountExclVat) {
        this.amountExclVat = amountExclVat;
        this.invoiceItem.amountExclVat = CustomUtilityService.getFormattedDecimalString(amountExclVat);
        return this;
    }
    
    //setAmountExclVat and setAmountInclVAT methods should be called before calling it. In other case it won't change vatAmount property.
    public CustomInvoiceItemDTOBuilder setVatAmount() {
        if (this.amountInclVAT != null && this.amountExclVat != null) {
            this.invoiceItem.vatAmount = CustomUtilityService.getFormattedDecimalString(this.amountInclVAT - this.amountExclVat);
        }
        return this;
    }
    
    public CustomInvoiceItemDTOBuilder setVatRate(Decimal vatRate) {
        this.invoiceItem.vatRate = CustomUtilityService.getFormattedDecimalString(vatRate, 1);
        return this;
    }
    
    public CustomInvoiceItemDTOBuilder setUnitAddress(String unitAddress) {
        this.invoiceItem.unitAddress = unitAddress;
        return this;
    }
    
    public CustomInvoiceItemDTO build() {
        return this.invoiceItem;
    }

    private String generateFullDayOrMonthNumber(Integer dayOrMonthNumber) {
        return (dayOrMonthNumber < 10 ? '0' : '') + dayOrMonthNumber;
    }
}