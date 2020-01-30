					  
				  
<cf_insertTriggerGroup  TriggerGroup="Contract" 
	              Description = "Trigger by Contract module"> 	
		  
<cf_insertTriggerGroup  TriggerGroup="Dependent" 
	              Description = "Trigger by Dependent module"> 		
				  		  
<cf_insertTriggerGroup  TriggerGroup="Entitlement" 
	              Description = "Trigger by Entitlement module"> 		
				  		  
<cf_insertTriggerGroup  TriggerGroup="Personal" 
	              Description = "Trigger by Personal Entitlement module"> 						  			  				  			 
		  				  			  
<cf_insertTriggerGroup  TriggerGroup="Insurance" 
	              Description = "Trigger by Dependent + Entitlement module"> 					  
				  			  			  
<cf_insertTriggerGroup  TriggerGroup="Overtime" 
	              Description = "Trigger by Overtime module"> 				  
			  
<cf_insertTriggerGroup  TriggerGroup="TravelClaim" 
	              Description = "Trigger by Claim module"> 	
				  
<cf_insertTriggerGroup  TriggerGroup="Housing" 
	              Description = "Trigger for RS definition"> 						  
				  

		   			   
<cf_insertTriggerCondition  TriggerCondition="None" 
	              Description = "Pointer 0"> 	
			   			   
<cf_insertTriggerCondition  TriggerCondition="Dependent" 
	              Description = "Define Pointer based on dependent situation"> 									  							  

			  

<cf_insertSource  Code="Earning" 
	              Description = "Earning"
				  ListingOrder = "1">		  

<cf_insertSource  Code="Compensation" 
	              Description = "Compensation"
				  ListingOrder = "2">			  

<cf_insertSource  Code="Contribution" 
	              Description = "Contribution"
				  ListingOrder = "3">					  		  

<cf_insertSource  Code="Deduction" 
	              Description = "Deduction"
				  ListingOrder = "4">					  		  

<cf_insertSource  Code="Miscellaneous" 
	              Description = "Miscellaneous"
				  ListingOrder = "5">					  				  			  
				  

<cf_insertSlip    PrintGroup="Net Payment" 
	              Description = "Net Payment"
				  PrintGroupOrder = "1">
				   
<cf_insertSlip    PrintGroup="Contributions" 
	              Description = "Organization Contributions"
				  PrintGroupOrder = "2"> 
				   			   
<cf_insertSlip    PrintGroup="Miscellaneous" 
	              Description = "Miscellaneous"
				  PrintGroupOrder = "3"> 							  
				  
	
<!---				  	
				  
<cf_insertTrigger
                  SalaryTrigger="SALARY" 
	              Description = "Salary"
				  TriggerGroup="Contract"
				  TriggerCondition="None"
				  TriggerConditionPointer=""
				  EntitlementClass="Rate"> 						  			  
				  
<cf_insertTrigger
                  SalaryTrigger="STAFF ASSESSMENT" 
	              Description = "Staff Assessment"
				  TriggerGroup="Contract"
				  TriggerCondition="Dependent"
				  TriggerConditionPointer="0,1"
				  EntitlementClass="Rate"> 						  
	
				  
<cf_insertTrigger
                  SalaryTrigger="DEPENDENT ALLOWANCE CHILD" 
	              Description = "Dependent Allowance child"
				  TriggerGroup="Dependent"
				  TriggerCondition="None"
				  TriggerConditionPointer=""
				  EntitlementClass="Rate"> 	
				  
<cf_insertTrigger
                  SalaryTrigger="DEPENDENT ALLOWANCE SPOUSE" 
	              Description = "Dependent Allowance spouse"
				  TriggerGroup="Dependent"
				  TriggerCondition="None"
				  TriggerConditionPointer=""
				  EntitlementClass="Rate"> 						  	
				  				  		  
	
				  
<cf_insertTrigger
                  SalaryTrigger="ALLOWANCE HOUSE" 
	              Description = "Allowance Housing"
				  TriggerGroup="Entitlement"
				  TriggerCondition="None"
				  TriggerConditionPointer=""
				  EntitlementClass="Rate"> 		
				  
<cf_insertTrigger
                  SalaryTrigger="1ST LANGUAGE" 
	              Description = "First Language"
				  TriggerGroup="Entitlement"
				  TriggerCondition="None"
				  TriggerConditionPointer=""
				  EntitlementClass="Rate"> 		
				  
<cf_insertTrigger
                  SalaryTrigger="2ND LANGUAGE" 
	              Description = "Second Language"
				  TriggerGroup="Entitlement"
				  TriggerCondition="None"
				  TriggerConditionPointer=""
				  EntitlementClass="Rate"> 		
				  
<cf_insertTrigger
                  SalaryTrigger="LIFE INSURANCE" 
	              Description = "Life Insurance"
				  TriggerGroup="Entitlement"
				  TriggerCondition="None"
				  TriggerConditionPointer=""
				  EntitlementClass="Rate"> 		
				  
<cf_insertTrigger
                  SalaryTrigger="MEAL ALLOWANCE" 
	              Description = "Meal Allowance"
				  TriggerGroup="Entitlement"
				  TriggerCondition="None"
				  TriggerConditionPointer=""
				  EntitlementClass="Rate"> 		
				  
<cf_insertTrigger
                  SalaryTrigger="PENSION" 
	              Description = "Pension Fund"
				  TriggerGroup="Entitlement"
				  TriggerCondition=""
				  TriggerConditionPointer=""
				  EntitlementClass="Percentage"> 	
				  
<cf_insertTrigger
                  SalaryTrigger="POST ADJUSTMENT" 
	              Description = "Post Adjustment"
				  TriggerGroup="Entitlement"
				  TriggerCondition=""
				  TriggerConditionPointer=""
				  EntitlementClass="Percentage"> 							  						  				  				  				  				  				  			  

						  
	<cf_insertTrigger
	                  SalaryTrigger="MEDICAL INSURANCE" 
		              Description = "Medical Insurance"
					  TriggerGroup="Insurance"
					  TriggerCondition="Dependent"
					  TriggerConditionPointer="0,1,2,3"
					  EntitlementClass="Percentage"> 	
					  
	<cf_insertTrigger
	                  SalaryTrigger="MEDICAL INSURANCE FIXED" 
		              Description = "Medical Insurance"
					  TriggerGroup="Insurance"
					  TriggerCondition=""
					  TriggerConditionPointer=""
					  EntitlementClass="Rate"> 					  			  			  
				  
	<cf_insertTrigger
	                  SalaryTrigger="OVERTIME-1" 
		              Description = "Overtime Low rate"
					  TriggerGroup="Overtime"
					  TriggerCondition=""
					  TriggerConditionPointer=""
					  EntitlementClass="Rate"> 			
					  
	<cf_insertTrigger
	                  SalaryTrigger="OVERTIME-2" 
		              Description = "Overtime High rate"
					  TriggerGroup="Overtime"
					  TriggerCondition=""
					  TriggerConditionPointer=""
					  EntitlementClass="Rate"> 		
					  
--->					  					  				  			  
	 	  				  
				  	