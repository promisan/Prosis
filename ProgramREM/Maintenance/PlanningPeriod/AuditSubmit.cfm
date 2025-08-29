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
<cfparam name="Form.ShowGraph" default="0">
<cfset url.row = "6">

<cfset dateValue = "">
<CF_DateConvert Value="#Form.AuditDate#">
<cfset Dte = dateValue>		

<cfquery name="Check" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   Ref_Period A 
WHERE  Period = '#URL.ID#'
</cfquery>

<cfif Dte gte Check.DateEffective-1 AND Dte lte Check.DateExpiration> 

	<!--- define correct subperiod --->
	<cfquery name="SubPeriod" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_SubPeriod A 
	</cfquery>
	
	<cfset days = (#Check.DateExpiration# - #Check.DateEffective# + 1)/#SubPeriod.RecordCount#>
	<cfset dayI = #dte# - #Check.DateEffective# + 1>
	<cfset ratio = int(#dayI#/#days#)+1>
			
	<cfloop query="subperiod" startrow="1" endrow="#ratio#">
	 <cfset sub = #SubPeriod.SubPeriod#>
	</cfloop>
			
	<cfif url.action eq "insert">
	
	<!--- check existing --->
	
	<cfquery name="Check" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  * 
		FROM    Ref_Audit  
		WHERE   AuditDate = #Dte#
		AND     Period = '#URL.ID#'
		</cfquery>		
		
		<cfif Check.recordcount eq "0">
				
			<cfquery name="Insert" 
			datasource="AppsProgram" 
			username=#SESSION.login# 
			password=#SESSION.dbpw#>
			INSERT INTO Ref_Audit  
			         (Period, 
					  AuditDate,
					  SubPeriod,
					  Description,
					  ShowGraph,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName,
					  Created)
			  VALUES ('#URL.ID#', 
			  		  #Dte#,
					  '#Sub#',
					  '#Form.Description#', 
					  '#Form.ShowGraph#',
			  		  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#',
					  getDate())
			</cfquery>	
			
			<cfquery name="Check" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   SELECT * 
	    	   FROM   Ref_Audit  
			   WHERE  AuditDate = #Dte#
			   AND    Period = '#URL.ID#'
			</cfquery>	
					
			<cfset id = "#Check.AuditId#">
									
		<cfelse>
		
			<cfset id = "">
		
		</cfif>	
			
	</cfif>	
	
	<cfif url.action eq "edit">
	
	    <cfquery name="Update" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Ref_Audit  
		SET    AuditDate = #Dte#, 
		       Description = '#Form.Description#',
			   SubPeriod = '#Form.SubPeriod#',
			   ShowGraph  = '#Form.ShowGraph#'
		WHERE  AuditId = '#Form.AuditId#'
		</cfquery>	
		
		<cfset id = "#Form.AuditId#">
	
	</cfif>
	
	<!--- define classes --->
	
	<cfif id neq "">
			
	    <cfquery name="Delete" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE 
		FROM    Ref_AuditClass  
		WHERE   AuditId = '#id#'
		</cfquery>	
		
		<cfloop index="itm" from="1" to="#URL.Row#">		
				
			<cfparam name="Form.AuditClass_#itm#" default="">
			<cfset cls = Evaluate("FORM.AuditClass_" & #itm#)>
			<cfparam name="Form.AuditLabel_#itm#" default="">
			<cfset lbl = Evaluate("FORM.AuditLabel_" & #itm#)>
						
			<cfif cls neq "">
			
				<cfquery name="Insert" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO Ref_AuditClass  
				         (AuditId, 
						  AuditClass,
						  AuditLabel,
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName,
						  Created)
				  VALUES ('#ID#', 
				  		  '#cls#',
						  '#lbl#',
				  		  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#',
						  getDate())
				</cfquery>	
					
			</cfif>
			
		</cfloop>
	
	</cfif>
	
	
	<cfinclude template="../../Application/Tools/ZeroBaseRatio.cfm">	
		
	<cfinclude template="Audit.cfm">		  
	
		
<cfelse>

	<script language="JavaScript">
	
		alert("You entered a date that lies outside the period. Operation not allowed.")		
		
	</script>
	
	<cfinclude template="Audit.cfm">		
		
</cfif>	



	

