require "employee"

class Startup
  attr_reader :name, :funding, :salaries, :employees

  def initialize(name, funding, salaries)
    @name = name
    @funding = funding
    @salaries = salaries
    @employees = []
  end

  def valid_title?(title)
    @salaries.has_key?(title)
  end

  def > (startup)
    self.funding > startup.funding
  end

  def hire(name, title)
    if valid_title?(title)
      @employees << Employee.new(name, title)
    else
      raise ArgumentError.new("Title is not valid")
    end
  end

  def size
    @employees.length
  end

  def pay_employee(employee)
    salary = @salaries[employee.title]
    if salary < @funding
      employee.pay(salary)
      @funding -= salary
    else
      raise ArgumentError.new("Not enough funding")
    end
  end

  def payday
    employees.each {|employee| pay_employee(employee)}
  end

  def average_salary
    all_salaries = employees.reduce(0) do |all_salaries, employee|
      all_salaries + @salaries[employee.title]
    end
    all_salaries / (employees.length * 1.0)
  end

  def close
    @employees = []
    @funding = 0
  end

  def acquire(startup)
    @funding += startup.funding
    @employees += startup.employees

    startup.salaries.each do |title, salary|
      if !valid_title?(title)
        @salaries[title] = salary
      end
    end

    startup.close
  end
end
