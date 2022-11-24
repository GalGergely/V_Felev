import java.util.*;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;

public class FieldRace {
    static int PLAYER_COUNT = 10;
    static int CHECKPOINT_COUNT = 3;
    static AtomicBoolean isOn = new AtomicBoolean(true);
    static ConcurrentHashMap<Integer,Integer> scores = new ConcurrentHashMap<>();
    static AtomicInteger[] checkpointScores = new AtomicInteger[PLAYER_COUNT];
    static List<ArrayBlockingQueue<AtomicInteger>> checkpointQueues = Collections.synchronizedList(new ArrayList<>(CHECKPOINT_COUNT));


    public static void setup() {
        for (int i = 0; i < checkpointScores.length; i++) {
            checkpointScores[i] = new AtomicInteger(0);
        }
        for (int i = 0; i < CHECKPOINT_COUNT ; i++) {
            checkpointQueues.add(new ArrayBlockingQueue<AtomicInteger>(100));
        }
        for (int i = 0; i < PLAYER_COUNT ; i++) {
            scores.put(i, 0);
        }
    }

    public static void main(String[] args) {
        setup();
        class Observer implements Runnable {
            @Override
            public void run() {
                while (isOn.get()) {
                    try {
                        Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        break;
                    }
                    printScores();
                }
            }
        }

        class Consumer implements Runnable {
            private int number;
            public Consumer(int n) {
                this.number = n;
            }
            @Override
            public void run() {
                while (isOn.get()) {
                    AtomicInteger num = null;
                    while(num==null) {
                        try {
                            num = checkpointQueues.get(number).poll(2, TimeUnit.SECONDS);
                        } catch (InterruptedException e) {
                            throw new RuntimeException(e);
                        }
                    }
                    Random r = new Random();
                    num.set(r.nextInt(100-10)+10);
                    //System.out.println(number+". consumer belevertem egy " + num + "-est");
                    synchronized (checkpointQueues.get(number)){
                        checkpointQueues.get(number).notifyAll();
                    }
                }
            }
        }

        class Producer implements Runnable {
            private int number;
            public Producer(int number) {
                this.number= number;
            }
            @Override
            public void run() {
                while(isOn.get()) {
                    Random r = new Random();
                    int randomCheckpoint = r.nextInt(CHECKPOINT_COUNT);
                    int randomSleepTime = r.nextInt(2000-500) + 500;
                    try {
                        Thread.sleep(randomSleepTime);
                    } catch (InterruptedException e) {
                        throw new RuntimeException(e);
                    }
                    try {
                        checkpointQueues.get(randomCheckpoint).put(checkpointScores[number]);
                        //System.out.println("írtam "+randomCheckpoint+"-nak "+checkpointQueues.get(randomCheckpoint));
                    } catch (InterruptedException e) {
                        throw new RuntimeException(e);
                    }
                    while(checkpointScores[number].get() == 0){
                        try {
                            synchronized (checkpointScores[number]){
                                checkpointScores[number].wait(3000);

                            }
                        } catch (InterruptedException e) {
                            throw new RuntimeException(e);
                        }
                    }
                    System.out.println("Player "+number+" got "+checkpointScores[number]+" points at checkpoint "+randomCheckpoint);
                    scores.replace(number, (scores.get(number) + checkpointScores[number].get()));
                    checkpointScores[number].set(0);
                }
            }
        }

        ExecutorService ex = Executors.newFixedThreadPool(PLAYER_COUNT + CHECKPOINT_COUNT + 1);
        if(isOn.get()){
            ex.submit(new Observer());
            for (int i = 0; i < PLAYER_COUNT; i++) {
                ex.submit(new Producer(i));
            }
            for (int i = 0; i < CHECKPOINT_COUNT; i++) {
                ex.submit(new Consumer(i));
            }
            try {
                Thread.sleep(10000);
                isOn.set(false);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            try {
                ex.awaitTermination(3, TimeUnit.SECONDS);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            ex.shutdownNow();
            printScores();
        }


    }

    private static void printScores() {
        List<Integer> values = new ArrayList<>(scores.keySet());
        Collections.sort(values, new Comparator<Integer>() {
            public int compare(Integer a, Integer b) {
                return scores.get(b) - scores.get(a);
            }
        });
        System.out.print("Scores: [");
        int cntr = 0;
        for(Integer val : values) {
            System.out.print(val + "=" + scores.get(val));
            if(cntr < PLAYER_COUNT-1){
                System.out.print(", ");
            }
            cntr++;
        }
        System.out.println("]");
    }
}
