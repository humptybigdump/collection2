package edu.kit.tutorial.buffer;

public class EliteConsumer extends Thread {
    private final BoundedBuffer<Object> buffer;

    public EliteConsumer(BoundedBuffer<Object> buffer) {
        this.buffer = buffer;
    }

    public void run() {
        try {
            while (true) {
                Object item = null;

                synchronized(buffer) {
                    while (buffer.isEmpty()) {
                        buffer.wait();
                    }

                    item = buffer.get();

                    buffer.notifyAll();
                }

                consume(item);
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    private void consume(Object item) {
        // ...
    }
}