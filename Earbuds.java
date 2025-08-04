package interfaces;

/*
This class implements an interface. Therefore, it's required to provide
a functionality to all methods listed in the interface.
 */
public class Earbuds implements MediaPlayer {
    @Override
    public void play() {
        System.out.println("Playing on earbuds");
    }

    @Override
    public void pause() {

    }

    @Override
    public void stop() {

    }

    @Override
    public void ffd() {

    }
}
