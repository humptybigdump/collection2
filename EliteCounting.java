package edu.kit.tutorial.counter;

public class EliteCounting {
    // count this to 10000 pls
    private static Counter counter = new Counter();

    public static void main(String[] args) {

        // thread 1
        Thread t1 = new Thread(
                new Runnable() {
                    @Override
                    public void run() {
                        for (int i = 0; i < 5000; i++) counter.increase();
                    }
                }
        );
        // thread 2
        Thread t2 = new Thread(
                new Runnable() {
                    @Override
                    public void run() {
                        for (int i = 0; i < 5000; i++) counter.increase();
                    }
                }
        );

        t1.start(); // replace with .run() for immediate exmatriculation
        t2.start();
        try {
            t1.join();
            t2.join();
        } catch (InterruptedException e) {
            System.out.println(e.getMessage());
        }


        System.out.println(counter.getValue());
    }
}
