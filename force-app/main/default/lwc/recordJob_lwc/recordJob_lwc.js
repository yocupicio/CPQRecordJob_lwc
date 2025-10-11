// Added api (for recordid and track for the record parameter)
import {LightningElement, api, track, wire } from 'lwc';
import getJobDetails from '@salesforce/apex/recordJobController.getJobDetails';
import { loadStyle } from 'lightning/platformResourceLoader';
import myStyles from '@salesforce/resourceUrl/sbqq__sb';
// import the refresh event
import { RefreshEvent } from "lightning/refresh";
export default class RecordJob_lwc extends LightningElement {  
    // recordId will be passed from the record page where this component is added
    @api recordId;
    @api invertVisibilityExpression = false;
    @track linkRichText;
    @track linkId;
    @track boolVisible = false; 
    @track boolVisible2 = false; 
    @track operation = ''; 
    @track status = ''; 
    @track richTextMessage ='';
    intervalId;
    originalStatusInProgressQueued = false;
    connectedCallback() {
        if (this.recordId === undefined || this.recordId === null || this.recordId === '') {
            this.linkRichText = richTextMessage;
            this.boolVisible = true;
        }
        else {
            console.log("====RecordJob_lwc connectedCallback:recordId=====", this.recordId);
            this.refreshData();
            console.log("====RecordJob_lwc myStyles");
            loadStyle(this, myStyles)
            .then(result => {
                console.log("====RecordJob_lwc myStyles:loaded!=====");
            })
            .catch(reason => {
                 console.log('====RecordJob_lwc myStyles reason:', reason);
            });
        }        
    }
    disconnectedCallback() {
        if(this.intervalId) {
            clearTimeout(this.intervalId);
            this.intervalId = null;
        }
    }
    clearTheInterval(){
        if (this.intervalId !== null){
            clearTimeout(this.intervalId);
            this.intervalId = null;
        }
    }    
    delayFunction() {
        // Stop when navigated away from the record page
        if(!location.href.includes(this.recordId)) {
            this.clearTheInterval();
            return;
        }
        this.clearTheInterval();
        console.log('==== RecordJob_lwc originalStatusInProgressQueued:', this.originalStatusInProgressQueued, '======');
        this.refreshData();
    }    
    refreshData() {
        getJobDetails({recordId:this.recordId})
        .then(result=>{
            // Replace all occurrences (case-sensitive)            
            this.linkRichText = result !== null? result.jobDetails.replace(/\\n/g, '<br/>') : '';
            this.boolVisible = (result !== null && result.jobDetails !== ''?!this.invertVisibilityExpression:this.invertVisibilityExpression);
            let jobStatusText = result !== null? result.jobStatus : '';
            if (jobStatusText !== 'In Progress' && jobStatusText !== 'Queued'){
                this.clearTheInterval();
                this.boolVisible2 = false;
                // fire the RefreshEvent
                if (this.originalStatusInProgressQueued){
                    this.dispatchEvent(new RefreshEvent());
                    this.originalStatusInProgressQueued =  false;
                }
            }
            else if (result !== null && (jobStatusText === 'In Progress' || jobStatusText === 'Queued')){ 
                this.originalStatusInProgressQueued = true;                    
                this.boolVisible2 = true;
                let operation_status=result.recordId.split('::');
                this.operation = '';
                switch (result.recordId.length> 1) {
                    case operation_status[1] === 'RenewContract':   
                        this.operation = 'Renewing...';                
                        break;
                    case operation_status[1]  === 'AmendContract':  
                        this.operation = 'Amending...';
                        break;
                    case operation_status[1]  === 'CreateContract':
                        this.operation = 'Creating...';  
                        break;                        
                }
                this.status = jobStatusText;
                this.linkId = '/' + this.recordId; 
            }
            this.intervalId = setTimeout(this.delayFunction.bind(this), 3000);   
        })
        .catch(error=>{
            // if error, catch it into the tracking variable
            console.log('====RecordJob_lwc getJobDetails:error=====', error);
        });
   }
}