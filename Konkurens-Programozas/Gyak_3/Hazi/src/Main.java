import java.util.ArrayList;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        //single();
        //ten();
        counterTread ct = new counterTread();
        MyThread mt1 = new MyThread();
        MyThread mt2 = new MyThread();
        MyThread mt3 = new MyThread();
        MyThread mt4 = new MyThread();
        MyThread mt5 = new MyThread();
        MyThread mt6 = new MyThread();
        MyThread mt7 = new MyThread();
        MyThread mt8 = new MyThread();
        MyThread mt9 = new MyThread();
        MyThread mt10 = new MyThread();
        ct.start();
        mt1.start();
        mt2.start();
        mt3.start();
        mt4.start();
        mt5.start();
        mt6.start();
        mt7.start();
        mt8.start();
        mt9.start();
        mt10.start();
        try {
            ct.join();
            mt1.join();
            mt2.join();
            mt3.join();
            mt4.join();
            mt5.join();
            mt6.join();
            mt7.join();
            mt8.join();
            mt9.join();
            mt10.join();
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }

    }
    static void single() {
        long startTime = System.nanoTime();
        Thread t1 = new Thread() {
            public void run() {
                long sum = 0;
                for(int i=0; i<1000000000; i++) {
                    sum=sum+i;
                }
                System.out.println(sum);
            }
        };
        t1.start();
        try {
            t1.join();
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        long finishTime = System.nanoTime();
        System.out.println(finishTime-startTime);
    }
    static void ten() {
        final long[] l = {0};
        Thread th1 = new Thread() {
            public void run() {
                long summ=0;
                for(int i=100000000; i<200000000; i++) {
                    summ=summ+i;
                }
                synchronized (l) {
                    l[0] +=summ;
                }
            }
        };
        Thread th2 = new Thread() {
            public void run() {
                long summ=0;
                for(int i=200000000; i<300000000; i++) {
                    summ=summ+i;
                }
                synchronized (l) {
                    l[0] +=summ;
                }
            }
        };
        Thread th3 = new Thread() {
            public void run() {
                long summ=0;
                for(int i=300000000; i<400000000; i++) {
                    summ=summ+i;
                }
                synchronized (l) {
                    l[0] +=summ;
                }
            }
        };
        Thread th4 = new Thread() {
            public void run() {
                long summ=0;
                for(int i=0; i<100000000; i++) {
                    summ=summ+i;
                }
                synchronized (l) {
                    l[0] +=summ;
                }
            }
        };
        Thread th5 = new Thread() {
            public void run() {
                long summ=0;
                for(int i=400000000; i<500000000; i++) {
                    summ=summ+i;
                }
                synchronized (l) {
                    l[0] +=summ;
                }
            }
        };
        Thread th6 = new Thread() {
            public void run() {
                long summ=0;
                for(int i=500000000; i<600000000; i++) {
                    summ=summ+i;
                }
                synchronized (l) {
                    l[0] +=summ;
                }
            }
        };
        Thread th7 = new Thread() {
            public void run() {
                long summ=0;
                for(int i=600000000; i<700000000; i++) {
                    summ=summ+i;
                }
                synchronized (l) {
                    l[0] +=summ;
                }
            }
        };
        Thread th8 = new Thread() {
            public void run() {
                long summ=0;
                for(int i=700000000; i<800000000; i++) {
                    summ=summ+i;
                }
                synchronized (l) {
                    l[0] +=summ;
                }
            }
        };
        Thread th9 = new Thread() {
            public void run() {
                long summ=0;
                for(int i=800000000; i<900000000; i++) {
                    summ=summ+i;
                }
                synchronized (l) {
                    l[0] +=summ;
                }
            }
        };
        Thread th10 = new Thread() {
            public void run() {
                long summ=0;
                for(int i=900000000; i<1000000000; i++) {
                    summ=summ+i;
                }
                synchronized (l) {
                    l[0] +=summ;
                }
            }
        };
        long startTime = System.nanoTime();
        th1.start();
        th2.start();
        th3.start();
        th4.start();
        th5.start();
        th6.start();
        th7.start();
        th8.start();
        th9.start();
        th10.start();
        try {
            th1.join();
            th2.join();
            th3.join();
            th4.join();
            th5.join();
            th6.join();
            th7.join();
            th8.join();
            th9.join();
            th10.join();
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        System.out.println(l[0]);
        long finishTime = System.nanoTime();
        System.out.println(finishTime-startTime);
    }
}