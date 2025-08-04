<!--
    Copyright © 2025 Promisan

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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<!--- disabled 

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  Ref_Indicator
WHERE Code  = '#Form.Code#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("A record with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   
<cfquery name="Insert" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_Indicator
         (Code,
		 Description,
		 DescriptionQuestion,  
		 ListingOrder,
		 Category,
		 LineEntryLines,
		 LinePercentage,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.Code#',
          '#Form.Description#', 
		  '#Form.DescriptionQuestion#',
		  '#Form.ListingOrder#',
		  '#Form.Category#',
		  '#Form.LineEntryLines#',
		  '#Form.LinePercentage#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())</cfquery>
		  
    </cfif>		  
           
</cfif>

--->

<cfif Len(Form.MessagePerson) gt 300>
	 <cf_message message = "You entered a message that exceeded the allowed size of 300 characters."
	  return = "back">
	  <cfabort>
</cfif>

<cfif Len(Form.MessageAuditor) gt 300>
	  <cf_message message = "You entered a message that exceeded the allowed size of 300 characters."
	  return = "back">
	  <cfabort>
</cfif>

<cfparam name="Form.Enforce" default="0">

<cfif ParameterExists(Form.Update)>
	
	<cftransaction>
	
	<cfquery name="Update" 
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_Validation
	SET   Description        = '#Form.Description#',
		  MessagePerson      = '#Form.MessagePerson#',
		  MessageAuditor     = '#Form.MessageAuditor#',
		  Color              = '#Form.Color#',
		  Operational        = '#Form.Operational#',
		  ValidationPath     = '#Form.ValidationPath#',
		  ValidationTemplate = '#Form.ValidationTemplate#',
		  Enforce            = '#Form.Enforce#',
		  Remarks            = '#Form.Remarks#'
	WHERE Code    = '#Form.Code#'
	</cfquery>
	
	<cfquery name="Get" 
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_Validation
	WHERE Code    = '#Form.Code#'
	</cfquery>
	
	<cfquery name="Clear" 
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE FROM Ref_DutyStationValidation
		WHERE ValidationCode = '#Form.Code#'
	</cfquery>
	
	<cfquery name="Actor" 
			datasource="AppsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM  Ref_DutyStationActor
			ORDER BY ListingOrder
	</cfquery>
			
	
	<cfquery name="Event" 
		datasource="AppsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM  Ref_ClaimEvent
	</cfquery>
	
	<cfset cnt=0>
	
	<cfif #get.ValidationClass# eq "Initial" 
	  or #get.ValidationClass# eq "Submission"
	  or #get.ValidationClass# eq "Express">
	
	<!--- no actors involved --->
	
	<cfelse>
	
		<cfif get.ValidationClass neq "Threshold1" and
			  get.ValidationClass neq "Threshold2" and
			  get.ValidationClass neq "Rule2">
			  	  	  
				  <cfloop query="Actor">
				  
				     <cfset cnt = cnt+1>
					 <cfparam name="Form.Selected_#cnt#" default="0">
					 <cfset sel = evaluate("Form.Selected_#cnt#")> 
					 
					 <cfif sel eq "1">
					 
						 <cfquery name="Insert" 
							datasource="AppsTravelClaim" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							INSERT INTO Ref_DutyStationValidation
							(Mission,
							 ValidationCode,
							 ClearanceActor,
							 OfficerUserid,
							 OfficerLastName,
							 OfficerFirstName)
							VALUES
							('#Mission#',
							'#Form.Code#',
							'#ClearanceActor#',
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#')
					     </cfquery>
					 
					 </cfif>
					 
				  </cfloop>
			  
						 
		<cfelseif #get.ValidationClass# eq "Threshold1">	
		
		      <cfquery name="Category" 
				datasource="AppsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM  Ref_ClaimCategory
				WHERE ListingOrder < '99' and ClaimAmount = 1 
			  </cfquery>
		
			  <cfloop query="Category">
			  
			      <cfset cde = "#Code#">
				  
				  <cfloop query="Actor">
				  
				      <cfset mis = "#Mission#">
    				  <cfset act = "#ClearanceActor#">
					  
					  <cfset cnt = cnt+1>
					 <cfparam name="Form.Selected_#cnt#" default="0">
					 <cfset sel = evaluate("Form.Selected_#cnt#")> 
										 
					 <cfif sel eq "1">
					 
						 <cfset amt = evaluate("Form.Amount_#cnt#")> 
						 <cfif amt eq "">
						 	<cfset amt = 0>
						 </cfif>
					 
						 <cfquery name="Insert" 
							datasource="AppsTravelClaim" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							INSERT INTO Ref_DutyStationValidation
							(Mission,
							 ValidationCode, 
							 ClearanceActor,
							 ClaimCategory,
							 ThresholdAmount,
							 OfficerUserid,
							 OfficerLastName,
							 OfficerFirstName)
							VALUES
							('#Mis#',
							'#Form.Code#',
							'#act#',
							'#cde#',
							'#amt#',
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#')
					     </cfquery>
					 
					 </cfif>
					  
				  </cfloop>
			  </cfloop>	 
		
		<!--- cat --->
		
		<cfelseif get.ValidationClass eq "Threshold2">
		
		<!---cat+ind --->
		
		<cfquery name="Category" 
			datasource="AppsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM  Ref_ClaimCategoryIndicator C, Ref_Indicator R
			WHERE R.Code = C.IndicatorCode
			AND   C.EnableThreshold = 1
			</cfquery>
		
			  <cfloop query="Category">
			  
			      <cfset cde = "#Code#">
				  <cfset cat = "#ClaimCategory#">
				  
				  <cfloop query="Actor">
				  
				      <cfset mis = "#Mission#">
    				  <cfset act = "#ClearanceActor#">
					  
					  <cfset cnt = cnt+1>
					   <cfparam name="Form.Selected_#cnt#" default="0">
					 <cfset sel = evaluate("Form.Selected_#cnt#")> 
										 
					 <cfif sel eq "1">
					 
						 <cfset amt = evaluate("Form.Amount_#cnt#")> 
						 <cfif amt eq "">
						 	<cfset amt = 0>
						 </cfif>
					 
						 <cfquery name="Insert" 
							datasource="AppsTravelClaim" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							INSERT INTO Ref_DutyStationValidation
							(Mission,
							 ValidationCode,
							 ClearanceActor,
							 ClaimCategory,
							 IndicatorCode,
							 ThresholdAmount,
							 OfficerUserid,
							 OfficerLastName,
							 OfficerFirstName)
							VALUES
							('#Mis#',
							'#Form.Code#',
							'#act#',
							'#cat#',
							'#cde#',
							'#amt#',
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#')
					     </cfquery>
					 
					 </cfif>
					  
				  </cfloop>
			  </cfloop>	 
		
		
		<cfelse>
		
		 <cfloop query="Actor">
			  
			      <cfset mis = "#Mission#">
				  <cfset act = "#ClearanceActor#">
				  
				  <cfloop query="Event">
					  <cfset cnt = cnt+1>
					   <cfparam name="Form.Selected_#cnt#" default="0">
					 <cfset sel = evaluate("Form.Selected_#cnt#")> 
										 
					 <cfif sel eq "1">
									
					 
						 <cfquery name="Insert" 
							datasource="AppsTravelClaim" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							INSERT INTO Ref_DutyStationValidation
							(Mission,
							 ValidationCode,
							 ClearanceActor,
							 EventCode,
							 OfficerUserid,
							 OfficerLastName,
							 OfficerFirstName)
							VALUES
							('#Mis#',
							'#Form.Code#',
							'#act#',
							'#Code#',
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#')
					     </cfquery>
					 
					 </cfif>
					  
				  </cfloop>
			  </cfloop>	 
		
		<!--- event --->
		
		</cfif>	
		
	</cfif>	
		
	</cftransaction>
	
</cfif>
	

<script language="JavaScript">
   
     window.close()
	 opener.history.go()
        
</script>  
