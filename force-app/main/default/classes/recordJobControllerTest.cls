@isTest public class recordJobControllerTest {
    public static SBQQ__RecordJob__c rjob;
    public static String jobDetails = 'Test Job Details';
    public static String recordId = '800TR00000iix4fYAA';
    private static void Initialize(){
        rjob = new SBQQ__RecordJob__c(
            SBQQ__RecordId__c=recordId+'::RenewContract',
            SBQQ__JobDetails__c='<html><head><style>.class1{color:red;}</style></head><body><div>' + jobDetails + '</div></body></html>',
            SBQQ__JobStatus__c='Failed;'
        );
        insert rjob;
    }
    @isTest static void getJobDetailsTest(){ 
        Initialize();
        Test.startTest();   
        try{                 
            recordJobController.JobDetail rjd = recordJobController.getJobDetails(recordId);
            if (rjd.jobDetails == jobDetails)            
                system.assert(true, 'getJobDetailsTest PASSED: Jb Details Matched');
            else {
                system.assert(false, 'getJobDetailsTest FAILED:' + rjd.jobDetails + ' did not match ' + jobDetails);
            }
        }
        catch(Exception e)
        {
            String message = e.getMessage();
            system.Assert(false, 'getJobDetailsTest FAILED: ' + message);
        }
        Test.stopTest();
    }
}