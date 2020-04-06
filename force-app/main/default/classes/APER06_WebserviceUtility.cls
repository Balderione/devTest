/*
----------------------------------------------------------------------
-- - Name          : APER06_WebserviceUtility
-- - Author        : OLA
-- - Description   : Class for Web service methods (Get customMetadata, getToken ...)
-- Maintenance History:
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
-- 03-OCT-2018  OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
public class APER06_WebserviceUtility {

    /*  All EDG call out attributes */
    public static final String xp_salesforce_clientSecret;
    public static final String xp_salesforce_endpoint;
    public static final String xp_salesforce_clientId;
    public static final String xp_salesforce_requester;
    public static final Decimal xp_salesforce_Time_Out;
    public static final String currentDate = String.valueOf(datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''));

    /*
    * OLA
    * Nov 2018
    * Get the WS configuration from the custom Setting : CMER01_EDG_Webservice_Setting__mdt
    */

    public static CMER01_EDG_Webservice_Setting__mdt edgWsConfiguration {
        get {
            System.debug('edgWsConfiguration');
            if (edgWsConfiguration == null) {
                System.debug('edgWsConfiguration == null');
                try {
                    edgWsConfiguration = [Select xp_salesforce_clientId__c, xp_salesforce_clientSecret__c, xp_salesforce_url__c, xp_salesforce_requester__c, xp_salesforce_Time_Out__c,
                    sdx_xp_salesforce_clientId__c, sdx_xp_salesforce_clientSecret__c, sdx_xp_salesforce_url__c
                    from CMER01_EDG_Webservice_Setting__mdt
                    Where DeveloperName = : APER10_User_Management.userBU];

                } catch (Exception e) {
                    throw new CustomException(Label.LABS_SF_WS_SettingNotFilled);
                }
            }

            return edgWsConfiguration;
        }
        set;
    }

    static {

        if (runningInASandbox()) {
            System.debug('SANDBOX CALL EDG');
            if (String.isBlank(edgWsConfiguration.sdx_xp_salesforce_clientSecret__c) ||
                    String.isBlank(edgWsConfiguration.sdx_xp_salesforce_url__c) ||
                    String.isBlank(edgWsConfiguration.sdx_xp_salesforce_clientId__c) ||
                    String.isBlank(edgWsConfiguration.xp_salesforce_requester__c) ||
                    edgWsConfiguration.xp_salesforce_Time_Out__c == null) {

                throw new CustomException(Label.LABS_SF_WS_SettingNotFilled);

            } else {
                xp_salesforce_clientSecret = edgWsConfiguration.sdx_xp_salesforce_clientSecret__c;
                xp_salesforce_endpoint = edgWsConfiguration.sdx_xp_salesforce_url__c;
                xp_salesforce_clientId = edgWsConfiguration.sdx_xp_salesforce_clientId__c;
                xp_salesforce_requester = edgWsConfiguration.xp_salesforce_requester__c;
                xp_salesforce_Time_Out = edgWsConfiguration.xp_salesforce_Time_Out__c;
            }
        } else {
            System.debug('PRODUCTION CALL EDG');
            if (String.isBlank(edgWsConfiguration.xp_salesforce_clientSecret__c) ||
                    String.isBlank(edgWsConfiguration.xp_salesforce_url__c) ||
                    String.isBlank(edgWsConfiguration.xp_salesforce_clientId__c) ||
                    String.isBlank(edgWsConfiguration.xp_salesforce_requester__c) ||
                    edgWsConfiguration.xp_salesforce_Time_Out__c == null) {

                throw new CustomException(Label.LABS_SF_WS_SettingNotFilled);

            } else {
                xp_salesforce_clientSecret = edgWsConfiguration.xp_salesforce_clientSecret__c;
                xp_salesforce_endpoint = edgWsConfiguration.xp_salesforce_url__c;
                xp_salesforce_clientId = edgWsConfiguration.xp_salesforce_clientId__c;
                xp_salesforce_requester = edgWsConfiguration.xp_salesforce_requester__c;
                xp_salesforce_Time_Out = edgWsConfiguration.xp_salesforce_Time_Out__c;
            }
        }

    }

    public static Boolean runningInASandbox() {

        return [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
    }

    public static String getHmacToken(String url, String body) {

        // encoded uri
        String uri = (EncodingUtil.urlEncode(url, 'UTF-8')).toLowerCase();

        Blob hash;
        String paramvalue;

        if (String.isNotBlank(body)) {
            hash = Crypto.generateDigest('SHA-256', Blob.valueOf(body));
            paramvalue = EncodingUtil.convertToHex(hash);
        }

        System.debug('--- Input data to calculate hmac:');
        System.debug('--- uri: ' + uri);
        System.debug('--- hashed body: ' + paramvalue);
        System.debug('--- requester: ' + xp_salesforce_requester);
        System.debug('--- requestDate: ' + currentDate);

        // Authentication encoded MAC
        String rawHmac;
        if (String.isNotBlank(paramvalue)) {
            rawHmac = uri + '#' + paramvalue + '#' + xp_salesforce_requester + '#' + currentDate;
        } else {
            rawHmac = uri + '#' + xp_salesforce_requester + '#' + currentDate;
        }
        Blob encodedHmac = crypto.generateMac('HmacSHA256', Blob.valueOf(rawHmac), Blob.valueOf(xp_salesforce_clientSecret));
        String hmacToken = EncodingUtil.convertToHex(encodedHmac);
        System.debug('--- encoded hmacToken : ' + hmacToken);

        return hmacToken;
    }

    public static HttpRequest getHttpRequest(String endpoint, string method, String body, Integer timeOut) {

        String finalEndpoint = xp_salesforce_endpoint + endpoint;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(finalEndpoint);
        req.setMethod(method);
        // Prepare the header
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('X-Client-Id', xp_salesforce_clientId);
        req.setHeader('X-Requester', xp_salesforce_requester);
        req.setHeader('X-Request-Date', currentDate);
        req.setHeader('Authorization', getHmacToken(finalEndpoint, body));
        req.setHeader('X-Client-Secret', xp_salesforce_clientSecret);
        if (String.isNotBlank(body)) {
            System.debug('--- final JSON body : ' + body.replaceAll('\\s+', ''));
            req.setBody(body);
        }
        if (timeOut == null) {
            req.setTimeout(Integer.valueOf(xp_salesforce_Time_Out));
        } else {
            req.setTimeout(timeOut);
        }
        return req;
    }


    //description Custom error handling class
    public class CustomException extends Exception {}
}