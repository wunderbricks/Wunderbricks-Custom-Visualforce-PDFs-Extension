Set<Id> test = new Set<Id>{
    'xxxx'
};
    Map<Id, wunderbricks__Invoice__c> invoiceMap = new Map<Id, wunderbricks__Invoice__c>(
        [
            SELECT 
            Id, 
            Name, 
            wunderbricks__From__c, 
            wunderbricks__Administration_Account__c, 
            wunderbricks__To__c, 
            wunderbricks__Charge_Type__c, 
            wunderbricks__Bank_Details_Account__c, 
            wunderbricks__Period_Start_Date__c, 
            wunderbricks__Period_End_Date__c, 
            wunderbricks__Period_Start_Date_Formula__c, 
            wunderbricks__Period_End_Date_Formula__c, 
            wunderbricks__Total_incl_VAT__c, 
            wunderbricks__Total_excl_VAT__c, 
            wunderbricks__Type__c, 
            wunderbricks__Lease__c, 
            wunderbricks__Paid_From_Bank_Account__c, 
            wunderbricks__Paid_To_Bank_Account__c, 
            wunderbricks__Journal__c, 
            wunderbricks__Payment_Term_Days__c, 
            wunderbricks__Invoice_Language__c, 
            wunderbricks__Related_Invoice__c,
            wunderbricks__Status__c,
            wunderbricks__From__r.wunderbricks__Invoice_Email__c,
            wunderbricks__From__r.wunderbricks__Invoice_Template__r.wunderbricks__Email_Subject__c,
            wunderbricks__From__r.wunderbricks__Invoice_Template__r.wunderbricks__Email_Body__c,
            wunderbricks__From__r.wunderbricks__Invoice_Template__r.wunderbricks__Email_Template_Id__c,
            wunderbricks__From__r.wunderbricks__Invoice_Template_Credit__r.wunderbricks__Email_Template_Id__c,
            wunderbricks__From__r.wunderbricks__Invoice_Template_Credit__r.wunderbricks__Email_Subject__c,
            wunderbricks__From__r.wunderbricks__Invoice_Template_Credit__r.wunderbricks__Email_Body__c,
            (SELECT Title, ContentDocumentId FROM AttachedContentDocuments)
            FROM wunderbricks__Invoice__c
            WHERE Id IN :test
        ]
    );

Map<Id, ContentVersion> test2 = createPDF(invoiceMap);

public static Map<Id, ContentVersion> createPDF(Map<Id, wunderbricks__Invoice__c> invoiceMap) {
    Map<Id, ContentVersion> invoiceIdToPDF = new Map<Id, ContentVersion>();
    
    for (wunderbricks__Invoice__c invoiceRecord : invoiceMap.values()) {
        String invoiceFileName = invoiceRecord.Name + '.pdf';
        
        ContentVersion cv = new ContentVersion();
        PageReference pdfPage = new PageReference('/apex/CustomInvoicePDF');
        pdfPage.getParameters().put('id', invoiceRecord.Id);
        pdfPage.getParameters().put('lang', invoiceRecord.wunderbricks__Invoice_Language__c);
        cv.ContentLocation = 'S'; // S specifies this document is in Salesforce
        cv.PathOnClient = invoiceFileName;
        cv.Title = invoiceFileName;
        cv.wunderbricks__Is_Invoice__c = true;
        
        //try {
        cv.VersionData = pdfPage.getContent();
        // TODO: keep only getContentAsPDF after salesforce fixes this. At the time of writing this, getContentAsPDF() throws an internal salesforce error that is not catchable, that why the getContact() is also used above.
        cv.VersionData = pdfPage.getContentAsPDF();
        //} catch (Exception e) {
        //    throw new Exceptions.CaughtException(Label.Visualforce_page_does_not_exist_label.replace('{0}', 'CustomInvoicePDF'));
        //}
        invoiceIdToPDF.put(invoiceRecord.Id, cv);
    }
    
    insert invoiceIdToPDF.values();
    
    invoiceIdToPDF = linkContentVersionsToInvoices(invoiceIdToPDF);
    
    return invoiceIdToPDF;
}

public static Map<Id, ContentVersion> linkContentVersionsToInvoices(Map<Id, ContentVersion> invoiceIdToPDF) {
    Map<Id, Id> newPDFIdToInvoiceId = new Map<Id, Id>();
    
    Set<Id> contentVersionIds = new Set<Id>();
    ContentVersion currentCV;
    for (Id invoiceId : invoiceIdToPDF.keySet()) {
        currentCV = invoiceIdToPDF.get(invoiceId);
        contentVersionIds.add(currentCV.Id);
        newPDFIdToInvoiceId.put(currentCV.Id, invoiceId);
    }
    
    Map<Id, ContentVersion> cvMap = new Map<Id, ContentVersion>([
        SELECT 
        Id,
        ContentDocumentId,
        PathOnClient,
        VersionData,
        ContentUrl,
        wunderbricks__Is_Invoice__c
        FROM ContentVersion
        WHERE Id IN :contentVersionIds
    ]);
    Id contentDocumentId;
    Id relatedInvoiceId;
    List<ContentDocumentLink> cdls = new List<ContentDocumentLink>();
    for (ContentVersion cv : cvMap.values()) {
        contentDocumentId = cv.ContentDocumentId;
        
        relatedInvoiceId = newPDFIdToInvoiceId.get(cv.Id);
        invoiceIdToPDF.put(relatedInvoiceId, cv);
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocumentId;
        cdl.LinkedEntityId = relatedInvoiceId;
        cdl.ShareType = 'I';
        cdls.add(cdl);
    }
    
    insert cdls;
    return invoiceIdToPDF;
}
