
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_LeaveType
WHERE LeaveType  = '#Form.LeaveType#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("a record with this code has been registered already!")
     
   </script>  
  
   <cfelse>
		  
		<cfquery name="Insert" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_LeaveType
		         (LeaveType,
				 <cfif trim(evaluate("Form.Description_#client.languageId#")) neq "">Description,</cfif>
				 ActionCode,
				 EntityClass,
				 ReviewerActionCodeOne,
				 ReviewerActionCodeTwo,
				 HandoverActionCode,
				 LeaveAccrual,
				 ListingOrder,				 
				 LeaveMaximum,			
				 UserEntry,
				 LeaveParent,
				 WorkDaysOnly,
				 LeaveBalanceMode,
				 <!---
				 StopAccrual,
				 ThresHoldSLWOP,
				 --->
				 LeaveReviewer,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Created)
		  VALUES ('#Form.LeaveType#',
		          <cfif trim(evaluate("Form.Description_#client.languageId#")) neq "">'#evaluate("Form.Description_#client.languageId#")#',</cfif>
				  <cfif form.actionCode eq "">
					  NULL,
				  <cfelse>
					  '#Form.ActionCode#',
				  </cfif>
				  <cfif form.workflow eq "">
					  NULL,
				  <cfelse>
					  '#Form.Workflow#',
				  </cfif>
				  '#Form.ReviewerActionCodeOne#',
  				  '#Form.ReviewerActionCodeTwo#',
			 	  '#Form.HandoverActionCode#',				  
				  '#Form.LeaveAccrual#',
				  '#Form.ListingOrder#',				 
				  '#Form.Leavemaximum#',				 
				  '#Form.UserEntry#',
				  '#Form.LeaveParent#',
				  '#Form.WorkDaysOnly#',
				  '#Form.LeaveBalanceMode#',
				  <!---
				  '#Form.StopAccrual#', 
				  '#Form.ThresholdSLWOP#',
				  --->
				  '#Form.LeaveReviewer#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  getDate())
			</cfquery>
			
			<cf_LanguageInput
				TableCode       		= "Ref_LeaveType" 
				Key1Value       		= "#Form.LeaveType#"
				Mode            		= "Save"
				Name1           		= "Description"	
				Operational       		= "1">
				
			<cf_ModuleControlLog 
			    Systemfunctionid="#url.idmenu#" 
	            Action="Delete" 
	            Content="#form#">	
			
	</cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>
	
	<cfquery name="Update" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_LeaveType
		SET   LeaveType              = '#Form.LeaveType#',
		      Description            = <cfif trim(evaluate("Form.Description_#client.languageId#")) neq "">'#evaluate("Form.Description_#client.languageId#")#'<cfelse>null</cfif>,
			  <cfif form.actionCode eq "">
			  ActionCode             = NULL,
			  <cfelse>
			  ActionCode             = '#Form.ActionCode#',
			  </cfif>
			  <cfif form.workflow eq "">
			  EntityClass            = NULL,
			  <cfelse>
			  EntityClass            =  '#Form.Workflow#',
		      </cfif>
			  EnablePayroll          =  '#Form.EnablePayroll#',
			  ReviewerActionCodeOne  = '#Form.ReviewerActionCodeOne#',
 			  ReviewerActionCodeTwo  = '#Form.ReviewerActionCodeTwo#',
			  HandoverActionCode     = '#Form.HandoverActionCode#',		     
			  LeaveBalanceEnforce    = '#Form.LeaveBalanceEnforce#',
			  LeaveBalanceMode       = '#Form.LeaveBalanceMode#',
			  ListingOrder           = '#Form.ListingOrder#',
			  LeaveAccrual           = '#Form.LeaveAccrual#',
			  <!---		
			  StopAccrual            = '#Form.StopAccrual#',
			  ThresholdSLWOP         = '#Form.ThresholdSLWOP#',	
			  --->			  
			  LeaveReviewer	         = '#Form.LeaveReviewer#', 
			  LeaveMaximum           = '#Form.LeaveMaximum#', 			 
			  UserEntry              = '#Form.UserEntry#',			
			  LeaveParent            = '#Form.LeaveParent#',
			  WorkDaysOnly           = '#Form.WorkDaysOnly#'
			  
		WHERE LeaveType              = '#Form.LeaveTypeOld#'
	</cfquery>
	
	<cf_LanguageInput
		TableCode       		= "Ref_LeaveType" 
		Key1Value       		= "#Form.LeaveType#"
		Mode            		= "Save"
		Name1           		= "Description"	
		Operational       		= "1">
		
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	    action="Update" 
	    content="#form#">	

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT distinct LeaveType
      FROM PersonLeave
      WHERE LeaveType  = '#Form.LeaveTypeOld#' 
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
	     <script language="JavaScript">
	    
		   alert("Code is in use. Operation aborted.")
		        
	     </script>  
	 
    <cfelse>
				
		<cfquery name="Delete" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Ref_LeaveType
		WHERE LeaveType = '#FORM.LeaveTypeOld#'
	    </cfquery>
		
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	    action="Delete" 
	    content="#form#">	
	
	</cfif>	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 try { opener.location.reload(); } catch(e) { }
        
</script>  
