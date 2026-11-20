package Assignment_1;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;


class Course {
    int id;
    String name;
    double fee;

    public Course(int id, String name, double fee) {
        this.id = id;
        this.name = name;
        this.fee = fee;
    }

    @Override
    public String toString() {
        return "id="+id+" "+"name ="+name+" "+"Fees ="+fee;
    }
}


class CouseUtility implements Comparator<Course> {

    private String sortBy;
    private String direction;

    public CouseUtility(String sortBy, String direction) {
        this.sortBy = sortBy;
        this.direction = direction;
    }

    @Override
    public int compare(Course c1, Course c2) {
        if (sortBy.equalsIgnoreCase("fee")) {
            if (direction.equalsIgnoreCase("ASC")) {
                if (c1.fee > c2.fee) return 1;
                if (c1.fee < c2.fee) return -1;
            } else {
                if (c1.fee < c2.fee) return 1;
                if (c1.fee > c2.fee) return -1;
            }
        } else if (sortBy.equalsIgnoreCase("name")) {
            if (direction.equalsIgnoreCase("ASC")) {
                return c1.name.compareToIgnoreCase(c2.name);
            } else {
                return c2.name.compareToIgnoreCase(c1.name);
            }
        }
        return 0;
    }
}


public class Sorting_courses {
    public static void main(String[] args) {
        List<Course> courses = new ArrayList<>();
        Course c1=new Course(101, "Java", 15000);
        Course c2 =new Course(102, "Python", 12000);
        Course c3 =new Course(103, "React", 15000);
        Course c4 =new Course(104, "SQL", 8000);
        Course c5 =new Course(105, "Angular", 12000);


        courses.add(c1);
        courses.add(c2);
        courses.add(c3);
        courses.add(c4);
        courses.add(c5);

        //Low to High
        Collections.sort(courses, new CouseUtility("fee", "ASC"));
        System.out.println("Low to High");
        for (Course c : courses) {
            System.out.println(c);
        }

        //High to Low
        Collections.sort(courses, new CouseUtility("fee", "DESC"));
        System.out.println("High to Low");
        for (Course c : courses) {
            System.out.println(c);
        }

        //A to Z
        Collections.sort(courses, new CouseUtility("name", "ASC"));
        System.out.println("A to Z");
        for (Course c : courses) {
            System.out.println(c);
        }
        Collections.sort(courses, new CouseUtility("name", "DESC"));
        System.out.println("Z to A");
        for (Course c : courses) {
            System.out.println(c);
    }
    }
}
