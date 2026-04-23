public with sharing class CustomLeaseIndexationPDFController {
    public CustomLeaseIndexationDTO CustomLeaseIndexationDTO { get; set; }
    public String today {
        get {
            return CustomPdfUtils.getFormattedDateStringWithSymbol(Date.today(), '/');
        }
    }
    public String infoMessage { get; set; }
    public String footerMessage { get; set; }
    public Boolean showInfoTable { get; set; }
    public Boolean showInfoTableRows { get; set; }
    public Boolean showIndexationHeadersInfo { get; set; }
    public String pageFooter { get; set; }
    public String frequencyMessage { get; set; }
    public String postInfoStyle { get; set; }
    public String logoStyle { get; set; }

    public CustomLeaseIndexationPDFController(ApexPages.StandardController standardController) {
        CustomLeaseIndexationDTO = getLeaseIndexationDTO((wunderbricks__Lease_Indexation__c) standardController.getRecord());

        infoMessage = getInfoMessage();
        footerMessage = getFooterMessage();
        showInfoTable = (CustomLeaseIndexationDTO.leaseHousingSector != CustomLeaseIndexationConstants.LEASE_HOUSING_SECTOR_MID_RENTAL_SECTOR &&
        CustomLeaseIndexationDTO.leaseHousingSector != CustomLeaseIndexationConstants.LEASE_HOUSING_SECTOR_SOCIAL_SECTOR);
        showInfoTableRows = wunderbricks__PDF_Template__mdt.getInstance('Lease_Indexation_PDF').wunderbricks__Show_Extra_Info__c;
        postInfoStyle = wunderbricks__PDF_Template__mdt.getInstance('Lease_Indexation_PDF').wunderbricks__CSS_Style_of_Recipient_Info__c;
        logoStyle = wunderbricks__PDF_Template__mdt.getInstance('Lease_Indexation_PDF').wunderbricks__CSS_Style_of_Logo__c;
        pageFooter = getPageFooter();
        frequencyMessage = String.format(
            Label.get('wunderbricks', 'The_amounts_above_are_x_amounts_label'),
            new List<String>{ getFrequencyMessage() }
        );

        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=' + CustomLeaseIndexationDTO.leaseAddress + '.pdf');
    }

    private CustomLeaseIndexationDTO getLeaseIndexationDTO(wunderbricks__Lease_Indexation__c inputLeaseIndexation) {
        Set<Id> inputLeaseIndexationIdSet = new Set<Id>{ inputLeaseIndexation.Id };
        wunderbricks__Lease_Indexation__c localLeaseIndexation = CustomLeaseIndexationQueries.selectWithLeaseItemIndexations(inputLeaseIndexationIdSet).get(0);
        showIndexationHeadersInfo = !localLeaseIndexation.wunderbricks__Lease__r.wunderbricks__Indexation_Method__r.wunderbricks__Is_Fixed_Rate__c;
        wunderbricks__Contract__c localLease = CustomLeaseQueries.selectWithLeaseItemsForPDF(localLeaseIndexation.wunderbricks__Lease__c).get(0);

        return new CustomLeaseIndexationDTO(localLeaseIndexation, localLease, Apexpages.currentPage().getParameters().get('lang'));
    }

    private String getInfoMessage() {
        String labelKey = (CustomLeaseIndexationDTO.leaseHousingSector == CustomLeaseIndexationConstants.LEASE_HOUSING_SECTOR_MID_RENTAL_SECTOR ||
            CustomLeaseIndexationDTO.leaseHousingSector == CustomLeaseIndexationConstants.LEASE_HOUSING_SECTOR_SOCIAL_SECTOR)
            ? 'Lease_Indexation_PDF_Info_Res_Social_label'
            : 'Lease_Indexation_PDF_Info_label';

        List<String> formatArgs = (labelKey == 'Lease_Indexation_PDF_Info_Res_Social_label')
            ? new List<String>{ CustomLeaseIndexationDTO.leasePropOwnerName, CustomLeaseIndexationDTO.indexationRunDate }
            : new List<String>{ CustomLeaseIndexationDTO.leasePropOwnerName };

        return String.format(Label.get('wunderbricks', labelKey), formatArgs);
    }

    private String getFooterMessage() {
        String residentialSocialFooterEN =
            '<p>If the rent increase is higher than the legally established percentage of 4,1%, then the Income-Dependent Rent Increase (IAH) has been applied. Only in that case will you find a statement from the tax authorities attached.</p>' +
            '<p>Based on legislative changes, your rent may be increased to the following amounts / percentages: ' +
            '<l><li>- 4,1% if your household income in 2024 was less than or equal to €59.504 for 1 person, or €68.858 for 2 or more persons. However, if the current rent is lower than €350,00, it will be increased by €25,00;</li>' +
            '<li>- a maximum of €50 if your household income in 2024 for 1 person was between €59.504 and €70.149 or for 2 or more persons the income was between €68.858 and €93.531;</li>' +
            '<li>- a maximum of €100 if your household income in 2024 for 1 person was higher than €70.149 and for 2 or more persons was higher than €93.531.</li></l></p>' +
            '<p>Well-founded objections to the proposed rent increase can be submitted to us in writing by July 1, 2026, at the latest, using an objection form from the Huurcommissie via email. This objection form can be downloaded from the website of the Huurcommissie (www.huurcommissie.nl).</p>' +
            '<p>We kindly request that you fulfill the aforementioned amended obligation in the usual manner starting from  {0}. If you have authorized us for direct debit, the new rent will be debited from  {0}.</p>' +
            '<p>For more information about the maximum rent increase, please visit the website of the government (Rijksoverheid): https://www.rijksoverheid.nl/onderwerpen/woning-huren/vraag-en-antwoord/wat-is-de-maximale-huurverhoging-in-2026.</p>' +
            '<p>We trust we have sufficiently informed you with this.</p>' +
            '<p>Sincerely,<br/>{1}</p>' +
            '<p><i>(This letter is automatically generated and therefore not signed)</i></p>';

        String residentialSocialFooterNL =
            '<p>Indien de huurverhoging hoger is dan het wettelijk vastgestelde percentage van 4,1%, dan is er gebruik gemaakt van de IAH (Inkomens Afhankelijke Huurverhoging). Alleen in dat geval treft u bijgevoegd een verklaring van de belastingdienst aan.</p>' +
            '<p>Op basis van de wettelijke wijzigingen kan uw huurprijs worden verhoogd tot de onderstaande waarden / percentage: ' +
            '<l><li>- 4,1% als uw gezinsinkomen in 2024 lager was dan of gelijk was aan € 59.504,- voor 1 persoon of € 68.858,- voor 2 of meer personen. Echter, als de huidige huur lager is dan € 350,00 wordt deze verhoogd met € 25,00;</li>' +
            '<li>- maximaal € 50,- als uw gezinsinkomen in 2024 voor 1 persoon tussen de € 59.504 en € 70.149 was of voor 2 personen of meer het inkomen tussen de € 68.858 – € 93.531 was;</li>' +
            '<li>- maximaal € 100,- als uw gezinsinkomen in 2024 voor 1 persoon hoger was dan € 70.149 en voor 2 personen of meer hoger dan € 93.531 was.</li></l></p>' +
            '<p>Gegronde bezwaren tegen de voorgestelde huurprijsverhoging kunt u tot uiterlijk 1 juli 2026 schriftelijk middels een bezwaarschrift van de Huurcommissie bij ons indienen via email. Dit bezwaarschrift is te downloaden op de website van de Huurcommissie (www.huurcommissie.nl).</p>' +
            '<p>Wij verzoeken u met ingang van {0} de bovenstaande gewijzigde verplichting op de gebruikelijke wijze te voldoen. Indien u ons heeft gemachtigd tot automatische incasso, zal de nieuwe huurprijs vanaf {0} worden afgeschreven.</p>' +
            '<p>Voor meer informatie over de maximale huurverhoging kunt u terecht op de website van de Rijksoverheid: https://www.rijksoverheid.nl/onderwerpen/woning-huren/vraag-en-antwoord/wat-is-de-maximale-huurverhoging-in-2026.</p>' +
            '<p>Wij vertrouwen erop u hiermee voldoende te hebben geïnformeerd.</p>' +
            '<p>Hoogachtend,<br/>{1}</p>' +
            '<p><i>(Deze brief is automatisch gegenereerd en daarom niet ondertekend)</i></p>';

        String residentialMidFooterEN =
            '<p>Based on the recent legislative changes, your rent may be increased by a maximum of 6,1%. This applies if: ' +
            '<l><li>- the rental agreement started on or after July 1, 2024;' +
            '<li>- the (basic) initial rent in the second half of 2025 is above €900,07 and does not exceed €1.184,82 or the (basic) initial rent in 2026 is above €932,93 and does not exceed €1.228,07.</li></l></p>' +
            '<p>Well-founded objections to the proposed rent increase can be submitted to us in writing by July 1, 2026, at the latest, using an objection form from the Huurcommissie via email. This objection form can be downloaded from the website of the Huurcommissie (www.huurcommissie.nl).</p>' +
            '<p>We kindly request that you fulfill the aforementioned amended obligation in the usual manner starting from  {0}. If you have authorized us for direct debit, the new rent will be debited from  {0}.</p>' +
            '<p>For more information about the maximum rent increase, please visit the website of the government (Rijksoverheid): https://www.rijksoverheid.nl/onderwerpen/woning-huren/vraag-en-antwoord/wat-is-de-maximale-huurverhoging-in-2026.</p>' +
            '<p>We trust we have sufficiently informed you with this.</p>' +
            '<p>Sincerely,<br/>{1}</p>' +
            '<p><i>(This letter is automatically generated and therefore not signed)</i></p>';

        String residentialMidFooterNL =
            '<p>Op basis van de wettelijke wijzigingen kan uw huurprijs maximaal met 6,1% verhoogd worden. Dit geldt als: ' +
            '<l><li>- een huurcontract is ingegaan op 1 juli 2024 of later;</li>' +
            '<li>- (kale) beginhuur in (tweede helft) 2025: boven € 900,07 en niet meer dan € 1.184,82 of een (kale) beginhuur in 2026: boven € 932,93 en niet meer dan € 1.228,07.</li></l></p>' +
            '<p>Gegronde bezwaren tegen de voorgestelde huurprijsverhoging kunt u tot uiterlijk 1 juli 2026 schriftelijk middels een bezwaarschrift van de Huurcommissie bij ons indienen via email. Dit bezwaarschrift is te downloaden op de website van de Huurcommissie (www.huurcommissie.nl).</p>' +
            '<p>Wij verzoeken u met ingang van {0} de bovenstaande gewijzigde verplichting op de gebruikelijke wijze te voldoen. Indien u ons heeft gemachtigd tot automatische incasso, zal de nieuwe huurprijs vanaf {0} worden afgeschreven.</p>' +
            '<p>Voor meer informatie over de maximale huurverhoging kunt u terecht op de website van de Rijksoverheid: https://www.rijksoverheid.nl/onderwerpen/woning-huren/vraag-en-antwoord/wat-is-de-maximale-huurverhoging-in-2026.</p>' +
            '<p>Wij vertrouwen erop u hiermee voldoende te hebben geïnformeerd.</p>' +
            '<p>Hoogachtend,<br/>{1}</p>' +
            '<p><i>(Deze brief is automatisch gegenereerd en daarom niet ondertekend)</i></p>';

        String residentialFreeFooterEN =
            '<p>The rent is deregulated. If you object to the annual rent increase, you can find information about the available options and procedures on the website of the Huurcommissie: https://www.huurcommissie.nl/onderwerpen/huurverhoging-vrije-sector-huurder/jaarlijkse-huurverhoging-beoordelen.</p>' +
            '<p>We kindly request that you fulfill the aforementioned amended obligation in the usual manner starting from  {0}. If you have authorized us for direct debit, the new rent will be debited from  {0}.</p>' +
            '<p>For more information about the maximum rent increase, please visit the website of the government (Rijksoverheid): https://www.rijksoverheid.nl/onderwerpen/woning-huren/vraag-en-antwoord/wat-is-de-maximale-huurverhoging-in-2026.</p>' +
            '<p>We trust we have sufficiently informed you with this.</p>' +
            '<p>Sincerely,<br/>{1}</p>' +
            '<p><i>(This letter is automatically generated and therefore not signed)</i></p>';

        String residentialFreeFooterNL =
            '<p>De huurprijs is geliberaliseerd. Heeft u bezwaar tegen de jaarlijkse huurverhoging, dan kunt u op de website van de Huurcommissie informatie vinden over de mogelijkheden en de wijze waarop: https://www.huurcommissie.nl/onderwerpen/huurverhoging-vrije-sector-huurder/jaarlijkse-huurverhoging-beoordelen.</p>' +
            '<p>Wij verzoeken u met ingang van {0} de bovenstaande gewijzigde verplichting op de gebruikelijke wijze te voldoen. Indien u ons heeft gemachtigd tot automatische incasso, zal de nieuwe huurprijs vanaf {0} worden afgeschreven.</p>' +
            '<p>Voor meer informatie over de maximale huurverhoging kunt u terecht op de website van de Rijksoverheid: https://www.rijksoverheid.nl/onderwerpen/woning-huren/vraag-en-antwoord/wat-is-de-maximale-huurverhoging-in-2026.</p>' +
            '<p>Wij vertrouwen erop u hiermee voldoende te hebben geïnformeerd.</p>' +
            '<p>Hoogachtend,<br/>{1}</p>' +
            '<p><i>(Deze brief is automatisch gegenereerd en daarom niet ondertekend)</i></p>';

        String commercialFooterEN =
            '<p>We kindly request that you fulfill the aforementioned amended obligation in the usual manner starting from {0}. If you have authorized us for direct debit, the new rent will be debited from {0}.</p>' +
            '<p>We trust we have sufficiently informed you with this.</p>' +
            '<p>Sincerely,<br/>{1}</p>' +
            '<p><i>(This letter is automatically generated and therefore not signed)</i></p>';

        String commercialFooterNL =
            '<p>Wij verzoeken u met ingang van {0} de bovenstaande gewijzigde verplichting op de gebruikelijke wijze te voldoen. Indien u ons heeft gemachtigd tot automatische incasso, zal de nieuwe huurprijs vanaf {0} worden afgeschreven.</p>' +
            '<p>Wij vertrouwen erop u hiermee voldoende te hebben geïnformeerd.</p>' +
            '<p>Hoogachtend,<br/>{1}</p>' +
            '<p><i>(Deze brief is automatisch gegenereerd en daarom niet ondertekend)</i></p>';

        String msgFooter;
        Map<String, String> footerMap = new Map<String, String>{
            CustomLeaseIndexationConstants.LEASE_HOUSING_SECTOR_SOCIAL_SECTOR => Apexpages.currentPage().getParameters().get('lang') == 'nl'
                ? residentialSocialFooterNL
                : residentialSocialFooterEN,
            CustomLeaseIndexationConstants.LEASE_HOUSING_SECTOR_MID_RENTAL_SECTOR => Apexpages.currentPage().getParameters().get('lang') == 'nl'
                ? residentialMidFooterNL
                : residentialMidFooterEN,
            CustomLeaseIndexationConstants.LEASE_HOUSING_SECTOR_PRIVATE_SECTOR => Apexpages.currentPage().getParameters().get('lang') == 'nl'
                ? residentialFreeFooterNL
                : residentialFreeFooterEN
        };

        if (CustomLeaseIndexationDTO.leaseType == CustomLeaseIndexationConstants.LEASE_SECTOR_TYPE_RESIDENTIAL) {
            msgFooter = footerMap.get(CustomLeaseIndexationDTO.leaseHousingSector);
        } else {
            msgFooter = Apexpages.currentPage().getParameters().get('lang') == 'nl' ? commercialFooterNL : commercialFooterEN;
        }

        if (String.isNotBlank(msgFooter)) {
            msgFooter = String.format(msgFooter, new List<String>{ CustomLeaseIndexationDTO.applyingFrom, CustomLeaseIndexationDTO.leaseBilling.name });
        }
        return msgFooter;
    }

    private String getPageFooter() {
        CustomAccountDTO billing = CustomLeaseIndexationDTO.leaseBilling;
        List<String> footerParts = new List<String>();

        List<String> nameParts = new List<String>();
        if (String.isNotBlank(billing.name)) {
            nameParts.add(billing.name);
        }
        if (String.isNotBlank(billing.billingAddress)) {
            nameParts.add(billing.billingAddress);
        }
        if (!nameParts.isEmpty()) {
            footerParts.add(String.join(nameParts, ' | '));
        }

        List<String> contactParts = new List<String>();
        if (billing.invoicePhone != null) {
            contactParts.add(billing.invoicePhone);
        }
        if (billing.invoiceEmail != null) {
            contactParts.add(billing.invoiceEmail);
        }
        if (billing.website != null) {
            contactParts.add(billing.website);
        }
        if (!contactParts.isEmpty()) {
            footerParts.add(String.join(contactParts, ' | '));
        }

        List<String> technicalParts = new List<String>();
        if (billing.cocNumber != null) {
            technicalParts.add('KvK ' + billing.cocNumber);
        }
        if (billing.taxId != null) {
            technicalParts.add('BTW ' + billing.taxId);
        }
        if (!technicalParts.isEmpty()) {
            footerParts.add(String.join(technicalParts, ' | '));
        }

        return String.join(footerParts, '\\a ');
    }

    private String getFrequencyMessage() {
        Map<String, String> frequencyTranslations = new Map<String, String>{ 'Monthly' => 'maand', 'Quarterly' => 'kwartaal', 'Yearly' => 'jaar' };
        if (Apexpages.currentPage().getParameters().get('lang') == 'nl') {
            return frequencyTranslations.get(CustomLeaseIndexationDTO.leaseOccurrence);
        } else {
            return CustomLeaseIndexationDTO.leaseOccurrence;
        }
    }
}
