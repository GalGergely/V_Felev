import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class Main {


    public static Long doShit(Map meetings, int n, int x) {
        Long start = System.nanoTime();
        for (int i = 0; i < n; i++) {
            class XDDDD extends Thread {
                @Override
                public void run() {
                    for (int i = 0; i < x; ++i) {
                            meetings.put(i, x);
                    }
                }
            }
            XDDDD asd = new XDDDD();
            asd.start();
        }
        System.out.println(meetings);
        long finish = System.nanoTime();
        return finish-start;
    }
    public static void main(String[] args) {
        Map<Integer, Integer> meetings = Collections.synchronizedMap(new HashMap<Integer, Integer>());
        Map<Integer, Integer> meetings2 = new ConcurrentHashMap<Integer, Integer>();
        System.out.println(doShit(meetings, 10,10));
        System.out.println(doShit(meetings2, 10,10));
        System.out.println(doShit(meetings, 1000,1000));
        System.out.println(doShit(meetings2, 1000,1000));
        
    }
}