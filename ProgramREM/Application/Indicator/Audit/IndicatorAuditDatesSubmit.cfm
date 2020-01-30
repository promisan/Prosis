
<TITLE>Submit Funding</TITLE>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_wait text="saving">

<cfset loc = 0>

<cfquery name="Audit"
datasource="AppsProgram"
username="#SESSION.login#"
password="#SESSION.dbpw#">
   SELECT *
     FROM Ref_Audit
    WHERE Period = '#Form.Period#'
	  AND AuditDate <= getDate()+15
   ORDER BY AuditDate 
</cfquery>

<cftransaction action="BEGIN">
      
	<cfloop query="Audit">

	  <cfset access     = Evaluate("FORM.access_" & #loc# & "_" & #CurrentRow#)>
	  	  
	  <cfparam name="FORM.Status_#loc#_#currentRow#" default="0">
	  	  
	  <cfif access eq "1">
	  
	      <cfset na         = Evaluate("FORM.Status_" & #loc# & "_" & #CurrentRow#)> 
		  <cfset value      = Evaluate("FORM.targetvalue_" & #loc# & "_" & #CurrentRow#)>
		  
		  <cfparam name="FORM.targetbase_#loc#_#currentRow#" default="">
		  <cfset base       = Evaluate("FORM.targetbase_" & #loc# & "_" & #CurrentRow#)>
		  <cfparam name="FORM.targetcount_#loc#_#currentRow#" default="">
		  <cfset count      = Evaluate("FORM.targetcount_" & #loc# & "_" & #CurrentRow#)>
		  
		  <!--- remove comma's --->
		  
		  <cfset value     = replace(value,",","")>
		  <cfset base      = replace(base,",","")>
		  <cfset count     = replace(count,",","")>
		  
		  <cfif na eq "1">
		  					  		  
			  <cfif base neq "" and count neq "">
			  
			      <cfif LSIsNumeric(base) and LSIsNumeric(count)> 
	
				      <cfset value = 0>
				      <cfif base neq "0">
					  	  <cfset value = count/base>
					 </cfif>	
					 
				  <cfelse>
				  		  
				  		 <script language="JavaScript">
						    alert("Problem you entered a non-numeric value for your measurement")
						    history.back()
						 </script>				
						
						 <cfabort>
				 			  
				  </cfif>				  	 

				<!--- 	  <cfelse>
						        <cfset value = "0"> 
				tree lines above were taken out by Jm
				 --->
				 
			  </cfif>
			  
			  <cfif not LSIsNumeric(value)> 
			  
					<script language="JavaScript">
						  alert("Problem you have entered a non-numeric value for your measurement")
						  history.back()
					</script>
											
					<cfabort>
			  
			  </cfif>
			  
			  <cfif base eq	 "">
			      <cfset base = "0">
			  </cfif>
			  
			  <cfif count eq "">
			      <cfset count = "0">
			  </cfif>
		  		  
		</cfif>	  
		
		<cfparam name="FORM.remarks_#loc#_#CurrentRow#" default="">
		<cfset remarks    = Evaluate("FORM.remarks_" & #loc# & "_" & #CurrentRow#)>	
		
		<cfif na eq "0" or na eq "9">
		  <cfset st = na>	
		<cfelseif value eq "">
		  <cfset st = "0">
		<cfelse>
		  <cfset st = "1">
		</cfif> 
				  
		<cfset dateValue = "">
		  
			<!---		  
		 
			  <cfif #value# eq "" or #st# eq "0" or #st# eq "9">
			  				 
			     <!--- remove prior entry --->
			     <cfquery name="Reset" 
			      datasource="AppsProgram" 
			      username="#SESSION.login#" 
			      password="#SESSION.dbpw#">
			      DELETE FROM ProgramIndicatorAudit
				  WHERE TargetId      = '#Form.targetId#'
				    AND AuditId       = '#Audit.AuditId#'
					AND Source        = 'Manual' 
			     </cfquery>	
				 			  
			 </cfif>
			 
			 --->
  
		    <!--- define value and enter record --->
			<cfquery name="Check" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				SELECT * 
				FROM   ProgramIndicatorAudit
				WHERE  TargetId      = '#Form.targetId#'
			    AND    AuditId       = '#Audit.AuditId#'
				AND    Source        = 'Manual'
			</cfquery>	
							
			<cfif Check.recordCount eq "1">
			
				<cfset rowguid = check.measurementid>
							 								
			     <cfquery name="Update" 
		          datasource="AppsProgram" 
			      username="#SESSION.login#" 
			      password="#SESSION.dbpw#">
			      UPDATE ProgramIndicatorAudit
				  SET AuditRemarks      = '#Remarks#',
				      <cfif st neq "0" and st neq "9">
						  AuditTargetValue  = '#value#', 
						  AuditTargetBase   = '#base#',
						  AuditTargetCount  = '#count#',
					  </cfif>
					  AuditStatus       = '#st#',
					  OfficerUserId     = '#SESSION.acc#',
					  OfficerLastName   = '#SESSION.last#',
					  OfficerFirstName  = '#SESSION.first#', 
			    	  Created           = getDate() 
				   WHERE TargetId       = '#Form.targetId#'
			       AND AuditId          = '#Audit.AuditId#'
				   AND Source           = 'Manual' 
			     </cfquery>	
				 
				 <cfif st neq "0" and st neq "9">
				 
				 <cfquery name="Insert" 
				     datasource="AppsProgram" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO ProgramIndicatorAuditAction  
				       (MeasurementId, 
					    ActionStatus, 
						AuditTargetValue, 
						AuditTargetBase, 
						AuditTargetCount, 
						AuditRemarks, 
						OfficerUserId, 
						OfficerLastName, 
						OfficerFirstName)
				     VALUES 
					   ('#rowguid#',
					    '#st#',  
					 	#value#, 
						#base#, 
						#count#, 					
						'#remarks#', 
						'#SESSION.acc#', 
						'#SESSION.last#', 
						'#SESSION.first#')
				     </cfquery>	
					 
				  </cfif>	 	
				
			<cfelse>
			
				<cfif st neq "0" and st neq "9">
			
					<cf_assignId>							
							
					<cfquery name="Insert" 
				     datasource="AppsProgram" 
				     username=#SESSION.login# 
				     password=#SESSION.dbpw#>
				     INSERT INTO ProgramIndicatorAudit  
				       (MeasurementId, AuditId, TargetId, Source, AuditTargetValue, AuditTargetBase, AuditTargetCount, AuditStatus, AuditRemarks, OfficerUserId, OfficerLastName, OfficerFirstName, Created)
				     VALUES 
					   ('#rowguid#',
					    '#Audit.AuditId#', 
					    '#Form.TargetId#', 
						'Manual', 
						#value#, 
						#base#, 
						#count#, 					
						'#st#', 
						'#remarks#', 
						'#SESSION.acc#', 
						'#SESSION.last#', 
						'#SESSION.first#', 
						getDate())
				     </cfquery>		
					 
					 <cfquery name="Insert" 
				     datasource="AppsProgram" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO ProgramIndicatorAuditAction  
				       (MeasurementId, 
					    ActionStatus, 
						AuditTargetValue, 
						AuditTargetBase, 
						AuditTargetCount, 
						AuditRemarks, 
						OfficerUserId, 
						OfficerLastName, 
						OfficerFirstName)
				     VALUES 
					   ('#rowguid#',
					    '#st#',  
					 	#value#, 
						#base#, 
						#count#, 					
						'#remarks#', 
						'#SESSION.acc#', 
						'#SESSION.last#', 
						'#SESSION.first#')
				     </cfquery>		
				 
				 </cfif>
				 
			</cfif>					
				   
	  </cfif>	   

    </cfloop>

</cftransaction>

<cf_waitEnd>

<cfif ParameterExists(Form.Close)> 
	
	<cfoutput>
		<script language="JavaScript">
		  window.close()
		  returnValue = 1
		 </script>
	</cfoutput>

<cfelse>
	
	<cfoutput>
		<cf_tl id="Information has been saved" var="1">
		<script language="JavaScript">
		  alert("#lt_text#")
		  window.location = "IndicatorAuditDatesInput.cfm?TargetId=#Form.TargetId#&Period=#Form.Period#"
		 </script>
	</cfoutput>

</cfif>
