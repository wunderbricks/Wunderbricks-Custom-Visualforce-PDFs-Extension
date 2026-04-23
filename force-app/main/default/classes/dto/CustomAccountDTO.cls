public inherited sharing class CustomAccountDTO {
    public String id { get; set; }
    @AuraEnabled
    public String name { get; set; }
    public String taxId { get; set; }
    public String debtorNumber { get; set; }
    public String attention { get; set; }
    public String email { get; set; }
    public String phone { get; set; }
    public String invoiceEmail { get; set; }
    public String invoicePhone { get; set; }
    public String cocNumber { get; set; }
    public String website { get; set; }
    public String logoId { get; set; }
    public String logoUrl { get; set; }
    public String billingAddress { get; set; }
    public String billingStreet { get; set; }
    public String billingPostalCodeAndCity { get; set; }
    public String billingCountry { get; set; }

    public List<CustomBankAccountDTO> bankAccounts { get; set; }

    public CustomAccountDTO(Account accountRecord) {
        this.name = accountRecord.Name;
        this.taxId = accountRecord.wunderbricks__Tax_Id__c;
        this.debtorNumber = accountRecord.wunderbricks__Debtor_Number__c;
        this.attention = accountRecord.wunderbricks__Attention__c;
        this.email = accountRecord.wunderbricks__Email__c;
        this.phone = accountRecord.Phone;
        this.invoiceEmail = accountRecord.wunderbricks__Invoice_Email__c;
        this.invoicePhone = accountRecord.wunderbricks__Invoice_Phone__c;
        this.cocNumber = accountRecord.wunderbricks__CoC_Number__c;
        this.website = accountRecord.Website;
        this.logoId = accountRecord.wunderbricks__Logo_Id__c;
        this.logoUrl = '/sfc/servlet.shepherd/version/download/' + accountRecord.wunderbricks__Logo_Id__c;
        this.billingStreet = accountRecord.BillingStreet;
        this.billingPostalCodeAndCity = generatePostalCodeAndCity(accountRecord.BillingPostalCode, accountRecord.BillingCity);
        this.billingCountry = accountRecord.BillingCountry;
        this.billingAddress =
            (String.isBlank(accountRecord.BillingStreet) ? '' : accountRecord.BillingStreet + '') +
            (String.isBlank(accountRecord.BillingPostalCode) ? '' : ' ' + accountRecord.BillingPostalCode) +
            (String.isBlank(accountRecord.BillingCity) ? '' : ' ' + accountRecord.BillingCity);
    }

    public CustomAccountDTO(Account accountRecord, List<wunderbricks__Bank_Account__c> bankAccounts) {
        this(accountRecord);

        this.bankAccounts = new List<CustomBankAccountDTO>();
        for (wunderbricks__Bank_Account__c bankAccount : bankAccounts) {
            this.bankAccounts.add(new CustomBankAccountDTO(bankAccount));
        }
    }

    public CustomAccountDTO(String id, String name) {
        this.id = id;
        this.name = name;
    }

    public static String generatePostalCodeAndCity(String postalCode, String city) {
        String postalCodeAndCity;
        if (String.isNotBlank(postalCode) && String.isNotBlank(city)) {
            postalCodeAndCity = postalCode + ' ' + city;
        } else if (String.isNotBlank(postalCode)) {
            postalCodeAndCity = postalCode;
        } else if (String.isNotBlank(city)) {
            postalCodeAndCity = city;
        }

        return postalCodeAndCity;
    }
}
