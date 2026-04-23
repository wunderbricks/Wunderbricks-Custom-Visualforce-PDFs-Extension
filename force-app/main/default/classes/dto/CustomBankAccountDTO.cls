public inherited sharing class CustomBankAccountDTO {
    public String name { get; set; }
    public String accountHolderName { get; set; }
    public String bank { get; set; }
    public String BIC { get; set; }
    public String description { get; set; }

    public CustomBankAccountDTO(wunderbricks__Bank_Account__c bankAcc) {
        this(
            bankAcc.Name,
            bankAcc.wunderbricks__Account_Holder_Name__c,
            bankAcc.wunderbricks__Bank__c,
            bankAcc.wunderbricks__BIC__c,
            bankAcc.wunderbricks__Description__c
        );
    }

    public CustomBankAccountDTO(String name, String accountHolderName, String bank, String BIC, String description) {
        this.name = name;
        this.accountHolderName = accountHolderName;
        this.bank = bank;
        this.BIC = BIC;
        this.description = description;
    }
}
