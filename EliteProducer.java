package edu.kit.tutorial.buffer;

public class EliteProducer extends Thread {
    private final BoundedBuffer<Object> buffer;

    public EliteProducer(BoundedBuffer<Object> buffer) {
        this.buffer = buffer;
    }

    public void run() {
        try {
            while (true) {
                Object item = produce();

                synchronized (buffer) {
                    while (buffer.isFull()) {
                        buffer.wait();
                    }

                    buffer.put(item);

                    buffer.notifyAll();
                }
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    private Object produce() {
        Object object = new Object();
        // ...
        return object;
    }
}
