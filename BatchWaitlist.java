package Assignment_1;

import java.util.Arrays;
import java.util.LinkedList;
import java.util.Queue;

public class BatchWaitlist {

    public static void main(String[] args) {
        String[] seats = new String[3];
        Queue<String> waitlist = new LinkedList<>();

        
        String[] incomingLearners = {"Asha", "Ravi", "Meena", "Kiran", "Pooja"};
        for (String learner : incomingLearners) {
            joinBatch(seats, waitlist, learner);
        }

        
        System.out.println(" Ravi drops out ");
        dropOut(seats, waitlist, "Ravi");

       
        System.out.println("Edge Case: Name not in batch");
        dropOut(seats, waitlist, "Vikram");

        
        System.out.println("Asha drops out (Pooja moves in)");
        dropOut(seats, waitlist, "Asha");

        System.out.println("Edge Case: Meena drops out (Waitlist is now empty)");
        dropOut(seats, waitlist, "Meena");
    }

    
    public static void joinBatch(String[] seats, Queue<String> waitlist, String name) {
        boolean seated = false;

        for (int i = 0; i < seats.length; i++) {
            if (seats[i] == null) {
                seats[i] = name;
                seated = true;
                break;
            }
        }

        if (!seated) {
            waitlist.add(name);
        }

        System.out.println("Join: " + name);
        printStatus(seats, waitlist);
    }

   
    public static void dropOut(String[] seats, Queue<String> waitlist, String name) {
        int seatIndex = -1;

       
        for (int i = 0; i < seats.length; i++) {
            if (seats[i] != null && seats[i].equals(name)) {
                seatIndex = i;
                break;
            }
        }

       
        if (seatIndex == -1) {
            System.out.println(name + " is not in the batch.");
            return;
        }

       
        if (!waitlist.isEmpty()) {
            seats[seatIndex] = waitlist.poll();
        } else {
            seats[seatIndex] = null;
        }

        printStatus(seats, waitlist);
    }

   
    public static void printStatus(String[] seats, Queue<String> waitlist) {
        System.out.println("Seats:   " + Arrays.toString(seats));
        System.out.println("Waiting: " + waitlist);
    }
}

