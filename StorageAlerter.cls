public class StorageAlerter {
    private final StorageChecker checker;
    private final String SUBJECT = 'Storage space nearing full: {0} GB used out of {1}';

    public static final Integer allowedSpaceRemainingBeforeAlert = 96; //ASSIGN THE % NUMBER HERE.
    // WE USE A CUSTOM SETTING TO DYNAMICALLY SET THIS VALUE,
    //BUT YOU CAN HARD CODE IT IF YOU WOULD LIKE.

    public StorageAlerter() {
        this(new StorageChecker());
    }

    @testVisible //check StorageAlerter_Tests.cls to see why this constructor is necessary
    private StorageAlerter(StorageChecker checker) {
        this.checker = checker;
    }

    public void validateSpace() {
        StorageChecker.StorageSpace spaceLeft = this.checker.getSpace();
        if(spaceLeft.PercentUsed >= allowedSpaceRemainingBeforeAlert) {
            this.sendEmail(spaceLeft);
        }
    }

    private void sendEmail(StorageChecker.StorageSpace spaceLeft) {
        String EMAIL_ADDRESS_TO_SEND_ALERT_TO = 'sampleEmail@gmail.com'; //ASSIGN THE EMAIL YOU WANT THE ALERT TO BE SENT TO HERE.
        //WE USE A CACHED "SYSTEM" USER THAT HAS A SHARED DISTRIBUTION LIST AS ITS EMAIL, BUT YOU CAN HARD CODE THE VALUE
        //IF THAT'S EASIER.
        Messaging.SingleEmailMessage mail = this.getEmail(spaceLeft, EMAIL_ADDRESS_TO_SEND_ALERT_TO);
        Messaging.sendEmail(new List<Messaging.Email>{ mail });
    }

    private Messaging.SingleEmailMessage getEmail(StorageChecker.StorageSpace spaceLeft, String toEmail) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject(String.format(
            SUBJECT,
            new List<String>{ spaceLeft.UsedGB.toPlainString(), spaceLeft.AvailableGB.toPlainString() }
        ));
        mail.setEmailPriority('Highest');
        mail.setPlainTextBody('Sound the alarm! ' + spaceLeft.PercentUsed + '% of space is already used up');
        mail.setToAddresses(new List<String>{ toEmail });
        return mail;
    }
}