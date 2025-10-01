/**
 * Created by Alonso Yocupicio on 9/30/2025.
 */
 public with sharing class recordJobController {
        public class JobDetail {
            @AuraEnabled
            public String recordId;
            @AuraEnabled
            public String jobDetails;
            @AuraEnabled
            public String jobStatus;
        }
    // Aura enabled required for apex to communicate with lwc
        @AuraEnabled        
        // Method that returns boolean and accepts id as parameter
        public static JobDetail getJobDetails(String recordId){
            String recordIdExpression = recordId + '%';
            List<SBQQ__RecordJob__c> theRecordJobs = [SELECT SBQQ__RecordId__c,  SBQQ__JobStatus__c, SBQQ__JobDetails__c   
            FROM SBQQ__RecordJob__c
            WHERE SBQQ__RecordId__c like: recordIdExpression
            and SBQQ__JobStatus__c not IN ('','Completed')
            order by CreatedDate desc
            LIMIT 1];
            if (theRecordJobs.size() > 0){
                String tmp1 = '';
                // SOQL query to return Primary Quotes with same the Opportunity Id
                tmp1 = removeJobDetailsTags(theRecordJobs[0].SBQQ__JobDetails__c);   
                tmp1 = removeErrorDetails(tmp1);
                JobDetail jd = new JobDetail();
                jd.recordId = theRecordJobs[0].SBQQ__RecordId__c;
                jd.jobDetails = tmp1;
                jd.jobStatus = theRecordJobs[0].SBQQ__JobStatus__c;
                return jd;           
            }
            else{
                return null; // If not Opportunity or Quote, return null
            }
        }
        // Method to clean and process the inputString
        private static String removeJobDetailsTags(String inputString) {
            if (inputString == null) {
                return '';
            }
            String removeTags = inputString;
            removeTags = removeTags.stripHtmlTags();
            // Clean up the combined string
            removeTags = removeTags.replaceAll('(?i)<\\/?div[*>]', '\n').replaceAll('(?i)<\\/?p[*>]', '\n').replaceAll('(?i)<\\/?li[*>]', '\n').replaceAll('(?i)<br?\\s*\\/?>', '\n').replaceAll('<[^>]+>', '').replaceAll('  ', ' ').trim();
            // Collapse multiple line breaks (any combination of CRLF or LF) into a single \n
            removeTags = removeTags.replaceAll('\\n+', '\n');    // Collapse multiple line breaks
            return removeTags;
        }
        // Method to clean error details
        private static String removeErrorDetails(String inputString) {
            if (inputString == null) {
                return '';
            }
            String removeDetails = inputString;
            // Clean up the error details string
            integer index = removeDetails.toUpperCase().indexOf('YOU CAN LOOK UP EXCEPTIONCODE VALUES IN THE SOAP API DEVELOPER GUIDE');
            removeDetails= (index != -1) ? removeDetails.substring(0,index).trim() : removeDetails.trim();
            return removeDetails;
        }
    }