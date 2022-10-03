import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        //part1();
        part2();
    }
     static void part2() {
        List<Integer> l = new ArrayList<>();
        Thread t1 = new Thread() {
            public void run() {
                for(int i=0; i<500000; i++) {
                    synchronized (l) {
                        l.add(i);
                    }
                }
            }
        };

        Thread t2 = new Thread() {
            public void run() {
                for(int i=0; i<500000; i++) {
                    synchronized (l) {
                        l.add(i);
                    }
                }
            }
        };
        t1.start();
        t2.start();
        try {
            t1.join();
            t2.join();
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }

        System.out.println(l.size());
    }

     static void part1(){
         PrintWriter pw = null;
         try {
             pw = new PrintWriter("output.txt");
         } catch (FileNotFoundException e) {
             throw new RuntimeException(e);
         }
         MyThread t = new MyThread(pw);
        t.start();
        Thread t2 = new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println("feladom");
            }
        });
        t2.start();
        Thread t3 = new Thread( () -> System.out.println("xd") );
        t3.start();
    }
}