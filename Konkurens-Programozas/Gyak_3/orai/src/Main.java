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
                    for (int j = 0; j <10000 ; j++) {
                        System.out.println(tsmi.addAndGet(j));
                    }
                }
            };
            t.start();
            ts[i]=t;
        }
        int[] biggggg = new int[]{Integer.MAX_VALUE};
        ExecutorService ex = Executors.newFixedThreadPool(10);
        for (int i = 0; i <1000000000; i++) {
            ex.submit(()->{
                biggggg[0]-= ThreadLocalRandom.current().nextInt(10);
            });
        }
        ex.shutdown();
        try {
            ex.awaitTermination(10000, TimeUnit.MILLISECONDS);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }


    }
}