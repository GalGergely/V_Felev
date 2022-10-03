import java.io.PrintWriter;

public class ImplementsThreadWorld implements Runnable{
    private PrintWriter pw;

    public ImplementsThreadWorld(PrintWriter pw) {
        this.pw = pw;
    }

    @Override
    public void run() {
        for(int i=0; i<100; i++) {
            pw.print("world!\n");
        }
    }
}
