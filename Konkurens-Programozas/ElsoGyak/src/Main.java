public class Main {
    public static void main(String[] args) {
        Subordinate s = new Subordinate("Gergo", 100);
        Company c = new Company();
        c.addSE(s);
        c.logEmps();
        c.raiseSalary(100);
        c.logEmps();
    }
}
