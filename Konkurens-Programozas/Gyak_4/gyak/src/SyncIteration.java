import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.*;

// lab 04
public class SyncIteration {

    public static void main(String[] args) {
        // TODO: uncomment the ones that you want to run

        listIterate(false, false);
        listIterate(true, false);
//
        listIterate(true, true);
        listIterate(false, true);
//
//        mapIterate(false);
//        mapIterate(true);
    }

    private static final int ELEM_SIZE = 100_000;

    public static void listIterate(boolean syncedList, boolean synchronizeIterate) {

        List<Integer> list = syncedList ? Collections.synchronizedList(new ArrayList<>()) : new ArrayList<>();

        for (int i = 0; i < ELEM_SIZE; i++) {
            list.add(i);
        }

        Thread t1 = new Thread(() -> {
            for (int i = ELEM_SIZE; i < 2 * ELEM_SIZE; i++) {
                list.add(i);
            }
        });

        Thread t2 = new Thread(() -> {
            if (synchronizeIterate) {
                syncIterate(list);
            } else {
                nonSyncIterate(list);
            }
        });
        t1.start();
        t2.start();
        try {
            t1.join();
            t2.join();
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }

        System.out.println("\nlist size: " + list.size());
    }

    public static void nonSyncIterate(Collection<Integer> ds) {
        // TODO: get the iterator for `ds`

        try (var pw = new PrintWriter("out.txt")) {
            // TODO: iterate through the elements and print them using `pw.println`
        } catch (FileNotFoundException e) {
            throw new RuntimeException(e);
        }
    }

    public static void syncIterate(Collection<Integer> ds) {
        // TODO: call `nonSyncIterate` and protect it via `ds`
    }

    public static void mapIterate(boolean useConcurrentMap) {
        Map<Integer, Integer> map = null; // TODO: create a *synchronized* or *concurrent* map (based on `useConcurrentMap`)
        for (int i = 0; i < ELEM_SIZE; i++) {
            map.put(i, i);
        }

        Thread t1 = new Thread(() -> {
            for (int i = ELEM_SIZE; i < 2 * ELEM_SIZE; i++) {
                map.put(i, i);
            }
        });

        Thread t2 = new Thread(() -> {
            syncIterate(map.keySet());
        });

        // TODO: start t1, t2

        // TODO: wait for t1, t2 to stop

        System.out.println("\nmap size:" + map.size());
    }
}
