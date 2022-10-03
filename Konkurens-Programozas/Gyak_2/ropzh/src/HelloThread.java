import java.io.PrintWriter;

public class HelloThread extends Thread{
    PrintWriter pw;
    public HelloThread(PrintWriter pw) {
        this.pw=pw;
    }

    public void run() {
        for(int i=0; i<10000; i++) {
            pw.print("hello");
        }

    };
}
