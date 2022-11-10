package hf3.Hazi_3.src;

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

    public final int get(int index) throws InterruptedException {
        synchronized (locks[index]) {
            return intArray[index];
        }
    }
    public final void set(int nv, int index) throws InterruptedException {
        synchronized (locks[index]) {
            intArray[index] = nv;
        }
    }

    public static void main(String[] args) {
        ArrayList<Thread> th = new ArrayList<>();
        ThreadSafeMutableIntegerArray ta = new ThreadSafeMutableIntegerArray(2);
        for (int i = 0; i < 10; i++) {
            Thread t;
            if(i % 2 == 0) {
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
        try {
            System.out.println(ta.get(0)+" "+ta.get(1));
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }
}
