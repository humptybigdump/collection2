package edu.kit.aifb.prog1;

/**
 * Musterloesung der Aufgabe p27
 *
 * @version 1.0
 * @author Prog1-Team
 */
public class GetAbstammungDemo {
    public static void main(String[] args) {
        Tier tier = new Tier();
        Saeugetier saeugetier = new Saeugetier();
        Katze katze = new Katze();
        Wildkatze wildkatze = new Wildkatze();
        Luchs luchs = new Luchs();

        System.out.println(tier.getAbstammung());
        System.out.println(saeugetier.getAbstammung());
        System.out.println(katze.getAbstammung());
        System.out.println(wildkatze.getAbstammung());
        System.out.println(luchs.getAbstammung());
    }
}
