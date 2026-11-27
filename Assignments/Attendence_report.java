package Assignment_1;

public class Attendence_report {

    public static void main(String[] args) {
        
        int[] attendance = {25, 30, 28, 35, 40, 22, 18, 33, 29, 31};
        int n = attendance.length;

        
        int[] runningTotal = new int[n];
        runningTotal[0] = attendance[0];
        for (int i = 1; i < n; i++) {
            runningTotal[i] = runningTotal[i - 1] + attendance[i];
        }

        
        System.out.println("--- Range Queries ---");
        printRangeAttendance(runningTotal, 3, 7);

        
        printRangeAttendance(runningTotal, 1, 5);

        
        printRangeAttendance(runningTotal, 8, 3);

        
        System.out.println("Highest Attendance");
        findHighestAttendance(attendance);
    }

    
    public static void printRangeAttendance(int[] runningTotal, int startDay, int endDay) {
       
        if (startDay < 1 || endDay > runningTotal.length || startDay > endDay) {
            System.out.println("Invalid range: Day " + startDay + " to Day " + endDay);
            return;
        }

        
        int startIndex = startDay - 1;
        int endIndex = endDay - 1;

        int total;
        if (startDay == 1) {
           
            total = runningTotal[endIndex];
        } else {
            
            total = runningTotal[endIndex] - runningTotal[startIndex - 1];
        }

        System.out.println("Total attendance from Day " + startDay + " to Day " + endDay + ": " + total);
    }

    
    public static void findHighestAttendance(int[] attendance) {
        int maxAttendance = attendance[0];
        int bestDay = 1; 
        for (int i = 1; i < attendance.length; i++) {
            if (attendance[i] > maxAttendance) {
                maxAttendance = attendance[i];
                bestDay = i + 1;
            }
        }

        System.out.println("Highest attendance was on Day " + bestDay + " with " + maxAttendance + " attendees.");
    }
}
