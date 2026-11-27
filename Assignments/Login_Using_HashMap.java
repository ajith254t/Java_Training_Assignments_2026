package Assignment_1;

import java.util.*;

public class Login_Using_HashMap {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.println("LOGIN System");
        System.out.println("Username: ");
        String username = sc.next();
        System.out.println("Password: ");
        String password = sc.next();
        LoginService loginService = new LoginService();
        boolean isValid = loginService.validate(username,password);
        if(isValid){
            System.out.println("Welcome " + username);
        }
        else{
            System.out.println("Invalid");
        }
        System.out.println();
        sc.close();
    }
}
class LoginService {

    Map<String, String> map = new HashMap<>();

    public LoginService() {
        map.put("harry","potter@123");
        map.put("ronald","ronald@123");
        map.put("hermione","hermione@123");
        map.put("ajith254t", "ajith@smart");
    }

    public boolean validate(String username, String password) {
        
        if(map.containsKey(username)){
            String originalPassword = map.get(username);
            if(originalPassword.equals(password))
                return true;
            else
                return false;
        }
        else
            return false;


    }
}