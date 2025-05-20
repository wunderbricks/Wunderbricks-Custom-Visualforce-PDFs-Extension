public with sharing class CustomUtilityService {
    /**
     * Decimal.format() returns the string value with user locale but it removes trailing zeroes
     * 1111.00.format() => "1.111" - nl locale
     * This method adds separators respecting user locale and also keeps trailing zeroes in the decimal part
     * getFormattedDecimalString(1111.00) => "1.111,00" -- nl locale
     */
    public static String getFormattedDecimalString(Decimal decValue) {
        return getFormattedDecimalString(decValue, 2);
    }
    
    public static String getFormattedDecimalString(Decimal decValue, Integer scale) {
        if (decValue == null || scale == null) {
            return null;
        }
        if (scale < 1) {
            return decValue.setScale(scale).format();
        }

        // get decimal separator for the locale of the user
        Decimal helperValue = 1111.11;
        String helperFormatted = helperValue.format();
        String decimalSeparator = helperFormatted.substring(5,6);
        
        String integerPart = decValue.setScale(scale).toPlainString().split('\\.')[0];
        String decimalPart = decValue.setScale(scale).toPlainString().split('\\.')[1]; // setScale(0+).toPlainString will always have the decimal part
        String integerFormatted = Integer.valueOf(integerPart).format();

        return integerFormatted + decimalSeparator + decimalPart;
    }

    public static Schema.SObjectField getSObjectFieldByName(String sobj, String sObjectFieldName) {
        return Schema.getGlobalDescribe().get(sobj).getDescribe().fields.getMap().get(sObjectFieldName);
    }

    public static Map<String, String> getPicklistLabelByValue(String sobj, String sObjectField) {
        Map<String, String> picklistLabelByValue = new Map<String, String>();
        for (Schema.PicklistEntry loopEntry : getSObjectFieldByName(sobj, sObjectField).getDescribe().getPicklistValues()) {
            picklistLabelByValue.put(loopEntry.getValue(), loopEntry.getLabel());
        }
        return picklistLabelByValue;
    }
}