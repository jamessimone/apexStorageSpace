public class StorageAlerterSchedulable extends AbstractSchedulable {
    public override void execute(SchedulableContext sc) {
        new StorageAlerter().validateSpace();
    }

    public abstract class AbstractSchedulable implements Schedulable {
        public abstract void execute(SchedulableContext sc);

        public AbstractSchedulable() {
            try {
                this.execute(null);
            } catch(Exception ex) {
                throw new ScheduledJobException(ex.getMessage());
            }
        }
    }

    public class ScheduledJobException extends Exception {}
}