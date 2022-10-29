import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.TimeUnit;

// lab 04
public class ExecutorServiceTask {

    public static void main(String[] args) {
        withRunnable();
        withCallable();
    }

    public static int N_CLIENTS = 100_000;

    public static final /* note: final, an Object */ Object sumLoansLock = new Object();
    public static /* note: not final, not an Object */ int sumLoans = 0; // protected by `sumLoansLock`

    public static void withRunnable() {
        int[] clientLoans = new int[N_CLIENTS];

        ExecutorService exec = Executors.newFixedThreadPool(10);
        for (int i = 0; i < N_CLIENTS; i++) {

            final int ii = i;

            Runnable task = () -> {
                int loan = ThreadLocalRandom.current().nextInt(10);

                // TODO: protect access to `clientLoans`
                synchronized (clientLoans) {
                    clientLoans[ii] = loan;
                }

                try {
                    sumLoansLock.wait();
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
                sumLoans += loan;
                sumLoansLock.notifyAll();

            };

            exec.execute(task);
        }

        exec.shutdown();

        try {
            exec.awaitTermination(10,TimeUnit.DAYS);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }

        System.out.println(sumLoans);
        System.out.println(Arrays.stream(clientLoans).sum());

        assert sumLoans == Arrays.stream(clientLoans).sum();
    }


    public static void withCallable() {

        int[] clientLoans = new int[N_CLIENTS];
        ArrayList<Future<Integer>> l = new ArrayList<Future<Integer>>();
        ExecutorService exec = Executors.newFixedThreadPool(10);
        for (int i = 0; i < N_CLIENTS; i++) {

            Callable<Integer> c = new Callable<Integer>() {
                @Override
                public Integer call() throws Exception {
                    return 10;
                }
            };
            Future<Integer> future = exec.submit(c);
            l.add(future);
        }

        for (int i = 0; i < N_CLIENTS; i++) {
            Future<Integer> loanFuture = l.get(i);
            try {
                clientLoans[i] = loanFuture.get();
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            } catch (ExecutionException e) {
                throw new RuntimeException(e);
            }
        }

        exec.shutdown();

        try {
            exec.awaitTermination(10,TimeUnit.DAYS);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }

        System.out.println(sumLoans);
        System.out.println(Arrays.stream(clientLoans).sum());

        assert sumLoans == Arrays.stream(clientLoans).sum();
    }
}
