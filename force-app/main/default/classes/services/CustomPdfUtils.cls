public with sharing class CustomPdfUtils {
    public static String getFormattedDateStringWithSymbol(Date dateValue, String symbol) {
        if (dateValue == null) {
            return null;
        }
        String dayString = dateValue.day() < 10 ? '0' + dateValue.day() : '' + dateValue.day();
        String monthString = dateValue.month() < 10 ? '0' + dateValue.month() : '' + dateValue.month();
        return (dayString + '-' + monthString + '-' + dateValue.year()).replace('-', symbol);
    }

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
        Decimal helperValue = 1111.11;
        String helperFormatted = helperValue.format();
        String decimalSeparator = helperFormatted.substring(5, 6);
        String integerPart = decValue.setScale(scale).toPlainString().split('\\.')[0];
        String decimalPart = decValue.setScale(scale).toPlainString().split('\\.')[1];
        String integerFormatted = Integer.valueOf(integerPart).format();
        return integerFormatted + decimalSeparator + decimalPart;
    }

    public static Map<String, String> getPicklistLabelByValue(String sobj, String sObjectField) {
        Map<String, String> picklistLabelByValue = new Map<String, String>();
        Schema.SObjectField field = Schema.getGlobalDescribe().get(sobj).getDescribe().fields.getMap().get(sObjectField);
        for (Schema.PicklistEntry entry : field.getDescribe().getPicklistValues()) {
            picklistLabelByValue.put(entry.getValue(), entry.getLabel());
        }
        return picklistLabelByValue;
    }
}
