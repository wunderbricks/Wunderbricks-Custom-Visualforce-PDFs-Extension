/**
 * Created by vitalygaiduchok on 15/03/2021.
 */

public inherited sharing class CustomInvoiceDTO {

    public String invoiceNumber                      {get; set;}
    public String invoiceDate                        {get; set;}
    public String paymentDueDate                     {get; set;}
    public String invoiceMessage                     {get; set;}
    public List<CustomBankAccountDTO> bankAccounts   {get; set;}
    public CustomAccountDTO fromAccount              {get; set;}
    public CustomAccountDTO toAccount                {get; set;}
    public List<CustomInvoiceItemDTO> invoiceItems   {get; set;}
    public String totalAmountExclVAT                 {get; set;}
    public String totalAmountInclVAT                 {get; set;}
    public String totalVAT                           {get; set;}
    public String invoiceType                        {get; set;}
    public String paidFromBankAccount                {get; set;}
    public String paidToBankAccount                  {get; set;}
    public Decimal paymentTermDays                   {get; set;}
    public String invoiceLanguage                    {get; set;}
    public String complexName                        {get; set;}
    public String leasePONumber                      {get; set;}
    public String invoiceStartDate                   {get; set;}
    public String invoiceEndDate                     {get; set;}

    public CustomInvoiceDTO(wunderbricks__Invoice__c invoice, String invoiceMessage, CustomAccountDTO fromAccount, List<CustomBankAccountDTO> bankAccounts, CustomAccountDTO toAccount, List<CustomInvoiceItemDTO> invoiceItems) {
        this.invoiceNumber          = invoice.Name;
        this.invoiceDate            = invoice.wunderbricks__Invoice_Date__c != null ? generateFullDayOrMonthNumber(invoice.wunderbricks__Invoice_Date__c.day()) + '/' + generateFullDayOrMonthNumber(invoice.wunderbricks__Invoice_Date__c.month()) + '/' + invoice.wunderbricks__Invoice_Date__c.year() : null;
        this.paymentDueDate         = invoice.wunderbricks__Payment_Due_Date__c != null ? generateFullDayOrMonthNumber(invoice.wunderbricks__Payment_Due_Date__c.day()) + '/' + generateFullDayOrMonthNumber(invoice.wunderbricks__Payment_Due_Date__c.month()) + '/' + invoice.wunderbricks__Payment_Due_Date__c.year() : null;
        this.invoiceMessage         = invoiceMessage;
        this.invoiceType            = invoice.wunderbricks__Type__c;
        this.fromAccount            = fromAccount;
        this.bankAccounts           = bankAccounts;
        this.toAccount              = toAccount;
        this.invoiceItems           = invoiceItems;
        this.totalAmountExclVAT     = CustomUtilityService.getFormattedDecimalString(invoice.wunderbricks__Total_excl_VAT__c);
        this.totalAmountInclVAT     = CustomUtilityService.getFormattedDecimalString(invoice.wunderbricks__Total_incl_VAT__c);
        this.totalVAT               = CustomUtilityService.getFormattedDecimalString(invoice.wunderbricks__Total_incl_VAT__c - invoice.wunderbricks__Total_excl_VAT__c);
        this.paidFromBankAccount    = invoice.wunderbricks__Paid_From_Bank_Account__r.Name;
        this.paidToBankAccount      = invoice.wunderbricks__Paid_To_Bank_Account__r.Name;
        this.paymentTermDays        = invoice.wunderbricks__Payment_Term_Days__c;
        this.paymentTermDays        = invoice.wunderbricks__Payment_Term_Days__c;
        this.invoiceLanguage        = invoice.wunderbricks__Invoice_Language__c;
        this.complexName            = invoice.wunderbricks__Property__r.wunderbricks__Complex__r.Name;
        this.leasePONumber          = invoice.wunderbricks__Lease__r.PO_Number_Billing__c;
        this.invoiceStartDate       = invoice.wunderbricks__Period_Start_Date_Formula__c != null ? generateFullDayOrMonthNumber(invoice.wunderbricks__Period_Start_Date_Formula__c.day()) + '/' + generateFullDayOrMonthNumber(invoice.wunderbricks__Period_Start_Date_Formula__c.month()) + '/' + invoice.wunderbricks__Period_Start_Date_Formula__c.year() : null;
        this.invoiceEndDate         = invoice.wunderbricks__Period_End_Date_Formula__c != null ? generateFullDayOrMonthNumber(invoice.wunderbricks__Period_End_Date_Formula__c.day()) + '/' + generateFullDayOrMonthNumber(invoice.wunderbricks__Period_End_Date_Formula__c.month()) + '/' + invoice.wunderbricks__Period_End_Date_Formula__c.year() : null;
    }

    private String generateFullDayOrMonthNumber(Integer dayOrMonthNumber) {
        return (dayOrMonthNumber < 10 ? '0' : '') + dayOrMonthNumber;
    }

}