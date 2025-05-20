/**
 * Created by @PanagiotisEkatos on 31/05/2022.
 */

public inherited sharing class CustomInvoiceItemDTO {
    public String  chargeType         {get; set;}
    public String  description        {get; set;}
    public String  propertyName       {get; set;}
    public String  unitName           {get; set;}
    public String  leaseItem          {get; set;}
    public String  periodStartDateStr {get; set;}
    public String  periodEndDateStr   {get; set;}
    public String  amountInclVAT      {get; set;}
    public String  amountExclVat      {get; set;}
    public String  vatAmount          {get; set;}
    public String  vatRate            {get; set;}
    public String  unitAddress        {get; set;}

    public CustomInvoiceItemDTO() {}

}