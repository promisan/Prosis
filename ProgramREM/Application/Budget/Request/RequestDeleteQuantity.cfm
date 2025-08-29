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
<cfparam name="url.itemmaster" default="all">
<cfparam name="url.mode"       default="default">
<cfparam name="url.objectcode" default="">



<cfquery name="Selected" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT * FROM ProgramAllotmentRequest															
		WHERE     RequirementId = '#requirementId#'
</cfquery>

<cfquery name="Object" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT * FROM Ref_Object															
		WHERE     Code = '#Selected.ObjectCode#'
</cfquery>

<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM       Program
	WHERE      ProgramCode = '#Selected.programCode#'			
</cfquery>

<!--- perform the action --->

<cfquery name="check" 
	 datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT * 
		FROM   ProgramAllotmentRequestQuantity																
		WHERE  RequirementId = '#requirementId#'
</cfquery>

<cfif url.objectcode neq "">
	<cfset selObjectcode = url.objectcode>
<cfelse>
    <cfset selObjectcode = selected.objectcode>
</cfif>

<cfif check.recordcount lte "1">

	<cfinclude template="RequestDelete.cfm">

<cfelse>

<cftransaction>
						
<!--- delete request quantity --->

<cfquery name="delete" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
			DELETE 
			FROM    ProgramAllotmentRequestQuantity																
			WHERE   RequirementId = '#requirementId#'
			AND     AuditId       = '#url.auditid#'
</cfquery>			

<!--- recalculate requirement --->

<cfquery name="Header" 
		  datasource="AppsProgram" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			UPDATE    ProgramAllotmentRequest
			SET       ResourceQuantity =
	                          (SELECT     ISNULL(SUM(ResourceQuantity),1)   <!--- correction hanno 21/10/2016 as ripple did not work --->
	                            FROM      ProgramAllotmentRequestQuantity
	                            WHERE     RequirementId = '#requirementId#'),
					  ResourceDays =
	                          (SELECT     ISNULL(SUM(ResourceDays),0)
	                            FROM      ProgramAllotmentRequestQuantity
	                            WHERE     RequirementId = '#requirementId#'),
					  RequestQuantity =
	                          (SELECT     ISNULL(SUM(RequestQuantity),0)
	                            FROM      ProgramAllotmentRequestQuantity
	                            WHERE     RequirementId = '#requirementId#'),		
					  RequestDue = 	
						  	 (SELECT      MIN(AuditDate)
							    FROM      ProgramAllotmentRequestQuantity Q, Ref_Audit R
								WHERE     Q.AuditId = R.AuditId
	                            AND       RequirementId = '#requirementId#')							  		
												
			WHERE     RequirementId = '#url.requirementId#'
	</cfquery>		
	
	<!--- correcion 30/10/2014 if resource quantity = NULL, we a pply a ceiling / 12 --->
			
	<cfquery name="Header" 
		  datasource="AppsProgram" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			UPDATE    ProgramAllotmentRequest
			SET       ResourceQuantity = CEILING(RequestQuantity/12)													
			WHERE     RequirementId = '#url.requirementId#'
			AND       ResourceQuantity is NULL
	</cfquery>											
	
	<!--- now we check oif we change the amount to be released for allotment should change --->
			
	<cfquery name="get" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
			FROM   ProgramAllotmentRequest
			WHERE  RequirementId = '#RequirementId#'	
	</cfquery>													
				   
	<cfif get.AmountBaseAllotment neq get.RequestAmountBase>				
			
		<cfquery name="set" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE ProgramAllotmentRequest
			SET    AmountBaseAllotment = '#get.RequestAmountBase#'
			WHERE  RequirementId = '#RequirementId#'	
		</cfquery>
			
	</cfif>		
	
	<!--- ------------------------ --->
	<!--- now we apply the ripples --->
	<!--- ------------------------ --->
	
	<cfset budgetmode = "2">
	
	<cfquery name="Parent" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT  *
		FROM    ProgramAllotmentRequest
		WHERE   RequirementIdParent = '#selected.requirementIdParent#' 
		AND     Period              = '#selected.Period#'		
	</cfquery>	
	
	<cfset reqlist = "">
	
	<cfloop query="Parent">
	
		<cfif reqlist eq "">
			<cfset reqlist = "#requirementId#">
		<cfelse>	
		    <cfset reqlist = "#reqlist#,#requirementId#">
		</cfif>
	
	</cfloop>  
	
	<cfset st = "1">				
	<cfset row = 0>

	<cfloop index="requirementid" list="#reqlist#">

		<cfinclude template="RequestSubmitRipple.cfm">

	</cfloop>			
	
	<!--- make a copy of the new adjusted header line --->			
	
	<cfif check.recordcount gt "1">
	
	<cfinvoke component = "Service.Process.Program.ProgramAllotment"  
		   method           = "LogRequirement" 
		   RequirementId    = "#url.RequirementId#">	
		   
	</cfif>	   
		   
	<!--- put the ProgramAllotmentDetail in sync with the requirements --->	   
			   
	<cfinvoke component = "Service.Process.Program.Program"  
		   method           = "SyncProgramBudget" 
		   ProgramCode      = "#selected.ProgramCode#" 
		   Period           = "#selected.Period#"
		   EditionId        = "#selected.EditionId#">	
		   
	</cftransaction>		   			   
					   

</cfif>			

<cfoutput>
	
	<script>	
		ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestResourceDetail.cfm?mission=#program.mission#&programcode=#selected.programCode#&period=#selected.period#&editionid=#selected.EditionId#&objectcode=#selObjectCode#&cell=#url.cell#','box#url.cell#')			
	</script>
	
</cfoutput>			   		