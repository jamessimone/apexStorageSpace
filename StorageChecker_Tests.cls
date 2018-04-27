@isTest
private class StorageChecker_Tests {

    @isTest
    static void it_should_find_storage_space_if_html_matches() {
        StorageChecker.StorageSpace space = new StorageChecker(sampleHtml).getSpace();
        System.assertEquals(.20, space.AvailableGB);
        System.assertEquals(.0127, space.UsedGB);
        System.assertEquals(6, space.PercentUsed);
    }

    @isTest
    static void it_should_throw_exception_if_html_does_not_match() {
        try {
            new StorageChecker('blablabla').getSpace();
            System.assert(false, 'Should not make it here');
            //assert exceptions cannot be caught regularly - the test will fail if the StorageChecker call does not result in an exception'
        } catch(Exception ex) {
            System.assert(ex.getMessage().contains(StorageChecker.EX_MESSAGE));
        }
    }

    private static String sampleHtml = '<tr class=" dataRow even first" onblur="if (window.hiOff){hiOff(this);}" onfocus="if (window.hiOn){hiOn(this);}" onmouseout="if (window.hiOff){hiOff(this);}" onmouseover="if (window.hiOn){hiOn(this);}">'
	+ '<th scope="row" class=" dataCell  ">Data Storage</th>'
	+ '<td class=" dataCell  numericalColumn">200.0&nbsp;MB</td>'
	+ '<td class=" dataCell  numericalColumn">12.7&nbsp;MB</td>'
	+ '<td class=" dataCell  numericalColumn">6%</td>'
    +'</tr>';
}