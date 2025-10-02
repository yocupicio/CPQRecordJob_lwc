# RecordJob_lwc

When enabling Dynamic Forms, Salesforce CPQ Managed Package Visualforce Pages, such as ContactSave and AmendContract, are not included on the Lightning Record Page Layout.

This is a lwc component to substitute these Visualforce component in that Lightning Record Page.

## How to Deploy

Connect Visual Sudio Code org browser to your Salesforce organization and deploy.

## Configure Your Ligning Record page

Create a Lightning Record Page for Contract and then go to Edit Page. Drag and drop the custom recordJob_lwc component above of the detail section.
![Configure Your Ligning Record page](https://github.com/yocupicio/CPQRecordJob_lwc/images/image1.jpg?raw=true)

## Purposes
Adding the RecordJob_lwc component to the page layout serves 3 purposes: 

- Displays the status of the queued amend/renewal apex job
- Provides any run-time exceptions/errors stemming from unsuccessful Amendment or Renewals
- Refreshes the record when the amend/renewal job is completed

![purposes](https://github.com/yocupicio/CPQRecordJob_lwc/images/image2.jpg?raw=true)

