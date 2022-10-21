public class counterTread extends Thread{

    @Override
    public void run() {
        while(Thread.currentThread().getThreadGroup().activeCount()>3) {
            System.out.println(Thread.currentThread().getThreadGroup().activeCount());
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }

    }
}
