@IsTest
private class CustomInvoicePdfControllerTest {
    @TestSetup
    static void createData() { 
       TestUsers.setupTestUsers();
       
       User wbErpUser = [SELECT Id FROM User WHERE Username = 'wbuser@wb.com.usernameeprintegration'];
       System.runAs(wbErpUser) {
            wunderbricks__Invoice_Template__c defaultInvoiceTemplate = new wunderbricks__Invoice_Template__c(
                Name = 'Default',
                wunderbricks__Email_Subject__c = 'Default Subject',
                wunderbricks__Email_Body__c = 'Default Body',
                wunderbricks__Invoice_Number_Pattern__c = 'Invoice {0000}'
            );
            defaultInvoiceTemplate.wunderbricks__Is_Default__c = true;
            insert defaultInvoiceTemplate;
    
            Account tenantAcc = new Account(
                Name = 'Tenant I',
                wunderbricks__Role__c = 'Tenant'
            );
            Account ownerAcc = new Account(
                Name = 'Owner I',
                wunderbricks__Role__c = 'Owner',
                wunderbricks__Logo_Id__c = 'testLogoId',
                wunderbricks__Tax_Id__c = 'TEST VAT',
                BillingCity = 'TEST City',
                BillingCountry = 'Netherlands',
                BillingPostalCode = 'TEST Postal Code',
                BillingStreet = 'TEST Street',
                wunderbricks__Invoice_Template__c = defaultInvoiceTemplate.Id
            );
            insert new List<Account>{ownerAcc, tenantAcc};

            wunderbricks__Bank_Account__c bankAccount = new wunderbricks__Bank_Account__c(
                Name = 'NL91ABNA0417164300',
                wunderbricks__Account_Holder_Name__c = 'Current Account',
                wunderbricks__Account__c = ownerAcc.Id,
                wunderbricks__BIC__c = 'ABNANL2A',
                wunderbricks__Bank__c = 'ABN AMRO Bank N.V.'
            );
            insert bankAccount;

            wunderbricks__Invoice_Set__c invSet = [SELECT wunderbricks__Charge_Type__c FROM wunderbricks__Invoice_Set__c WHERE wunderbricks__Account__c = :ownerAcc.Id];
            invSet.wunderbricks__Charge_Type__c = getPickVals('wunderbricks__Invoice_Set__c', 'wunderbricks__Charge_Type__c');
            update invSet;

            wunderbricks__Invoice_Set_Bank_Account__c invSetBankAccount = new wunderbricks__Invoice_Set_Bank_Account__c(
                wunderbricks__Bank_Account__c = bankAccount.Id,
                wunderbricks__Invoice_Set__c   = invSet.Id
            ); 
            insert invSetBankAccount;

            Contact tenantCont = new Contact(Account = tenantAcc, LastName = 'Tenant I');
            Contact ownerAccCont = new Contact(Account = ownerAcc, LastName = 'Owner I');
            insert new List<Contact>{ownerAccCont, tenantCont};

            wunderbricks__Property__c propObj = new wunderbricks__Property__c(
                wunderbricks__Street_Name__c              = 'De Vooysplantsoen Test',
                wunderbricks__City__c                     = 'Utrecht',
                wunderbricks__Country_PickList__c         = 'Netherlands',
                wunderbricks__Gross_Floor_Surface_Area__c = 200,
                wunderbricks__Net_Floor_Surface_Area__c   = 200,
                wunderbricks__Property_Owner__c           = ownerAcc.Id
            );
            insert propObj;
            
            wunderbricks__Unit__c unitObj = new wunderbricks__Unit__c(
                wunderbricks__Name__c               = 'Unit I',
                wunderbricks__Floor_Surface_Area__c = 5,
                wunderbricks__Property__c           = propObj.Id
            );
            insert unitObj;

            wunderbricks__GL_Account__c defaultGLAccount = new wunderbricks__GL_Account__c(wunderbricks__Code__c = 'defaultGLAccountCode', wunderbricks__Description__c = 'glAccount Description');
            wunderbricks__GL_Account__c defaultTaxPayableGLAccount = new wunderbricks__GL_Account__c(wunderbricks__Code__c = '1', wunderbricks__Description__c = 'Payable');
            wunderbricks__GL_Account__c defaultTaxReceivableGLAccount = new wunderbricks__GL_Account__c(wunderbricks__Code__c = '2', wunderbricks__Description__c = 'Receivable');
            insert new List<wunderbricks__GL_Account__c> {defaultGLAccount, defaultTaxPayableGLAccount, defaultTaxReceivableGLAccount};

            wunderbricks__Charge_Type_To_GL_Account_Mapping__c defaultMapping = new wunderbricks__Charge_Type_To_GL_Account_Mapping__c(
                wunderbricks__GL_Account__c  = defaultGLAccount.Id,
                wunderbricks__Account__c     = ownerAcc.Id,
                wunderbricks__Charge_Type__c = getPickVals('wunderbricks__Charge_Type_To_GL_Account_Mapping__c', 'wunderbricks__Charge_Type__c')
            );
            insert defaultMapping;

            wunderbricks__Journal__c defaultPurchaseJournal = new wunderbricks__Journal__c(
                wunderbricks__Account__c     = ownerAcc.Id,
                wunderbricks__Code__c        = 'PurchaseDefaultJournalCode',
                wunderbricks__Description__c = 'Purchase Journal Description', 
                wunderbricks__Type__c        = 'Purchase'
            );
            wunderbricks__Journal__c defaultSalesJournal = new wunderbricks__Journal__c(
                wunderbricks__Account__c     = ownerAcc.Id,
                wunderbricks__Code__c        = 'SalesDefaultJournalCode',
                wunderbricks__Description__c = 'Sales Journal Description',
                wunderbricks__Type__c        = 'Sales'
            );
            insert new List<wunderbricks__Journal__c>{defaultPurchaseJournal, defaultSalesJournal};

            wunderbricks__VAT_Code__c vatCode = new wunderbricks__VAT_Code__c(
                Name                                   = 'testCodeName',
                wunderbricks__Account__c               = ownerAcc.Id,
                wunderbricks__Code__c                  = 'testCode',
                wunderbricks__Payable_GL_Account__c    = defaultTaxPayableGLAccount.Id,
                wunderbricks__Receivable_GL_Account__c = defaultTaxReceivableGLAccount.Id,
                wunderbricks__Description__c           = 'the code used for tests.'
            );
            insert vatCode;

            wunderbricks__VAT_Rate__c vatRate = new wunderbricks__VAT_Rate__c(
                wunderbricks__VAT_Code__c   = vatCode.Id,
                wunderbricks__Rate__c       = 21,
                wunderbricks__Start_Date__c = System.today().toStartOfMonth(),
                wunderbricks__End_Date__c   = System.today().toStartOfMonth().addMonths(1)
            );
            insert vatRate;

            wunderbricks__Contract__c leaseRecord = new wunderbricks__Contract__c(
                wunderbricks__Lease_Type__c           = 'Standard',
                wunderbricks__Type__c                 = 'Commercial',
                wunderbricks__Account__c              = tenantAcc.Id,
                wunderbricks__Invoicing_Start_Date__c = System.today(),
                wunderbricks__Billing_Period__c       = 'Calendar Month',
                wunderbricks__Property__c             = propObj.Id
            );
            insert leaseRecord;

            wunderbricks__Lease_Period__c leasePeriod = new wunderbricks__Lease_Period__c(
                wunderbricks__Lease__c                       = leaseRecord.Id,
                wunderbricks__Type__c                        = 'Fixed', 
                wunderbricks__Start_Date__c                  = leaseRecord.wunderbricks__Invoicing_Start_Date__c,
                wunderbricks__Expiry_Date__c                 = System.today().addYears(1),
                wunderbricks__Notice_Period_Owner_Months__c  = 0,
                wunderbricks__Notice_Period_Tenant_Months__c = 0
            );
            insert leasePeriod;

            wunderbricks__Lease_Tenant__c leaseMainTenantRecord = new wunderbricks__Lease_Tenant__c(
                wunderbricks__Lease__c      = leaseRecord.Id,
                wunderbricks__Tenant__c     = leaseRecord.wunderbricks__Account__c,
                wunderbricks__Start_Date__c = leaseRecord.wunderbricks__Invoicing_Start_Date__c,
                wunderbricks__Type__c       = 'Main Tenant'
            );
            insert leaseMainTenantRecord;
            
            wunderbricks__Contract_Line_Item__c cliObj = new wunderbricks__Contract_Line_Item__c(
                wunderbricks__Contract__c               = leaseRecord.Id,
                wunderbricks__Invoice_Frequency__c      = 'Monthly',
                wunderbricks__Start_Date__c             = leaseRecord.wunderbricks__Invoicing_Start_Date__c,
                wunderbricks__Unit__c     = unitObj.Id,
                wunderbricks__VAT_Code__c = vatCode.Id,
                wunderbricks__Unit_Price__c             = 0,
                wunderbricks__Component__c              = 'Rent Taxable',
                wunderbricks__End_Date__c               = leasePeriod.wunderbricks__Expiry_Date__c,
                wunderbricks__Description__c            = 'cli description'
            );
            insert cliObj;

            leaseRecord.wunderbricks__Status__c = 'Signed';
            update leaseRecord;

            wunderbricks__Invoice__c inv = new wunderbricks__Invoice__c(
                wunderbricks__Lease__c             = leaseRecord.Id,
                wunderbricks__Invoice_Date__c      = Date.today(),
                wunderbricks__Period_Start_Date__c = Date.today().toStartOfMonth(),
                wunderbricks__Period_End_Date__c   = Date.today().addMonths(1).addDays(-1)
            );
            insert inv;

            wunderbricks__Invoice_Item__c ili = new wunderbricks__Invoice_Item__c(
                wunderbricks__Invoice__c                = inv.Id,
                wunderbricks__Amount_excl_VAT__c        = 150,
                wunderbricks__VAT_Code__c           = vatCode.Id,
                wunderbricks__Charge_Type__c            = 'Utility',
                wunderbricks__Period_Start_Date__c      = System.today().toStartOfMonth(),
                wunderbricks__Period_End_Date__c        = System.today().toStartOfMonth().addMonths(1).addDays(-1)
            );
            insert ili;

        }
    }

    @IsTest
    private static void invoicePdfController() {

        User userObj = [SELECT Id FROM User WHERE Username = 'wbuser@wb.com.username'];
        System.runAs(userObj) {
            System.Test.startTest();

            ApexPages.StandardController sc = new ApexPages.StandardController([SELECT Id FROM wunderbricks__Invoice__c LIMIT 1]);
            CustomInvoicePdfController invPdfController = new CustomInvoicePdfController(sc);


            //User without permission
            User noPermUserObj = [SELECT Id FROM User WHERE Username = 'wbuser@wb.com.usernamenoperm'];
            System.runAs(noPermUserObj) {
                Boolean wasErrorOccurred = false;
                try {
                    CustomInvoicePdfController invPdfControllerWithoutPerm = new CustomInvoicePdfController(sc);
                } catch(Exception ex) {
                    wasErrorOccurred = true;
                    System.assert(ex != null, 'An Exception should be thrown.');
                    System.assert(String.isNotBlank(ex.getMessage()), 'The exception should\'ve an error message.');
                }
                System.assert(true, wasErrorOccurred);
            }

            System.Test.stopTest();
            //Stop test

            System.assertNotEquals(null, invPdfController.invDTO, 'Invoice DTO should be created.');
            System.assertNotEquals(null, invPdfController.invDTO.invoiceNumber, 'Invoice number should be populated.');
            System.assertNotEquals(null, invPdfController.invDTO.invoiceDate, 'Invoice Date should be populated.');
            System.assertNotEquals(null, invPdfController.invDTO.toAccount, 'Account should be linked should be populated.');
            System.assertNotEquals(null, invPdfController.invDTO.fromAccount, 'Billing Entity should be linked.');
            System.assertEquals('Owner I', invPdfController.invDTO.fromAccount.name, 'Company name should be the same.');
            System.assertEquals('Netherlands', invPdfController.invDTO.fromAccount.billingCountry, 'Country should be the same.');
            System.assertEquals('TEST Street', invPdfController.invDTO.fromAccount.billingStreet, 'Street should be the same.');
            System.assertEquals('TEST Postal Code TEST City', invPdfController.invDTO.fromAccount.billingPostalCodeAndCity, 'Postal Code and City should be the same.');
            System.assertEquals('TEST VAT', invPdfController.invDTO.fromAccount.taxId, 'VAT should be the same.');
            System.assertEquals('/sfc/servlet.shepherd/version/download/testLogoId', invPdfController.invDTO.fromAccount.logoURL, 'Logo URL should be the same.');
            System.assertEquals(1, invPdfController.invDTO.invoiceItems.size(), 'Invoice Items list should contain 1 item.');
            System.assert('150,00' == invPdfController.invDTO.totalAmountExclVAT || '150.00' == invPdfController.invDTO.totalAmountExclVAT, 'Total amount excluding VAT should be the same.');
            System.assert('181,50' == invPdfController.invDTO.totalAmountInclVAT || '181.50' == invPdfController.invDTO.totalAmountInclVAT, 'Total amount including VAT should be the same.');
            System.assert('31,50' == invPdfController.invDTO.totalVAT || '31.50' == invPdfController.invDTO.totalVAT, 'Total VAT amount should be the same.');
        }
    }


    private static string getPickVals(String objectName, String fieldName) {
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();

        List<String> values = new List<String>();
        for (Schema.PicklistEntry entry : picklistValues) {
            values.add(entry.getValue());
        }
        String result = String.join(values, ';');
        return result;
    }
}