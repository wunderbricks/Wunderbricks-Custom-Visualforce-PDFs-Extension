/**
 * Created by vitalygaiduchok on 15/03/2021.
 */

public inherited sharing class CustomInvoiceDTO {

    public String invoiceNumber                      {get; set;}
    public String invoiceDate                        {get; set;}
    public String paymentDueDate                     {get; set;}
    public String invoiceMessage                     {get; set;}
    public List<CustomBankAccountDTO> bankAccounts         {get; set;}
    public CustomAccountDTO fromAccount                    {get; set;}
    public CustomAccountDTO toAccount                      {get; set;}
    public List<CustomInvoiceItemDTO> invoiceItems         {get; set;}
    public String totalAmountExclVAT                 {get; set;}
    public String totalAmountInclVAT                 {get; set;}
    public String totalVAT                           {get; set;}
    public String invoiceType                        {get; set;}
    public String paidFromBankAccount                {get; set;}
    public String paidToBankAccount                  {get; set;}
    public Decimal paymentTermDays                   {get; set;}
    public String invoiceLanguage                    {get; set;}

    public CustomInvoiceDTO(Invoice__c invoice, String invoiceMessage, CustomAccountDTO fromAccount, List<CustomBankAccountDTO> bankAccounts, CustomAccountDTO toAccount, List<CustomInvoiceItemDTO> invoiceItems) {
        this.invoiceNumber          = invoice.Name;
        this.invoiceDate            = invoice.Invoice_Date__c != null ? generateFullDayOrMonthNumber(invoice.Invoice_Date__c.day()) + '/' + generateFullDayOrMonthNumber(invoice.Invoice_Date__c.month()) + '/' + invoice.Invoice_Date__c.year() : null;
        this.paymentDueDate         = invoice.Payment_Due_Date__c != null ? generateFullDayOrMonthNumber(invoice.Payment_Due_Date__c.day()) + '/' + generateFullDayOrMonthNumber(invoice.Payment_Due_Date__c.month()) + '/' + invoice.Payment_Due_Date__c.year() : null;
        this.invoiceMessage         = invoiceMessage;
        this.invoiceType            = invoice.Type__c;
        this.fromAccount            = fromAccount;
        this.bankAccounts           = bankAccounts;
        this.toAccount              = toAccount;
        this.invoiceItems           = invoiceItems;
        this.totalAmountExclVAT     = CustomUtilityService.getFormattedDecimalString(invoice.Total_excl_VAT__c);
        this.totalAmountInclVAT     = CustomUtilityService.getFormattedDecimalString(invoice.Total_incl_VAT__c);
        this.totalVAT               = CustomUtilityService.getFormattedDecimalString(invoice.Total_incl_VAT__c - invoice.Total_excl_VAT__c);
        this.paidFromBankAccount    = invoice.Paid_From_Bank_Account__r.Name;
        this.paidToBankAccount      = invoice.Paid_To_Bank_Account__r.Name;
        this.paymentTermDays        = invoice.Payment_Term_Days__c;
        this.paymentTermDays        = invoice.Payment_Term_Days__c;
        this.invoiceLanguage        = invoice.Invoice_Language__c;
    }

    private String generateFullDayOrMonthNumber(Integer dayOrMonthNumber) {
        return (dayOrMonthNumber < 10 ? '0' : '') + dayOrMonthNumber;
    }

}