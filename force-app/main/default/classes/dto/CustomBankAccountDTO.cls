/**
 * Created by @PanagiotisEkatos on 30/05/2022.
 */

public inherited sharing class CustomBankAccountDTO {
    public String  name              {get; set;}
    public String  accountHolderName {get; set;}
    public String  bank              {get; set;}
    public String  BIC               {get; set;}
    public String  description       {get; set;}


    public CustomBankAccountDTO(String name, String accountHolderName, String bank, String BIC, String description) {
        this.name                = name;
        this.accountHolderName   = accountHolderName;
        this.bank                = bank;
        this.BIC                 = BIC;
        this.description         = description;
    }

}