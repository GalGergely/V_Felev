import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Queue;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingDeque;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.Callable;

// lab 05
public class WaitNotify {
    private static final int CAPACITY = 3;
    private static ArrayList queue = new ArrayList<>();
    private static class Producer implements Runnable {
        @Override
        public void run() {
            for (int i = 0; i < 10_000; ++i) {
                System.out.println("Producing: " + i);
                synchronized (queue) {
                    while (queue.size() == CAPACITY) {
                        try {
                            queue.wait();
                        } catch (InterruptedException e) {
                            throw new RuntimeException(e);
                        }
                    }
                    queue.add(i);
                    queue.notifyAll();
                }
            }
            System.out.println("Stop producing.");
        }
    }

    private static class Consumer implements Runnable {

        @Override
        public void run() {
            while (true) {
                try {
                    synchronized (queue) {
                        while (queue.isEmpty()) {
                            queue.wait();
                        }
                        Object num = queue.remove(0);
                        queue.notifyAll();
                        System.out.println("Consuming: " + num);
                    }
                    Thread.sleep(1);
                } catch (InterruptedException e) {
                    break;
                }
            }
            System.out.println("Stop consuming.");
        }

    }

    private static class Observer implements Runnable {
        @Override
        public void run() {
            while (true) {
                try {
                    Thread.sleep(2);
                } catch (InterruptedException e) {
                    break;
                }
                StringBuilder sb = new StringBuilder("Snapshot: ");
                for (Object num : queue) {
                    sb.append(num).append(" ");
                }
                System.out.println(sb);
            }
            System.out.println("Stop observing.");
        }
    }

    public static void main(String[] args) {
        Thread producer = new Thread(new Producer());
        Thread consumer = new Thread(new Consumer());
        Thread observer = new Thread(new Observer());

        producer.start();
        consumer.start();
        observer.start();

        try {
            producer.join();
        } catch (InterruptedException ignored) {}

        observer.interrupt();

        try {
            Thread.sleep(500);
        } catch (InterruptedException ignored) {}

        consumer.interrupt();
    }
}