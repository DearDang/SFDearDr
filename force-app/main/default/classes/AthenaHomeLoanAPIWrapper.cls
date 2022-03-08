public class AthenaHomeLoanAPIWrapper {
	
    public class AHLAPIRoot{
        public List<Body> body {get; set;}
    }
    
    public class Body{
        public List<Properties> properties {get; set;}
    }
    
    public class Properties {
        public String property {get; set;}
        public String propertyType {get; set;}                    
        public String loanAmount {get; set;}
        public String loanTerm {get; set;}
        public List<Applicants> applicants {get; set;}
    }
    
    public class Applicants{
        public String customer {get; set;}
        public String income {get; set;}
        public String expense {get; set;}
        public String phone {get; set;}
        public String ownership {get; set;}
        public String primaryApplicant {get; set;}
    }
}