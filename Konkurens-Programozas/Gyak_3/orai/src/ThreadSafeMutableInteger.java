public class ThreadSafeMutableInteger {
    int data;

    public ThreadSafeMutableInteger(int data) {
        this.data = data;
    }

    int get() {
        return data;
    }
    void set(int d) {
        data=d;
    }
    int getAndIncrement() {
        return data++;
    }

    int getAndDecrement(){
        return data--;
    }
    int getAndAdd(int v){
        int d = this.data;
        this.data+=1;
        return d;
    }
    int incrementAndGet(){
        return ++data;
    }
    int decrementAndGet() {
        return --data;

    }
    int addAndGet(int v){
        this.data+=v;
        return this.data;

    }
}
