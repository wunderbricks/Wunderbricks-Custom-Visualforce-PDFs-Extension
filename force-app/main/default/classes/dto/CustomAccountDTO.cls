/**
 * Created by vitalygaiduchok on 15/03/2021.
 */

public inherited sharing class CustomAccountDTO {

    public String id                        {get; set;}
    @AuraEnabled public String name         {get; set;}
    public String taxId                     {get; set;}
    public String debtorNumber              {get; set;}
    public String attention                 {get; set;}
    public String invoiceEmail              {get; set;}
    public String invoicePhone              {get; set;}
    public String cocNumber                 {get; set;}
    public String logoId                    {get; set;}
    public String logoUrl                   {get; set;}
    public String billingAddress            {get; set;}
    public String billingStreet             {get; set;}
    public String billingPostalCodeAndCity  {get; set;}
    public String billingCountry            {get; set;}

    public CustomAccountDTO(Account accountRecord) {
        this.name                     = accountRecord.Name;
        this.taxId                    = accountRecord.Tax_ID__c;
        this.debtorNumber             = accountRecord.Debtor_Number__c;
        this.attention                = accountRecord.Attention__c;
        this.invoiceEmail             = accountRecord.Invoice_Email__c;
        this.invoicePhone             = accountRecord.Invoice_Phone__c;
        this.cocNumber                = accountRecord.CoC_Number__c;
        this.logoId                   = accountRecord.Logo_Id__c;
        this.logoUrl                  = '/sfc/servlet.shepherd/version/download/' + accountRecord.Logo_Id__c;
        this.billingStreet            = accountRecord.BillingStreet;
        this.billingPostalCodeAndCity = generatePostalCodeAndCity(accountRecord.BillingPostalCode, accountRecord.BillingCity);
        this.billingCountry           = accountRecord.BillingCountry;
        this.billingAddress           = 
            (String.isBlank(accountRecord.BillingStreet) ? '' : accountRecord.BillingStreet + '') +
            (String.isBlank(accountRecord.BillingPostalCode) ? '' : ' ' + accountRecord.BillingPostalCode) +
            (String.isBlank(accountRecord.BillingCity) ? '' : ' ' + accountRecord.BillingCity);
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