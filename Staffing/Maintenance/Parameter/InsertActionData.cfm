

<cf_insertTimeParent
 TimeParent  = "Work" Description = "Attendance" AllowOverlap="0">	
 
<cf_insertTimeParent
 TimeParent  = "Admin" Description = "Administrative" AllowOverlap="1">	

<cf_insertTimeParent
 TimeParent  = "Leave" Description = "Absenteeism" AllowOverlap="0">	

 
 
<cf_insertSource
 ActionSource  = "Contract" Description = "Contract">	

<cf_insertSource
 ActionSource  = "Dependent" Description = "Dependent">	
 
<cf_insertSource
 ActionSource  = "Entitlement" Description = "Entitlement">	 

<cf_insertSource
 ActionSource  = "Overtime" Description = "Overtime">	

<cf_insertSource
 ActionSource  = "Person" Description = "Person">	
 
<cf_insertSource
 ActionSource  = "Leave" Description = "Leave">	    
 
 
<!--- system actions --->  
 
<cf_insertAction 
 Code   = "0001" ActionSource = "Assignment" 
 Description = "Expiration">	

<cf_insertAction 
 Code   = "0002" ActionSource = "Assignment" 
 Description = "Change of Assignment">	
 
<cf_insertAction 
 Code   = "0003" ActionSource = "Assignment" 
 Description = "New assignment">	 

<cf_insertAction 
 Code   = "0004" ActionSource = "Assignment" 
 Description = "Reassignment">	
 
<cf_insertAction 
 Code   = "0005" ActionSource = "Assignment" 
 Description = "Change effective date">	 
 
<cf_insertAction 
 Code   = "0006" ActionSource = "Assignment" 
 Description = "Change Post Incumbency">	  

<cf_insertAction 
 Code   = "0007" ActionSource = "Assignment" 
 Description = "Change Function / Incumbency type">	 
 
<cf_insertAction 
 Code   = "0008" ActionSource = "Assignment" 
 Description = "Move Position to different unit">	  
 
 
<cf_insertAction 
 Code   = "1000" ActionSource = "Person" 
 Description = "Record Employee">	

<cf_insertAction 
 Code   = "1001" ActionSource = "Person" 
 Description = "Change Name">	  
 
<cf_insertAction 
 Code   = "1002" ActionSource = "Person" 
 Description = "Change Date of Birth">	
 
<cf_insertAction 
 Code   = "1003" ActionSource = "Person" 
 Description = "Change Nationality">	  
 
<cf_insertAction 
 Code   = "1004" ActionSource = "Person" 
 Description = "Change EMail Address">	  

<!--- 
<cf_insertAction 
 Code   = "1005" ActionSource = "Person" 
 Description = "Change Other">	  
 --->
 
<cf_insertAction 
 Code   = "2000" ActionSource = "Dependent" 
 Description = "Record Family Member">	
 
<cf_insertAction 
 Code   = "2001" ActionSource = "Dependent" 
 Description = "Change Dependent">	     
 
<cf_insertAction 
 Code   = "2002" ActionSource = "Dependent" 
 Description = "Change Dependent Entitlement">	  
 
<cf_insertAction 
 Code   = "2003" ActionSource = "Dependent" 
 Description = "Discontinue dependency allowance">	  
 
<cf_insertAction 
 Code   = "3000" ActionSource = "Contract" 
 Description = "Initial Appointment" CustomForm="Insert" ActionInitial="1">	
 
<cf_insertAction 
 Code   = "3022" ActionSource = "Contract" 
 Description = "Reappointment" CustomForm="Insert" ActionInitial="1">	   

<cf_insertAction 
 Code   = "3001" ActionSource = "Contract" 
 Description = "Amendment">	  

<cf_insertAction 
 Code   = "3002" ActionSource = "Contract" 
 Description = "Rescind Appointment">	  
 
<cf_insertAction 
 Code   = "3003" ActionSource = "Contract" 
 Description = "Extend Appointment" CustomForm="Insert">	
 
<cf_insertAction 
 Code   = "3004" ActionSource = "Contract" 
 Description = "Increment within Grade">	    
  
<cf_insertAction 
 Code   = "3051" ActionSource = "SPA" 
 Description = "Grant SPA">	  

<cf_insertAction 
 Code   = "3052" ActionSource = "SPA" 
 Description = "Amend SPA">	  
 
<cf_insertAction 
 Code   = "3053" ActionSource = "SPA" 
 Description = "Cancel SPA">	
 
<cf_insertAction 
 Code   = "3061" ActionSource = "Entitlement" 
 Description = "Grant Entitlement">	  

<cf_insertAction 
 Code   = "3062" ActionSource = "Entitlement" 
 Description = "Amend Entitlement">	  
 
<cf_insertAction 
 Code   = "3063" ActionSource = "Entitlement" 
 Description = "Cancel Entitlement">	   
    
<cf_insertAction 
 Code   = "4001" ActionSource = "Payroll" 
 Description = "Discontinue Settlement">	
 
<cf_insertAction 
 Code   = "4002" ActionSource = "Payroll" 
 Description = "Discontinue Entitlements">	 	
 
 <cf_insertAction 
 Code   = "4010" ActionSource = "Payroll" 
 Description = "Discontinue Leave Deduction">	
 
 <cf_insertAction 
 Code   = "4100" ActionSource = "Payroll" 
 Description = "Initiate Final Payment">	
 
<cf_insertAction 
 Code   = "4101" ActionSource = "Payroll" 
 Description = "Initiate SLWOP recovery">	  	  	
 
 <cf_insertStatus Class   = "Leave" Status = "0"  Description = "Draft">	
 <cf_insertStatus Class   = "Leave" Status = "1"  Description = "In Process">	
 <cf_insertStatus Class   = "Leave" Status = "2"  Description = "Approved">	
 <cf_insertStatus Class   = "Leave" Status = "8"  Description = "Amended">	
 <cf_insertStatus Class   = "Leave" Status = "9"  Description = "Denied">	
 
 <cf_insertStatus Class   = "Overtime" Status = "0"  Description = "Draft">	
 <cf_insertStatus Class   = "Overtime" Status = "1"  Description = "In Process">	
 <cf_insertStatus Class   = "Overtime" Status = "2"  Description = "Approved">	
 <cf_insertStatus Class   = "Overtime" Status = "5"  Description = "Settled">	
 <cf_insertStatus Class   = "Overtime" Status = "9"  Description = "Denied">	  
 
 
