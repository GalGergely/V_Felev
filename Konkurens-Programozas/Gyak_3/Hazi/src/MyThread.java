import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;

public class MyThread extends Thread{

    PrintWriter pw;

    public void run() {
        for(int i=0; i<=10000; i++) {
            try {
                pw = new PrintWriter(new File(this.getName().toString()+".txt"));
            } catch (FileNotFoundException e) {
                throw new RuntimeException(e);
            }
                pw.println(i);
                pw.close();
        }
    };

}
