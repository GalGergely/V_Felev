import java.util.List;
import java.util.Random;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicInteger;

import static java.lang.Thread.sleep;

public class PigMent {

  /* Global Constants */
  static final int TIC_MIN   = 50;  // Tickrate minimum time (ms)
  static final int TIC_MAX   = 200; // Tickrate maximum time (ms)
  static final int FEED      = 20;  // Mass gained through photosynthesis
  static final int BMR       = 10;  // Mass lost due to basal metabolic rate
  static final int MAX_POP   = 10;  // Maximum number of concurent pigs
  static final int INIT_POP  = 3;   // size of initial pig population
  static final int INIT_MASS = 20;  // starting mass of initial pigs
  public static Integer pop  = INIT_POP;   // size of initial pig population

  // TODO: don't forget to make the pigs scream edgy stuff:
  // pigSay("Holy crap, I just ate light!");
  // pigSay("This vessel can no longer hold the both of us!");
  // pigSay("Beware world, for I'm here now!");
  // pigSay("Bless me, Father, for I have sinned.");
  // pigSay("I have endured unspeakable horrors. Farewell, world!");
  // pigSay("Look on my works, ye Mighty, and despair!");
  
  // TODO: globally accessible variables go here (id, pigPool, openArea)
  // TODO: explicit locks and conditions also go here (Task2)
  public static AtomicInteger idGenerator = new AtomicInteger();
  private static ExecutorService pigPool = Executors.newFixedThreadPool(INIT_POP);

  /* Implementing Awesomeness (a.k.a. the pigs) */
  static class PhotoPig implements Runnable {

    /* Take this, USA! */
    final int id;

    /* Watch your lines, piggie! */
    int mass;

    /* Sweet dreams (are made of this) */
    void pigSleep() {
      Random r = new Random();
      int result = r.nextInt(TIC_MAX-TIC_MIN) + TIC_MIN;
      try {
        sleep(result);
      } catch (InterruptedException e) {
        throw new RuntimeException(e);
      }
    }

    /* Ensuring free speech */
    synchronized void pigSay(String msg) {
      System.out.println(this.toString() + msg);
    }

    /* Here comes the esoteric stuff */
    boolean eatLight() {
      this.pigSleep();
      if( /*Todo pig is dead*/ false) {
        return false;
      }
      this.mass += FEED;
      this.mass -= (this.mass / BMR);
      if(mass / BMR > FEED / 2) {
          //osztodas
        synchronized (pop) {
          if (pop < MAX_POP) {
            pop++;
            pigPool.submit(new PhotoPig(this.mass / 2));
            this.mass = this.mass / 2;
            pigSay("This vessel can no longer hold the both of us!");
          } else {
            System.out.println("population peaking");
            pigPool.shutdownNow();
          }
        }
      }
      return true;
    }

    /* Hey, this ain't vegan! */
    boolean aTerribleThingToDo() {
      return true; // TODO: replace this placeholder (task2)
    }

    /* Every story has a beginning */

    public PhotoPig(int mass) {
      this.mass = mass;
      this.id = idGenerator.getAndIncrement();
      this.pigSay("Beware world, for I'm here now!");
    }

    @Override
    public String toString() {
      return "PhotoPig{" +
              "id=" + id +
              ", mass=" + mass +
              '}';
    }

    /* Live your life, piggie! */
    @Override public void run() {
      while (this.eatLight()) {
        this.eatLight();
        pigSay("Holy crap, I just ate light!");
      }
    }
  }

  /* Running the simulation */
  public static void main(String[] args) {
    // Create initial population
    for (int i = 0; i < INIT_POP; i++) {
      pigPool.submit(new PhotoPig(INIT_MASS));
    }
  }
}
