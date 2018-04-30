public virtual class StorageChecker {
    private final static String basePath = Url.getSalesforceBaseUrl().toExternalForm();
    private final static String orgStoragePath = '/setup/org/orgstorageusage.jsp?id=' + UserInfo.getOrganizationId();
    private final static String dataTableHeader = '<th scope="row" class=" dataCell  ">Data Storage</th>';
    private final static Integer dataStorageTableLength = 221;
    private final String html;

    public final static String EX_MESSAGE = 'Aborting, page has changed';

    public StorageChecker() {
        //could also parse new PageReference(basePath + '/setup/systemOverview.apexp?') if this ever breaks?
        this(new PageReference(basePath + orgStoragePath).getContent().toString());
    }

    @testVisible
    private StorageChecker(String html) {
        this.html = html;
        this.getSpace();
    }

    public virtual StorageSpace getSpace() {
        Integer storageIndex = this.html.indexOf(dataTableHeader);
         if(storageIndex == -1) {
            throw new StorageCheckOperationException(EX_MESSAGE);
        }

        return this.getStorageSpace(storageIndex);
    }

    private StorageSpace getStorageSpace(Integer storageIndex) {
        Integer endBoundary = dataStorageTableLength + storageIndex > html.length() ? html.length() : dataStorageTableLength;
        String subString = this.html.substring(storageIndex, endBoundary);
        String[] tableCells = subString.split('<td class="');

        StorageSpace space = new StorageSpace();
        for(Integer i = 0; i < tableCells.size(); i++) {
            String tableCell = tableCells[i];
            if(i == 0) continue; //just the label
            else if(i == 1) {
                space.AvailableGB = Decimal.valueOf(this.getSpace(tableCell));
            }
            else if(i == 2) {
                space.UsedGB = Decimal.valueOf(this.getSpace(tableCell));
            }
            else if(i == 3) {
                space.PercentUsed = Integer.valueOf(this.getSpace(tableCell));
            }
        }

        return space;
    }

    private String getSpace(String stringInQuestion) {
        Matcher matcher = Pattern.compile('\\d+\\.\\d+').matcher(stringInQuestion);
        String val = '0';

        if(matcher.find()) {
            //it's a decimal
            String byteDelim = stringInQuestion.contains('GB') ? 'GB' : 'MB';
            Decimal amount = Decimal.valueOf(matcher.group());
            if(byteDelim == 'MB') {
                amount = amount.divide(1000.00, 4); //to 4 decimal places
            }
            val = String.valueOf(amount);
        } else {
            //try to find an integer
            Matcher m = Pattern.compile('\\d+').matcher(stringInQuestion);
            if(m.find()) {
                val = String.valueOf(m.group());
            }
        }

        return val;
    }

    public class StorageCheckOperationException extends Exception {}

    public class StorageSpace {
        public Decimal AvailableGB { get; set; }
        public Decimal UsedGB { get; set; }
        public Integer PercentUsed { get; set; }
    }
}