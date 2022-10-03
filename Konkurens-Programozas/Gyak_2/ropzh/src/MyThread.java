import java.io.PrintWriter;

public class MyThread extends Thread {
    PrintWriter pw;
    public MyThread(PrintWriter pw) {
        this.pw=pw;

    }
    public void normalRun(){
        HelloThread h = new HelloThread(pw);
        WorldThread w = new WorldThread(pw);
        h.start();
        w.start();
    }
    public void implementsRun() {
        ImplementsThreadHello hi = new ImplementsThreadHello(pw);
        ImplementsThreadWorld wi = new ImplementsThreadWorld(pw);
        Thread t1 = new Thread(hi);
        t1.start();
        Thread t2 = new Thread(wi);
        t2.start();
    }

    public void run() {
        //normalRun();
        implementsRun();
    };

}
