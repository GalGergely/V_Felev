import java.util.ArrayList;

public class Manager extends Employee {
    private ArrayList<Employee> employees = new ArrayList<>();

    public Manager(String name, int sallery) {
        super(name, sallery);
    }

    void addEmployee(Employee e) {
        employees.add(e);
    }

    void deleteEmployee(int index) {
        employees.remove(index);
    }

    @Override
    public float getSalary() {
        float summ = 0;
        for(int i=0; i<employees.size(); i++) {
            summ = summ + employees.get(i).getSalary();
        }
        summ = summ * (5/100);
        return this.salary+summ;
    }

    @Override
    public void setSalary(float x) {

    }
}
