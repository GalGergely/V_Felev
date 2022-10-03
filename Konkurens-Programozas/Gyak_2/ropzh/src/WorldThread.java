import java.io.PrintWriter;

public class WorldThread extends Thread{
    PrintWriter pw;
    public WorldThread(PrintWriter pw) {
        this.pw=pw;
    }

    public void run() {
        for(int i=0; i<10000; i++) {
            pw.print("world");
        }
    };
}
