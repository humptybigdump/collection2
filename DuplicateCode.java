package tipps;

import java.util.ArrayList;
import java.util.List;

public class DuplicateCode {
    public static List<Integer> evens(List<Integer> ints) {
        List<Integer> evens = new ArrayList<>();
        for (Integer i : ints) {
            if (i % 2 == 0) {
                evens.add(i);
            }
        }
        return evens;
    }

    public static List<Integer> odds(List<Integer> ints) {
        List<Integer> odds = new ArrayList<>();
        for (Integer i : ints) {
            if (i % 2 == 1) {
                odds.add(i);
            }
        }
        return odds;
    }

    public static List<Integer> tris(List<Integer> ints) {
        List<Integer> tris = new ArrayList<>();
        for (Integer i : ints) {
            if (i % 3 == 0) {
                tris.add(i);
            }
        }
        return tris;
    }

    public static void main(String[] args) {
        List<Integer> list = List.of(1, 2, 3, 10, 16, 15, 100);
        System.out.println("Evens: " + odds(list));
        System.out.println("Odds: " + evens(list));
        System.out.println("Tris: " + tris(list));
    }


    public static List<Integer> modN(List<Integer> ints, int n, int offset) {
        List<Integer> out = new ArrayList<>();
        for (Integer i : ints) {
            if (i % n == offset) {
                out.add(i);
            }
        }
        return out;
    }
}
