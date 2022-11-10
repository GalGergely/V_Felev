/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package hf3;

import java.util.ArrayList;

/**
 *
 * @author pbali
 */
public class Hf3 {

    static ArrayList l = new ArrayList<Integer>();

    public static void main(String[] args) {
        long startTime = System.nanoTime();
        useThreads(4, true, false);
        System.out.println(l.size());
        long t1 = System.nanoTime();
        System.out.println(t1 - startTime);
        l.clear();
        useThreads(7, false, false);
        System.out.println(l.size());
        long t2 = System.nanoTime();
        System.out.println(t2 - t1);
        l.clear();
        useThreads(5, true, true);
        System.out.println(l.size());
        long t3 = System.nanoTime();
        System.out.println(t3 - t2);
        l.clear();
        useThreads(7, false, true);
        System.out.println(l.size());
        long t4 = System.nanoTime();
        System.out.println(t4 - t3);
        l.clear();
    }

    static void useThreads(int n, boolean isSync, boolean sort) {
        for (int i = 1; i <= n; i++) {
            Thread t = new Thread(fillList(i, n, isSync, sort));
            t.start();
            try {
                t.join();
            } catch (Exception ex) {

            }
        }
    }

    static Runnable fillList(int n, int plus, boolean a, boolean b) {
        Runnable r = new Runnable() {
            @Override
            public void run() {
                if (a) {
                    if (b) {
                        for (int i = n; i <= 1000000; i += plus) {
                            synchronized (l) {
                                if (l.size() > 0) {
                                    if (i != (int) l.get(l.size() - 1)) {
                                        l.add(i);
                                    }
                                } else {
                                    l.add(i);
                                }
                            }
                        }
                    } else {
                        for (int i = n; i <= 1000000; i += plus) {
                            synchronized (l) {
                                l.add(i);
                            }
                        }
                    }
                } else {
                    if (b) {
                        for (int i = n; i <= 1000000; i += plus) {
                            if (l.size() > 0) {
                                if (i != (int) l.get(l.size() - 1)) {
                                    l.add(i);
                                }
                            } else {
                                l.add(i);
                            }
                        }
                    } else {
                        for (int i = n; i <= 1000000; i += plus) {
                            l.add(i);
                        }
                    }
                }
            }
        };
        return r;
    }

}
