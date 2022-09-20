import java.util.ArrayList;

public class Company {
    private ArrayList<SalariedEntity> se = new ArrayList<>();

    void addSE(SalariedEntity e) {
        se.add(e);
    }
    void delSE(int index) {
        se.remove(index);
    }

    void raiseSalary(float presentage) {
        for(int i = 0; i<se.size(); i++) {
            if(se.get(i) instanceof Employee) {
                ((Employee) se.get(i)).raisesalary(presentage);
            }
        }
    }
    void logEmps() {
        for(int i = 0; i<se.size(); i++) {
            System.out.println(se.get(i).getSalary());
        }
    }
}
