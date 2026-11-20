package Assignment_1;

public class Actual_Hashing {

    private static String[][] library = new String[3][3];
    static int numShelf = 3;
    static int numLocPerShelf = 3;

    public static void main(String[] args) {
        Book b1 = new Book(1, "Harry Potter & Goblet of Fire");
        Book b2 = new Book(2, "Harry Potter & Deathly Hollows - I");
        Book b3 = new Book(3, "Harry Potter & Deathly Hollows - II");
        Book b4 = new Book(4, "Harry Potter & prisoner of azkaban");

        b1.address = hashAddress(b1);
        b2.address = hashAddress(b2);
        b3.address = hashAddress(b3);
        b4.address = hashAddress(b4);

        System.out.println(b1);
        System.out.println(b2);
        System.out.println(b3);
        System.out.println(b4);

        System.out.println("Demystify the address");
        String address = "3#S1#L1";
        String[] arr = address.split("#");
        System.out.println("Pls find book  id: " + arr[0] + " at shelf: " + arr[1] + " having location: " + arr[2]);
    }

    private static String hashAddress(Book b) {
       
        int shelfNo = (b.id % numShelf);

        for(int loc=0; loc<numLocPerShelf ; loc++){
            if( library[shelfNo][loc] == null ){
                library[shelfNo][loc] = "Book: " + b.id;
                return b.id + "#" + "S" + (shelfNo+1) + "#" + "L" + (loc+1);
            }
        }

        return null;
    }
   
}
class Book {
    int id;
    String name;
    String address;

    public Book(int id, String name) {
        this.id = id;
        this.name = name;
    }

    @Override
    public String toString() {
        return "BOOK DETAILS "+" id :"+id+" ,Name :"+name+" ,Address :"+address;
    }
}