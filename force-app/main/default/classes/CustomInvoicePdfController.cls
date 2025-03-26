public inherited sharing class CustomInvoicePdfController {

    public CustomInvoiceDTO invDTO {get; set;}
    public String paymentMethodMessage {get; set;}

    final public static string INVOICE_TYPE_DEBIT = 'Debit';
    final public static string INVOICE_TYPE_CREDIT = 'Credit';
    
    final public static string Credit_Invoice_label = System.Label.get('wunderbricks', 'Credit_Invoice_label');
    final public static string Invoice_label = System.Label.get('wunderbricks', 'Invoice');

    public CustomInvoicePdfController(ApexPages.StandardController stdController) {
        invDTO = getCustomInvoiceDTO((wunderbricks__Invoice__c) stdController.getRecord());
        paymentMethodMessage = String.format(
            'We verzoeken u het bovenstaande bedrag van {5} {0} voor {1} te voldoen op bankrekening {2} t.n.v. {3} onder vermelding van het factuurnummer {4}.',
            new List<String>{
                invDTO.totalAmountInclVAT,
                invDTO.paymentDueDate,
                invDTO.bankAccounts[0].name,
                invDTO.fromAccount.name,
                invDTO.invoiceNumber,
                System.Label.get('wunderbricks', 'Euro_sign')
            }
        );

        //Set specific name of pdf file
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=' + invDTO.invoiceNumber + '.pdf');
    }
    
    private CustomInvoiceDTO getCustomInvoiceDTO(wunderbricks__Invoice__c inv) {
        wunderbricks__Invoice__c invoice = [SELECT
            Id,
            Name,
            wunderbricks__From__c,
            wunderbricks__Administration_Account__c,
            wunderbricks__To__c,
            wunderbricks__Bank_Details_Account__c,
            wunderbricks__Period_Start_Date__c,
            wunderbricks__Period_End_Date__c,
            wunderbricks__Period_Start_Date_Formula__c,
            wunderbricks__Period_End_Date_Formula__c,
            wunderbricks__Total_incl_VAT__c,
            wunderbricks__Total_excl_VAT__c,
            wunderbricks__Type__c,
            wunderbricks__Lease__c,
            wunderbricks__Lease__r.PO_Number_Billing__c,
            wunderbricks__Paid_From_Bank_Account__c,
            wunderbricks__Paid_To_Bank_Account__c,
            wunderbricks__Journal__c,
            wunderbricks__Payment_Term_Days__c,
            wunderbricks__Related_Invoice__c,
            wunderbricks__Charge_Type__c,
            wunderbricks__Invoice_Language__c,
            wunderbricks__Status__c, 
            wunderbricks__Invoice_Date__c, 
            wunderbricks__Property__c, 
            wunderbricks__Property__r.wunderbricks__Name__c, 
            wunderbricks__Property__r.Name, 
            wunderbricks__Property__r.wunderbricks__Complex__r.Name,
            wunderbricks__Property__r.wunderbricks__Address__c,
            wunderbricks__Property__r.wunderbricks__Street_Name__c,
            wunderbricks__Property__r.wunderbricks__Street_Number__c,
            wunderbricks__Property__r.wunderbricks__Zip_Postal_Code__c,
            wunderbricks__Property__r.wunderbricks__City__c,
            wunderbricks__Payment_Due_Date__c, 
            wunderbricks__Paid_From_Bank_Account__r.Name, 
            wunderbricks__Paid_To_Bank_Account__r.Name,
            wunderbricks__From__r.wunderbricks__Invoice_Template__r.wunderbricks__Invoice_Message__c, 
            wunderbricks__From__r.wunderbricks__Invoice_Template__r.wunderbricks__Email_Template_Id__c, 
            wunderbricks__From__r.wunderbricks__Invoice_Template_Credit__r.wunderbricks__Invoice_Message__c, 
            wunderbricks__From__r.wunderbricks__Invoice_Template_Credit__r.wunderbricks__Email_Template_Id__c,
            wunderbricks__From__r.Id,
            wunderbricks__From__r.Name,
            wunderbricks__From__r.wunderbricks__Email__c,
            wunderbricks__From__r.wunderbricks__Attention__c,
            wunderbricks__From__r.wunderbricks__Tax_Id__c,
            wunderbricks__From__r.wunderbricks__Debtor_Number__c,
            wunderbricks__From__r.wunderbricks__CoC_Number__c,
            wunderbricks__From__r.wunderbricks__Invoice_Email__c,
            wunderbricks__From__r.wunderbricks__Invoice_Phone__c,
            wunderbricks__From__r.wunderbricks__Invoice_Template__c,
            wunderbricks__From__r.wunderbricks__Invoice_Template_Credit__c,
            wunderbricks__From__r.BillingCity,
            wunderbricks__From__r.BillingCountry,
            wunderbricks__From__r.BillingState,
            wunderbricks__From__r.BillingStreet,
            wunderbricks__From__r.BillingPostalCode,
            wunderbricks__From__r.wunderbricks__Logo_Id__c,
            wunderbricks__From__r.wunderbricks__Next_Invoice_Number__c,
            wunderbricks__Bank_Details_Account__r.Id,
            wunderbricks__Bank_Details_Account__r.Name,
            wunderbricks__Bank_Details_Account__r.wunderbricks__Email__c,
            wunderbricks__Bank_Details_Account__r.wunderbricks__Attention__c,
            wunderbricks__Bank_Details_Account__r.wunderbricks__Tax_Id__c,
            wunderbricks__Bank_Details_Account__r.wunderbricks__Debtor_Number__c,
            wunderbricks__Bank_Details_Account__r.wunderbricks__CoC_Number__c,
            wunderbricks__Bank_Details_Account__r.wunderbricks__Invoice_Email__c,
            wunderbricks__Bank_Details_Account__r.wunderbricks__Invoice_Phone__c,
            wunderbricks__Bank_Details_Account__r.wunderbricks__Invoice_Template__c,
            wunderbricks__Bank_Details_Account__r.wunderbricks__Invoice_Template_Credit__c,
            wunderbricks__Bank_Details_Account__r.BillingCity,
            wunderbricks__Bank_Details_Account__r.BillingCountry,
            wunderbricks__Bank_Details_Account__r.BillingState,
            wunderbricks__Bank_Details_Account__r.BillingStreet,
            wunderbricks__Bank_Details_Account__r.BillingPostalCode,
            wunderbricks__Bank_Details_Account__r.wunderbricks__Logo_Id__c,
            wunderbricks__Bank_Details_Account__r.wunderbricks__Next_Invoice_Number__c,
            wunderbricks__To__r.Id,
            wunderbricks__To__r.Name,
            wunderbricks__To__r.wunderbricks__Email__c,
            wunderbricks__To__r.wunderbricks__Attention__c,
            wunderbricks__To__r.wunderbricks__Tax_Id__c,
            wunderbricks__To__r.wunderbricks__Debtor_Number__c,
            wunderbricks__To__r.wunderbricks__CoC_Number__c,
            wunderbricks__To__r.wunderbricks__Invoice_Email__c,
            wunderbricks__To__r.wunderbricks__Invoice_Phone__c,
            wunderbricks__To__r.wunderbricks__Invoice_Template__c,
            wunderbricks__To__r.wunderbricks__Invoice_Template_Credit__c,
            wunderbricks__To__r.BillingCity,
            wunderbricks__To__r.BillingCountry,
            wunderbricks__To__r.BillingState,
            wunderbricks__To__r.BillingStreet,
            wunderbricks__To__r.BillingPostalCode,
            wunderbricks__To__r.wunderbricks__Logo_Id__c,
            wunderbricks__To__r.wunderbricks__Next_Invoice_Number__c,
            (
                    SELECT
                            wunderbricks__Amount_excl_VAT__c,
                            wunderbricks__Charge_Type__c,
                            wunderbricks__Description__c,
                            wunderbricks__Lease_Item__r.wunderbricks__Unit__r.Name,
                            wunderbricks__Lease_Item__r.wunderbricks__Unit__r.wunderbricks__Address__c,
                            wunderbricks__Lease_Item__r.wunderbricks__Unit__r.wunderbricks__Name__c,
                            wunderbricks__Lease_Item__c,
                            wunderbricks__Period_End_Date__c,
                            wunderbricks__Period_Start_Date__c,
                            wunderbricks__Total_incl_VAT__c,
                            wunderbricks__VAT_Rate_Percentage__c,
                            wunderbricks__VAT_Code__c
                    FROM
                            wunderbricks__Invoice_Items__r
                	ORDER BY wunderbricks__Charge_Type__c ASC
            )
            FROM wunderbricks__Invoice__c
            WHERE Id = :inv.Id
            LIMIT 1
        ];

        Account fromAccount = (Account) invoice.getSObject('wunderbricks__From__r');
        Account bankDetailsAccount = (Account) invoice.getSObject('wunderbricks__Bank_Details_Account__r');
        Account toAccount = (Account) invoice.getSObject('wunderbricks__To__r');
        CustomAccountDTO fromCustomAccountDTO = new CustomAccountDTO(fromAccount);

        List<CustomBankAccountDTO> bankAccounts = new List<CustomBankAccountDTO>();
        if (invoice.wunderbricks__Type__c == INVOICE_TYPE_DEBIT) {
            // If there's no charge type set on the invoice then display all the bank accounts on the account
            if (String.isBlank(invoice.wunderbricks__Charge_Type__c)) {
                for (wunderbricks__Bank_Account__c bankAccount : [SELECT Id, Name, wunderbricks__Account__c, wunderbricks__Account_Holder_Name__c, wunderbricks__Bank__c, wunderbricks__BIC__c, wunderbricks__Description__c FROM wunderbricks__Bank_Account__c WHERE wunderbricks__Account__c = :bankDetailsAccount.Id]) {
                    bankAccounts.add(new CustomBankAccountDTO(
                        bankAccount.Name,
                        bankAccount.wunderbricks__Account_Holder_Name__c,
                        bankAccount.wunderbricks__Bank__c,
                        bankAccount.wunderbricks__BIC__c,
                        bankAccount.wunderbricks__Description__c
                    ));
                }
            // If there's a charge type on the invoice then only display bank accounts that are under the invoice set with the exact same charge type 
            } else {
                for (wunderbricks__Invoice_Set_Bank_Account__c bankAccountJunction : [SELECT Id, Name, wunderbricks__Bank_Account__c, wunderbricks__Invoice_Set__c, wunderbricks__Bank_Account__r.Name, wunderbricks__Bank_Account__r.wunderbricks__Account_Holder_Name__c, wunderbricks__Bank_Account__r.wunderbricks__Bank__c, wunderbricks__Bank_Account__r.wunderbricks__BIC__c, wunderbricks__Bank_Account__r.wunderbricks__Description__c FROM wunderbricks__Invoice_Set_Bank_Account__c WHERE wunderbricks__Invoice_Set__r.wunderbricks__Account__c = :bankDetailsAccount.Id AND wunderbricks__Bank_Account__r.wunderbricks__Account__c = :bankDetailsAccount.Id AND wunderbricks__Invoice_Set__r.wunderbricks__Charge_Type__c = :invoice.wunderbricks__Charge_Type__c]) {
                    bankAccounts.add(new CustomBankAccountDTO(
                        bankAccountJunction.wunderbricks__Bank_Account__r.Name,
                        bankAccountJunction.wunderbricks__Bank_Account__r.wunderbricks__Account_Holder_Name__c,
                        bankAccountJunction.wunderbricks__Bank_Account__r.wunderbricks__Bank__c,
                        bankAccountJunction.wunderbricks__Bank_Account__r.wunderbricks__BIC__c,
                        bankAccountJunction.wunderbricks__Bank_Account__r.wunderbricks__Description__c
                    ));
                }
            }
        }

        CustomAccountDTO tenant = new CustomAccountDTO(toAccount);

        Map<String, String> chargeTypeLabelsByValue = CustomUtilityService.getPicklistLabelByValue(wunderbricks__Invoice_Item__c.SObjectType.getDescribe().getName(), wunderbricks__Invoice_Item__c.wunderbricks__Charge_Type__c.getDescribe().getName());

        List<CustomInvoiceItemDTO> invoiceItems = new List<CustomInvoiceItemDTO>();
        for (wunderbricks__Invoice_Item__c invoiceItem: invoice.wunderbricks__Invoice_Items__r) {
            invoiceItems.add(new CustomInvoiceItemDTOBuilder()
                .setDescription(invoiceItem.wunderbricks__Description__c)
                .setChargeType(chargeTypeLabelsByValue.get(invoiceItem.wunderbricks__Charge_Type__c))
                .setLeaseItem(invoiceItem.wunderbricks__Lease_Item__c)
                .setPeriodStartDateStr(invoiceItem.wunderbricks__Period_Start_Date__c)
                .setPeriodEndDateStr(invoiceItem.wunderbricks__Period_End_Date__c)
                .setAmountInclVAT(invoiceItem.wunderbricks__Total_incl_VAT__c)
                .setAmountExclVat(invoiceItem.wunderbricks__Amount_excl_VAT__c)
                .setVatRate(invoiceItem.wunderbricks__VAT_Rate_Percentage__c)
                .setUnitAddress(invoiceItem.wunderbricks__Lease_Item__r.wunderbricks__Unit__r.wunderbricks__Address__c)
                .setPropertyName(invoice.wunderbricks__Property__r.wunderbricks__Name__c != null ? invoice.wunderbricks__Property__r.wunderbricks__Name__c : invoice.wunderbricks__Property__r.Name)
                .setUnitName(invoiceItem.wunderbricks__Lease_Item__r.wunderbricks__Unit__r.wunderbricks__Name__c != null ? invoiceItem.wunderbricks__Lease_Item__r.wunderbricks__Unit__r.wunderbricks__Name__c : invoiceItem.wunderbricks__Lease_Item__r.wunderbricks__Unit__r.Name)
                .setVatAmount()
                .build()
            );
        }

        Id invoiceTemplateId = invoice.wunderbricks__Type__c == INVOICE_TYPE_CREDIT ? fromAccount.wunderbricks__Invoice_Template_Credit__c : fromAccount.wunderbricks__Invoice_Template__c; 
        wunderbricks__Invoice_Template__c invoiceTemplate = [SELECT
                    Id,
                    Name,
                    wunderbricks__Email_Subject__c,
                    wunderbricks__Email_Body__c,
                    wunderbricks__Is_Default__c,
                    wunderbricks__Invoice_Number_Pattern__c,
                    wunderbricks__Email_Template_Id__c,
                    wunderbricks__Type__c,
                    (
                            SELECT wunderbricks__Invoice_Template_Item__c.wunderbricks__Invoice_Message__c
                            FROM wunderbricks__Invoice_Template_Items__r
                            WHERE wunderbricks__Invoice_Language__c = :invoice.wunderbricks__Invoice_Language__c
                            ORDER BY LastModifiedDate DESC
                    )
            FROM wunderbricks__Invoice_Template__c
            WHERE Id = :invoiceTemplateId
            ORDER BY LastModifiedDate DESC
        ];
        String invoiceMessage;
        if (!invoiceTemplate.wunderbricks__Invoice_Template_Items__r.isEmpty()) {
            invoiceMessage = invoiceTemplate.wunderbricks__Invoice_Template_Items__r[0].wunderbricks__Invoice_Message__c;
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