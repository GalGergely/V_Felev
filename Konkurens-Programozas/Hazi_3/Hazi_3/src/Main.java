import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class Main {
    public static Runnable getTask(int n, ArrayList<Integer> l, boolean isSynchronised,boolean isOnebyOne, int finalI) {
        Runnable r = new Runnable() {
            @Override
            public void run() {
                for(int j = finalI; j<1000000; j=j+n) {
                    if (isSynchronised) {
                        synchronized (l) {
                            System.out.println(j);
                            l.add(j);
                        }
                    } else {
                        l.add(j);
                    }
                }
            }
        };
        return r;
    }
    public static void main(String[] args) {
        long t1=System.nanoTime();
        useThreads(10,true,false);
        long t2=System.nanoTime();
        System.out.println(t2-t1);
    }
    public static void useThreads(int n, boolean isSynchronised, boolean isOnebyOne) {
        ArrayList<Integer> l = new ArrayList<>();
        ExecutorService e = Executors.newFixedThreadPool(n);
        for (int i = 0; i < n; i++) {
            int finalI = i;
            e.execute(getTask(n,l,isSynchronised,isOnebyOne,finalI));
        }
        System.out.println(l.size());
    }
}


