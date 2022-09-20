public abstract class Employee implements SalariedEntity{
    private String name;
    protected float salary;

    public Employee(String name, int salary) {
        this.name = name;
        this.salary = salary;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public abstract float getSalary();

    public void setSalary(float salary) {
        this.salary = salary;
    }

    public void raisesalary(float presentage) {
        if (presentage < 0) {
            System.out.println("legszives legyel normalis. Hogy noveled minusszal a fizetest gyula! Használd az agyad.");
        }
        this.salary = this.salary * ((presentage + 100)/100);
    }
}
