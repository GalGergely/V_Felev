import java.util.ArrayList;

public class ThreadSafeMutableIntegerArray {
    private int[] intArray;
    private Object[] locks;

    public ThreadSafeMutableIntegerArray(int capacity) {
        this.intArray = new int[capacity];
        this.locks = new Object[capacity];
        for (int i = 0; i <capacity; i++) {
            this.locks[i]=new Object();
        }
    }

    public final synchronized int get(int index) throws InterruptedException {
        int get;
        this.locks[index].wait();
        get = this.intArray[index];
        this.locks[index].notifyAll();
        return get;
    }
    public final synchronized void set(int nv, int index) throws InterruptedException {
        this.locks[index].wait();
        this.intArray[index] = nv;
        this.locks[index].notifyAll();
    }

    public static void main(String[] args) {
        ArrayList<Thread> th = new ArrayList<>();
        ThreadSafeMutableIntegerArray ta = new ThreadSafeMutableIntegerArray(2);
        for (int i = 0; i < 10; i++) {
            Thread t;
            if(i % 2 ==0) {
                 t = new Thread() {
                    public void run() {
                        for (int j = 0; j < 10000; j++) {
                            try {
                                ta.set(j, 0);
                            } catch (InterruptedException e) {
                                throw new RuntimeException(e);
                            }

                        }
                    }
                };
            } else {
                t = new Thread() {
                    public void run() {
                        for (int j = 0; j < 10000; j++) {
                            try {
                                ta.set(j, 1);
                            } catch (InterruptedException e) {
                                throw new RuntimeException(e);
                            }

                        }
                    }
                };

            }
            th.add(t);
            t.start();
        }

    }
}
