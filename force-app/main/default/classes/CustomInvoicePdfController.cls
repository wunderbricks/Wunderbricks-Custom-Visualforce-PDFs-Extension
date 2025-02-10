public inherited sharing class CustomInvoicePdfController {

    public CustomInvoiceDTO invDTO {get; set;}
    public String paymentMethodMessage {get; set;}

    final public static string INVOICE_TYPE_DEBIT = 'Debit';
    final public static string INVOICE_TYPE_CREDIT = 'Credit';
    
    public CustomInvoicePdfController(ApexPages.StandardController stdController) {
        invDTO = getCustomInvoiceDTO((Invoice__c) stdController.getRecord());
        paymentMethodMessage = String.format(
            System.Label.Invoice_PDF_Payment_Method_Message,
            new List<String>{
                invDTO.totalAmountInclVAT,
                invDTO.paymentDueDate,
                invDTO.invoiceNumber
            }
        );

        //Set specific name of pdf file
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=' + invDTO.invoiceNumber + '.pdf');
    }

    private CustomInvoiceDTO getCustomInvoiceDTO(Invoice__c inv) {
        Invoice__c invoice = [SELECT
            Status__c, 
            Invoice_Date__c, 
            Property__c, 
            Property__r.Name__c, 
            Property__r.Name, 
            Payment_Due_Date__c, 
            Paid_From_Bank_Account__r.Name, 
            Paid_To_Bank_Account__r.Name, 
            From__r.Invoice_Template__r.Invoice_Message__c, 
            From__r.Invoice_Template__r.Email_Template_Id__c, 
            From__r.Invoice_Template_Credit__r.Invoice_Message__c, 
            From__r.Invoice_Template_Credit__r.Email_Template_Id__c,
            From__r.Id,
            From__r.Name,
            From__r.Email__c,
            From__r.Attention__c,
            From__r.Tax_Id__c,
            From__r.Debtor_Number__c,
            From__r.CoC_Number__c,
            From__r.Invoice_Email__c,
            From__r.Invoice_Phone__c,
            From__r.Invoice_Template__c,
            From__r.Invoice_Template_Credit__c,
            From__r.BillingCity,
            From__r.BillingCountry,
            From__r.BillingState,
            From__r.BillingStreet,
            From__r.BillingPostalCode,
            From__r.Logo_Id__c,
            From__r.Next_Invoice_Number__c,
            Bank_Details_Account__r.Id,
            Bank_Details_Account__r.Name,
            Bank_Details_Account__r.Email__c,
            Bank_Details_Account__r.Attention__c,
            Bank_Details_Account__r.Tax_Id__c,
            Bank_Details_Account__r.Debtor_Number__c,
            Bank_Details_Account__r.CoC_Number__c,
            Bank_Details_Account__r.Invoice_Email__c,
            Bank_Details_Account__r.Invoice_Phone__c,
            Bank_Details_Account__r.Invoice_Template__c,
            Bank_Details_Account__r.Invoice_Template_Credit__c,
            Bank_Details_Account__r.BillingCity,
            Bank_Details_Account__r.BillingCountry,
            Bank_Details_Account__r.BillingState,
            Bank_Details_Account__r.BillingStreet,
            Bank_Details_Account__r.BillingPostalCode,
            Bank_Details_Account__r.Logo_Id__c,
            Bank_Details_Account__r.Next_Invoice_Number__c,
            To__r.Id,
            To__r.Name,
            To__r.Email__c,
            To__r.Attention__c,
            To__r.Tax_Id__c,
            To__r.Debtor_Number__c,
            To__r.CoC_Number__c,
            To__r.Invoice_Email__c,
            To__r.Invoice_Phone__c,
            To__r.Invoice_Template__c,
            To__r.Invoice_Template_Credit__c,
            To__r.BillingCity,
            To__r.BillingCountry,
            To__r.BillingState,
            To__r.BillingStreet,
            To__r.BillingPostalCode,
            To__r.Logo_Id__c,
            To__r.Next_Invoice_Number__c,
            (
                    SELECT
                            Amount_excl_VAT__c,
                            Charge_Type__c,
                            Description__c,
                            Lease_Item__r.Unit__r.Address__c,
                            Lease_Item__r.Unit__r.Name__c,
                            Lease_Item__r.Unit__r.Name,
                            Lease_Item__c,
                            Period_End_Date__c,
                            Period_Start_Date__c,
                            Total_incl_VAT__c,
                            VAT_Rate_Percentage__c,
                            VAT_Code__c
                    FROM
                            wunderbricks__Invoice_Items__r
            )
            FROM wunderbricks__Invoice__c
            WHERE Id = :inv.Id
            LIMIT 1
        ];

        Account fromAccount = (Account) invoice.getSObject('From__r');
        Account bankDetailsAccount = (Account) invoice.getSObject('Bank_Details_Account__r');
        Account toAccount = (Account) invoice.getSObject('To__r');
        CustomAccountDTO fromCustomAccountDTO = new CustomAccountDTO(fromAccount);

        List<CustomBankAccountDTO> bankAccounts = new List<CustomBankAccountDTO>();
        if (invoice.Type__c == INVOICE_TYPE_DEBIT) {
            // If there's no charge type set on the invoice then display all the bank accounts on the account
            if (String.isBlank(invoice.Charge_Type__c)) {
                for (Bank_Account__c bankAccount : [SELECT Id, Name, Account__c, Account_Holder_Name__c, Bank__c, BIC__c, Description__c FROM wunderbricks__Bank_Account__c WHERE Account__c = :bankDetailsAccount.Id]) {
                    bankAccounts.add(new CustomBankAccountDTO(
                        bankAccount.Name,
                        bankAccount.Account_Holder_Name__c,
                        bankAccount.Bank__c,
                        bankAccount.BIC__c,
                        bankAccount.Description__c
                    ));
                }
            // If there's a charge type on the invoice then only display bank accounts that are under the invoice set with the exact same charge type 
            } else {
                for (Invoice_Set_Bank_Account__c bankAccountJunction : [SELECT Id, Name, Bank_Account__c, Invoice_Set__c, Bank_Account__r.Name, Bank_Account__r.Account_Holder_Name__c, Bank_Account__r.Bank__c, Bank_Account__r.BIC__c, Bank_Account__r.Description__c FROM wunderbricks__Invoice_Set_Bank_Account__c WHERE Invoice_Set__r.Account__c = :bankDetailsAccount.Id AND Bank_Account__r.Account__c = :bankDetailsAccount.Id AND Invoice_Set__r.Charge_Type__c = :invoice.Charge_Type__c]) {
                    bankAccounts.add(new CustomBankAccountDTO(
                        bankAccountJunction.Bank_Account__r.Name,
                        bankAccountJunction.Bank_Account__r.Account_Holder_Name__c,
                        bankAccountJunction.Bank_Account__r.Bank__c,
                        bankAccountJunction.Bank_Account__r.BIC__c,
                        bankAccountJunction.Bank_Account__r.Description__c
                    ));
                }
            }
        }

        CustomAccountDTO tenant = new CustomAccountDTO(toAccount);

        Map<String, String> chargeTypeLabelsByValue = CustomUtilityService.getPicklistLabelByValue(Invoice_Item__c.SObjectType.getDescribe().getName(), Invoice_Item__c.Charge_Type__c.getDescribe().getName());

        List<CustomInvoiceItemDTO> invoiceItems = new List<CustomInvoiceItemDTO>();
        for (Invoice_Item__c invoiceItem: invoice.Invoice_Items__r) {
            invoiceItems.add(new CustomInvoiceItemDTOBuilder()
                .setDescription(invoiceItem.Description__c)
                .setChargeType(chargeTypeLabelsByValue.get(invoiceItem.Charge_Type__c))
                .setLeaseItem(invoiceItem.Lease_Item__c)
                .setPeriodStartDateStr(invoiceItem.Period_Start_Date__c)
                .setPeriodEndDateStr(invoiceItem.Period_End_Date__c)
                .setAmountInclVAT(invoiceItem.Total_incl_VAT__c)
                .setAmountExclVat(invoiceItem.Amount_excl_VAT__c)
                .setVatRate(invoiceItem.VAT_Rate_Percentage__c)
                .setUnitAddress(invoiceItem.Lease_Item__r.Unit__r.Address__c)
                .setPropertyName(invoice.Property__r.Name__c != null ? invoice.Property__r.Name__c : invoice.Property__r.Name)
                .setUnitName(invoiceItem.Lease_Item__r.Unit__r.Name__c != null ? invoiceItem.Lease_Item__r.Unit__r.Name__c : invoiceItem.Lease_Item__r.Unit__r.Name)
                .setVatAmount()
                .build()
            );
        }

        Id invoiceTemplateId = invoice.Type__c == INVOICE_TYPE_CREDIT ? fromAccount.Invoice_Template_Credit__c : fromAccount.Invoice_Template__c; 
        Invoice_Template__c invoiceTemplate = [SELECT
                    Id,
                    Name,
                    wunderbricks__Email_Subject__c,
                    wunderbricks__Email_Body__c,
                    wunderbricks__Is_Default__c,
                    wunderbricks__Invoice_Number_Pattern__c,
                    wunderbricks__Email_Template_Id__c,
                    wunderbricks__Type__c,
                    (
                            SELECT Invoice_Template_Item__c.Invoice_Message__c
                            FROM wunderbricks__Invoice_Template_Items__r
                            WHERE wunderbricks__Invoice_Language__c = :invoice.Invoice_Language__c
                            ORDER BY LastModifiedDate DESC
                    )
            FROM wunderbricks__Invoice_Template__c
            WHERE Id = :invoiceTemplateId
            ORDER BY LastModifiedDate DESC
        ];
        String invoiceMessage;
        if (!invoiceTemplate.Invoice_Template_Items__r.isEmpty()) {
            invoiceMessage = invoiceTemplate.Invoice_Template_Items__r[0].Invoice_Message__c;
        }

        return new CustomInvoiceDTO(
            invoice,
            invoiceMessage,
            fromCustomAccountDTO,
            bankAccounts,
            tenant,
            invoiceItems
        );
    }
    
    
}
