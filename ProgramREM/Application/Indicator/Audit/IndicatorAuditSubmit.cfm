<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<TITLE>Submit Funding</TITLE>

<cftransaction action="BEGIN">

<cfparam name="url.wf" default="0">
<cfparam name="form.auditid" default="">
<cfparam name="url.auditid" default="#Form.auditid#">

<cfif Form.Location eq "0">
  <cfset i = "0">
<cfelse>
  <cfset i = "1">
</cfif>

<cfloop index="Loc" from="#i#" to="#FORM.Location#">
      
	<cfloop index="Rec" from="1" to="#FORM.Indicator#">
	
	  <cfparam name="FORM.indicator_#loc#_#Rec#" default="">	
	  <cfparam name="FORM.access_#loc#_#Rec#" default="">

	  <cfset target     = Evaluate("FORM.indicator_" & #loc# & "_" & #Rec#)>
	  <cfset access     = Evaluate("FORM.access_" & #loc# & "_" & #Rec#)>
	  
	  <cfparam name="FORM.NA_#loc#_#Rec#" default="0">
	  
	  <cfif access eq "1">
	  
	      <cfset na         = Evaluate("FORM.NA_" & #loc# & "_" & #Rec#)> 
		  <cfset value      = Evaluate("FORM.targetvalue_" & #loc# & "_" & #Rec#)>
		  <cfparam name="FORM.targetbase_#loc#_#Rec#" default="">
		  <cfset base       = Evaluate("FORM.targetbase_" & #loc# & "_" & #Rec#)>
		  <cfparam name="FORM.targetcount_#loc#_#Rec#" default="">
		  <cfset count      = Evaluate("FORM.targetcount_" & #loc# & "_" & #Rec#)>
		  
		  <cfif na neq "1">
		  					  		  
			  <cfif base neq "" and count neq "">
			  
				  <cfif LSIsNumeric(base) and LSIsNumeric(count)> 
		
					     <cfset value = 0>
					     <cfif base neq "0">
						  	  <cfset value = count/base>
						 </cfif>	
						 
				  <cfelse>
								  		  
					  	 <script language="JavaScript">
						    alert("Problem you have entered a non-numeric value for your measurement")
						    history.back()
						 </script>				
						
						 <cfabort>
						
				  </cfif>		
			  			    
			  </cfif>
			  
			  <cfif not LSIsNumeric(value) and value neq ""> 
			 			
					<cfoutput>		  		
					<script language="JavaScript">
						  alert("Problem you have entered a non-numeric value (#value#) for your measurement")
						  history.back()
					</script>
					</cfoutput>
											
					<cfabort>
			  
			  </cfif>
			  
			  <cfif base eq	 "">
			      <cfset base = "0">
			  </cfif>
			  
			  <cfif count eq "">
			      <cfset count = "0">
			  </cfif>
			  
			  <cfset remarks    = Evaluate("FORM.remarks_" & #loc# & "_" & #Rec#)>
				  
			  <cfif value neq "">
				  <cfset st = "1">
			  <cfelse>
			   	  <cfset st = "0">
			  </cfif> 
		  
		  </cfif>
		  
		  <cfparam name="st" default="0">
		  
		  <cfset dateValue = "">
		 
		  <cfif value eq "" or na eq "1">
		  
		     <!--- remove prior entry in case of N/A selected or blank value --->
		     <cfquery name="Reset" 
		      datasource="AppsProgram" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
		      DELETE FROM ProgramIndicatorAudit
			  WHERE TargetId      = '#target#'
			    AND AuditId       = '#URL.AuditId#'
				AND Source        = 'Manual' 
		     </cfquery>	
		  
		 <cfelse>
  
		    <!--- define value and enter record --->
			<cfquery name="Check" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				SELECT * 
				FROM   ProgramIndicatorAudit
				WHERE  TargetId      = '#target#'
			      AND  AuditId       = '#URL.AuditId#'
				  AND  Source = 'Manual'
			</cfquery>	
							
			<cfif Check.recordCount eq "1">
			
				<cfset rowguid = check.measurementid>
						 								
			     <cfquery name="Update" 
		          datasource="AppsProgram" 
			      username="#SESSION.login#" 
			      password="#SESSION.dbpw#">
			      UPDATE ProgramIndicatorAudit
				  SET AuditRemarks      = '#Remarks#',
					  AuditTargetValue  = '#value#', 
					  AuditTargetBase   = '#base#',
					  AuditTargetCount  = '#count#',
					  <cfif Check.AuditTargetValue neq value>
						  OfficerUserId     = '#SESSION.acc#',
						  OfficerLastName   = '#SESSION.last#',
						  OfficerFirstName  = '#SESSION.first#',
				    	  Created           = getDate(), 
					  </cfif>
					  AuditStatus       = '#st#'					 
				   WHERE TargetId       = '#target#'
			       AND   AuditId          = '#URL.AuditId#'
				   AND   Source           = 'Manual' 
			     </cfquery>	
				
			<cfelse>
			
				<cf_assignid>
						
				<cfquery name="Insert" 
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO ProgramIndicatorAudit  
			       (MeasurementId,
				    AuditId, 
				    TargetId, 
					Source, 
					AuditTargetValue, 
					AuditTargetBase, 
					AuditTargetCount, 
					AuditStatus, 
					AuditRemarks, 
					OfficerUserId, 
					OfficerLastName, 
					OfficerFirstName)
			     VALUES 
				   ('#rowguid#',
				    '#URL.AuditId#', 
				    '#Target#', 
					'Manual', 
					'#value#', 
					'#base#', 
					'#count#', 
					'#st#', 
					'#remarks#', 
					'#SESSION.acc#', 
					'#SESSION.last#', 
					'#SESSION.first#')
			     </cfquery>		
			     
				 
			</cfif>		
			
			<cfif na neq "1">
			
					<cfquery name="Insert" 
				     datasource="AppsProgram" 
				     username=#SESSION.login# 
				     password=#SESSION.dbpw#>
				     INSERT INTO ProgramIndicatorAuditAction  
				       (MeasurementId, 
					    ActionStatus, 
						AuditTargetValue, 
						AuditTargetBase, 
						AuditTargetCount, 
						AuditRemarks, 
						OfficerUserId, 
						OfficerLastName, 
						OfficerFirstName, 
						Created)
				     VALUES 
					   ('#rowguid#',
					    '#st#',  
					 	#value#, 
						#base#, 
						#count#, 					
						'#remarks#', 
						'#SESSION.acc#', 
						'#SESSION.last#', 
						'#SESSION.first#', 
						getDate())
				     </cfquery>		
				 
			</cfif>	  
			 
		   </cfif>	 
		   
	  </cfif>	   

    </cfloop>

</cfloop>

</cftransaction>

<cfif url.wf eq "0">
	

	
	<cfoutput>
	<script language="JavaScript">
	     window.location = "IndicatorAudit.cfm?ProgramCode=#URLEncodedFormat(URL.ProgramCode)#&Period=#URLEncodedFormat(URL.Period)#&AuditId=#URLEncodedFormat(URL.AuditId)#"
	</script>
	</cfoutput>

</cfif>

  	

	

