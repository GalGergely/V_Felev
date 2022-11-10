/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package hf3.pkg2;

/**
 *
 * @author pbali
 */
public class Hf32 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        ThreadSafeMutableIntArray tsmia = new ThreadSafeMutableIntArray(2);
        for (int i = 1; i <= 10; i++) {
            if (i % 2 == 0) {
                Thread t = new Thread(() -> {
                    while(tsmia.get(0) < 10000000) {
                        tsmia.set(0, tsmia.get(0) + 1);
                    }
                });
                t.start();
                try {
                    t.join();
                } catch (InterruptedException ex) {

                }
            } else {
                Thread t = new Thread(() -> {
                     while(tsmia.get(1) < 10000000) {
                        tsmia.set(1, tsmia.get(1) + 1);
                    }
                });
                t.start();
                try {
                    t.join();
                } catch (InterruptedException ex) {

                }
            }
        }
        System.out.println(tsmia.get(0)+" "+tsmia.get(1));
    }

}
