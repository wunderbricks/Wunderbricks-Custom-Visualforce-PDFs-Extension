public with sharing class CustomPropertyUtils {
    public static String getPropertyAddress(wunderbricks__Property__c property) {
        List<String> addressParts = new List<String>();

        if (String.isNotBlank(property.wunderbricks__Street_Name__c)) {
            addressParts.add(property.wunderbricks__Street_Name__c.trim());
        }
        if (String.isNotBlank(property.wunderbricks__Street_Number__c)) {
            addressParts.add(property.wunderbricks__Street_Number__c.trim());
        }

        String houseDetails = '';
        if (String.isNotBlank(property.wunderbricks__House_Letter__c)) {
            houseDetails += property.wunderbricks__House_Letter__c.trim();
        }
        if (String.isNotBlank(property.wunderbricks__House_Number_Addition__c)) {
            houseDetails += property.wunderbricks__House_Number_Addition__c.trim();
        }
        if (String.isNotBlank(houseDetails)) {
            addressParts.add(houseDetails);
        }

        String streetAddress = String.join(addressParts, ' ');

        List<String> locationParts = new List<String>();
        if (String.isNotBlank(property.wunderbricks__City__c)) {
            locationParts.add(property.wunderbricks__City__c.trim());
        }
        if (String.isNotBlank(property.wunderbricks__Country_Picklist__c)) {
            Map<String, String> picklistLabelByValue = CustomPdfUtils.getPicklistLabelByValue(
                wunderbricks__Property__c.SObjectType.getDescribe().getName(),
                wunderbricks__Property__c.wunderbricks__Country_Picklist__c.getDescribe().getName()
            );
            locationParts.add(picklistLabelByValue.get(property.wunderbricks__Country_Picklist__c));
        }

        List<String> fullAddressParts = new List<String>();
        if (String.isNotBlank(streetAddress)) {
            fullAddressParts.add(streetAddress);
        }
        if (!locationParts.isEmpty()) {
            fullAddressParts.add(String.join(locationParts, ', '));
        }

        return String.join(fullAddressParts, ', ');
    }
}
