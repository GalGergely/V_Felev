import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class Main {
    public static Runnable doShit(int n, List<Integer> l, boolean isInSync, boolean isInOrder, int finalI) {
        Runnable ret = new Runnable() {
            @Override
            public void run() {
                int i = finalI;
                while (i <= 100) {
                    if (isInSync) {
                        if (isInOrder) {
                            if (i % n == finalI) {
                                if (l.size() == 0) {
                                    synchronized (l) {
                                        l.add(i);
                                        i = i + n;
                                    }
                                } else {
                                    if (l.get(l.size() - 1) == i - 1) {
                                        synchronized (l) {
                                            l.add(i);
                                            i = i + n;
                                        }
                                    }
                                }
                            }
                        } else {
                            if (i % n == finalI) {
                                synchronized (l) {
                                    l.add(i);
                                    i = i + n;
                                }
                            }
                        }
                    } else {
                        if (i % n == finalI) {
                            l.add(i);
                            i = i + n;
                        }
                    }
                }
            }
        };
        return ret;
    }
    public static void useThreads(int n, boolean b1, boolean b2) {
        List<Integer> l = new ArrayList<>();
        ExecutorService e = Executors.newFixedThreadPool(n);
        for (int i = 0; i < n; i++) {
            final int finalI = i;
            e.execute(doShit(n, l, b1, b2, finalI));
        }
        e.shutdown();

    }
    public static void main(String[] args) throws InterruptedException {
        int n = 3;
        long start = System.nanoTime();
        useThreads(n,true,true);
        long end = System.nanoTime();
        System.out.println(end-start);

        start = System.nanoTime();
        useThreads(n,true,false);
        end = System.nanoTime();
        System.out.println(end-start);

        start = System.nanoTime();
        useThreads(n,false,false);
        end = System.nanoTime();
        System.out.println(end-start);
    }
}


