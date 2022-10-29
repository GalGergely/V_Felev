import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.TimeUnit;

public class Main {
    public static void main(String[] args) {
        Thread[] ts = new Thread[10];
        ThreadSafeMutableInteger tsmi = new ThreadSafeMutableInteger(1);
        for (int i = 0; i < 10; i++) {
            Thread t = new Thread() {
                public void run() {
                    for (int j = 0; j <10 ; j++) {
                        System.out.println(tsmi.getAndIncrement());
                    }
                }
            };
            t.start();
            ts[i]=t;
        }
        for (int i = 0; i < 10; i++) {
            try {
                ts[i].join();
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }


    }
}