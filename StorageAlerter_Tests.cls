@isTest
private class StorageAlerter_Tests {
    private static Decimal availableGB;
    private static Decimal usedGB;
    private static Integer percentUsed;

    @isTest
    static void it_should_send_email_if_space_running_out() {
        percentUsed = StorageAlerter.allowedSpaceRemainingBeforeAlert + 1;
        availableGB = 5;
        usedGB = 90;

        Test.startTest(); //force email "send"
        Integer emailbefore = Limits.getEmailInvocations();
        new StorageAlerter(new StorageCheckerMock()).validateSpace();
        System.assertNotEquals(emailbefore, Limits.getEmailInvocations());
        Test.stopTest();
    }


    private class StorageCheckerMock extends StorageChecker {
        public StorageCheckerMock() {
        //have to override the correct constructor, otherwise the getContent method is called, which is not allowed in tests
            super('');
        }

        public override StorageChecker.StorageSpace getSpace() {
            StorageChecker.StorageSpace space = new StorageChecker.StorageSpace();
            space.AvailableGB = availableGB;
            space.UsedGB = usedGB;
            space.PercentUsed = percentUsed;
            return space;
        }
    }
}