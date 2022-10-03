import java.io.PrintWriter;

public class ImplementsThreadHello implements Runnable{
    private PrintWriter pw;

    public ImplementsThreadHello(PrintWriter pw) {
        this.pw = pw;
    }

    @Override
    public void run() {
        for(int i=0; i<100; i++) {
            pw.print("Hello\n");
        }
    }
}
