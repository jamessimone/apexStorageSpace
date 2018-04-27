# apexStorageSpace
Find out how much storage space is left in your org

To be clear - the included apex classes work by crawling the existing storage space page that exists today.  This functionality WILL break if Salesforce ever changes the html elements making up the page.  That being said, if storage space is tight in your org and you would prefer to be notified prior to running out of space, until Salesforce introduces programmatic metadata methods for retrieving this information, you can use the included classes to schedule a job alerting you.
