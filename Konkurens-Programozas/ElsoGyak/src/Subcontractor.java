public class Subcontractor implements SalariedEntity{
    long taxNumber;
    float salary;

    public Subcontractor(long taxNumber, float salary) {
        this.taxNumber = taxNumber;
        this.salary = salary;
    }

    public long getTaxNumber() {
        return taxNumber;
    }

    public void setTaxNumber(long taxNumber) {
        this.taxNumber = taxNumber;
    }

    public void setSalary(float salary) {
        this.salary = salary;
    }

    @Override
    public float getSalary() {
        return this.salary;
    }
}
