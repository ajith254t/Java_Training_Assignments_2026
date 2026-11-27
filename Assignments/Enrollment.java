package Assignment_1;

import java.util.Scanner;
import java.util.Stack;

public class Enrollment {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        Stack<String> enrollmentStack = new Stack<>();
        boolean running = true;

        while (running) {
            System.out.println("\n1. Enroll learner");
            System.out.println("2. Undo last enrollment");
            System.out.println("3. Show last enrollment");
            System.out.println("4. Exit");
            System.out.print("Enter your choice: ");

            int choice = scanner.nextInt();
            scanner.nextLine(); 
            switch (choice) {
                case 1:
                    System.out.print("Enter learner's name: ");
                    String name = scanner.nextLine();
                    enrollmentStack.push(name);
                    System.out.println("Enrolled: " + name);
                    break;

                case 2:
                    if (enrollmentStack.isEmpty()) {
                        System.out.println("Nothing to undo.");
                    } else {
                        String undoneName = enrollmentStack.pop();
                        System.out.println("Undone: " + undoneName);
                    }
                    break;

                case 3:
                    if (enrollmentStack.isEmpty()) {
                        System.out.println("Nothing to undo.");
                    } else {
                        System.out.println("Last enrollment: " + enrollmentStack.peek());
                    }
                    break;

                case 4:
                    running = false;
                    System.out.println("Exiting");
                    break;

                default:
                    System.out.println("Invalid choice");
                    break;
            }
        }

        scanner.close();
    }
}

