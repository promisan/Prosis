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
<cfparam name="url.resource"         default="">
<cfparam name="url.status"           default="">
<cfparam name="url.mode"             default="listing">
<cfparam name="url.programhierarchy" default="">

<!---
	<cfoutput>
	----#url.programcode#:#url.period#:#url.edition#----
	</cfoutput>
--->	

<!--- get the edition --->
				
<cfquery name="Edition" 
    datasource="AppsProgram" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
       SELECT *
       FROM   Ref_AllotmentEdition
	   WHERE  EditionId = '#URL.Edition#' 
</cfquery>

<cfif url.status eq "1" and Edition.AllocationEntryMode eq "2">

	<!--- redirect --->	
	<cfinclude template="../Allocation/AllocationInquiryDetail.cfm">
	
<cfelse>
		
	<!--- transaction detail show for project/period and edition the transactions for the selected
	      object and fund from ProgramAllotmentDetail	  
		  also for requirement allow for drill one level more
	 --->
	  
	<cfquery name="Object" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_Object
		WHERE  Code = '#url.object#'	
	</cfquery>	
	
	<cfif url.resource eq "resource">
	   <cfset res = Object.Resource>
	<cfelse>
	   <cfset res = "">  
	</cfif>
	
	<cfquery name="Program" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Program 
		WHERE  ProgramCode = '#URL.ProgramCode#'
	</cfquery>
	
	<cfquery name="ProgramAllotment" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  * 
		FROM    ProgramAllotment 
		WHERE   ProgramCode = '#url.ProgramCode#'
		AND     Period      = '#url.Period#'				
		AND     EditionId   = '#url.Edition#' 	
	</cfquery>
				  
	<cfquery name="Detail" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   P.*, 
		         PR.ProgramName, 
		         R.Period as ExecutionPeriod, 				 
				 R.BudgetEntryMode,
				 P.ActionId,
				 O.CodeDisplay,
				 (SELECT TOP 1 RequirementId FROM ProgramAllotmentDetailRequest WHERE TransactionId = P.TransactionId) as RequirementId			 
		FROM     ProgramAllotmentDetail P, 
		         Ref_AllotmentEdition R,
				 Program PR,
				 Ref_Object O
		WHERE    P.ProgramCode = PR.ProgramCode		
		AND      O.Code = P.ObjectCode 
		
		<!--- program --->	
		<cfif url.programhierarchy eq "" or url.programhierarchy eq "undefined">			
		AND      P.ProgramCode = '#URL.ProgramCode#'		
		<cfelse>		
		AND      P.ProgramCode IN (SELECT ProgramCode 
				                   FROM   ProgramPeriod 
								   WHERE  Period = '#url.period#'
								   AND    PeriodHierarchy LIKE '#url.programhierarchy#%')		
		</cfif>
		
		<!--- period --->	
		AND      PR.Mission = '#Program.Mission#'
		AND      P.Period      = '#URL.Period#'		
		
		<!--- edition --->	
		AND      P.EditionId   = '#url.edition#' 	
		AND      P.EditionId   = R.EditionId	
			
		<!--- fund --->	
		<cfif url.fund neq "Total" and url.fund neq "">
		AND      P.Fund      = '#url.fund#'
		</cfif>		
		
		<!--- object,parent,resource --->	
		<cfif url.resource eq "resource">		
			AND     P.ObjectCode IN (SELECT Code FROM Ref_Object WHERE Resource = '#res#')			
		<cfelseif url.isParent eq "1">			
			AND    (
		          P.ObjectCode = '#url.object#' OR 
	              P.ObjectCode IN (SELECT Code 
	                               FROM   Ref_Object 
						           WHERE  ParentCode = '#url.object#')
	        	   ) 		
		<cfelse>		
			AND     P.ObjectCode  = '#url.object#'		
		</cfif>
		
		AND      (
		          abs(amount) > 0.05 OR TransactionId IN (SELECT TransactionId 
		                                                  FROM   ProgramAllotmentDetailRequest 
														  WHERE  TransactionId = P.TransactionId)  <!--- has been triggered by a requirement --->
				 )				 								 
		AND      P.Status IN ('P','0','1') <!--- all lines of allotment --->		
		ORDER BY P.Status,P.TransactionDate
		
	</cfquery>
	
	<!--- 8/6 provision to show transaction in pipeline but that have not reached yet --->
	
	<table width="100%" cellspacing="0" cellpadding="0"><tr><td style="padding:0px">
	
	<tr><td style="padding:5px">
		 
		 	<table width="100%" cellspacing="0" cellpadding="0">
		 
			 <cfif detail.recordcount neq "0">
			 
				 <tr>
				 <td colspan="1" class="labelmedium" valign="top" style="height:35px;font-size:20px;padding-top:6px;padding-left:25px;padding-right:4px">
				
					 <cfoutput>					 
					 <cf_tl id="Plan Period">: <b>#URL.Period#</b> <cf_tl id="Budget Execution">: <b><cfif detail.executionPeriod eq "">All<cfelse>#detail.executionPeriod#</cfif></b>
					 </cfoutput>
				
				 </td>
				 
				 <cfoutput>
				 
				 <td colspan="1" align="right">
					 <cfif (Detail.BudgetEntryMode eq "1" or Program.EnforceAllotmentRequest eq "1") and url.mode eq "detail">
						 <a id="verify_#url.object#_#URL.edition#" 
						    href="#ajaxlink('#SESSION.root#/ProgramREM/Application/Budget/Allotment/AllotmentVerify.cfm?programhierarchy=#url.programhierarchy#&resource=#url.resource#&isParent=#url.isParent#&programcode=#url.programcode#&period=#url.period#&edition=#url.edition#&fund=#url.fund#&object=#url.object#')#"><font color="6688aa">[Refresh and Validate]</a>&nbsp;
					 </cfif>	 
				 </td>
				 
				 </cfoutput>
				 </tr>
				 
			 </cfif> 
		 
			 <cfquery name="Total" dbtype="query">
				SELECT   sum(Amount) as TotaL 
				FROM     Detail
			</cfquery>
			
			 <cfinvoke component="Service.Access"  <!--- get access levels based on top Program--->
					Method         = "budget"
					ProgramCode    = "#URL.ProgramCode#"
					Period         = "#URL.Period#"	
					EditionId      = "#URL.edition#"  
					Role           = "'BudgetManager'"
					ReturnVariable = "BudgetAccess">	
			 
			 <cfif detail.recordcount eq "0" or abs(total.total) lt 0.5>
											
				<cfif BudgetAccess eq "ALL" and url.fund neq "Total" and url.fund neq "">	
				
				<cf_assignid>			
				 
				<tr><td colspan="2" height="20" bgcolor="ffffff" class="labelmedium" align="center" 
				   id="enforce<cfoutput>#rowguid#</cfoutput>">
					  
					<cfquery name="CheckEntry" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT   *
						FROM     ProgramObject 
						WHERE    ProgramCode = '#URL.ProgramCode#'
						AND      Fund        = '#url.fund#'
						AND      ObjectCode  = '#url.object#'		
					</cfquery>
					
					<cfoutput>
					
						<img src="#SESSION.root#/images/finger.gif" border="0" align="absmiddle">
						
						<!--- to be defined if we can do this from here
						<cfif url.mode eq "detail">
						--->
						
						<cfif CheckEntry.recordcount eq "1">
						  		
							<a href="javascript:ColdFusion.navigate('#SESSION.root#/ProgramREM/Application/Budget/Allotment/AllotmentInquiryEnforce.cfm?action=0&programcode=#url.programcode#&object=#url.object#&fund=#url.fund#&rowguid=#rowguid#','enforce#rowguid#')">
							<font color="green">No records found but this #url.fund# and #url.object# combination will be shown to the requester for selection. </font>
							</a>					
							
						<cfelse>	
							
							<a href="javascript:ColdFusion.navigate('#SESSION.root#/ProgramREM/Application/Budget/Allotment/AllotmentInquiryEnforce.cfm?action=1&programcode=#url.programcode#&object=#url.object#&fund=#url.fund#&rowguid=#rowguid#','enforce#rowguid#')">
							<font color="6688aa">This #url.fund# and #url.object# combination is not accessible for funding for the requester as there are NO budget/allotment records recorded. </font>
							</a>
							
						</cfif>													
					
					</cfoutput>
					 
				 </td></tr>
				 
				 </cfif>
			 
			 </cfif>
			 
			 <cfinvoke component="Service.Process.Program.ProgramAllotment"  <!--- get access levels based on top Program--->
				Method         = "RequirementStatus"
				ProgramCode    = "#URL.ProgramCode#"
				Period         = "#URL.Period#"	
				EditionId      = "#URL.edition#" 
				ReturnVariable = "RequirementLock">			
										
			 <cfinvoke component="Service.Access"  <!--- get access levels based on top Program--->
				Method         = "budget"
				ProgramCode    = "#URL.ProgramCode#"
				Period         = "#URL.Period#"	
				EditionId      = "#URL.edition#"  
				Role           = "'BudgetOfficer','BudgetManager'"
				ReturnVariable = "BudgetOfficer">							
		 
		 	<tr>
			   <td colspan="2" style="padding:2px;padding-left:12;padding-right:12px"> 			   	 
		  	   <cfinclude template="AllotmentInquiryDetailData.cfm">						 	   
			   </td>
			</tr>
			
			<tr><td style="height:10px"></td></tr>
			
			</table>
				
	</td>
	</tr>	
	
	</table>
	
</cfif>	
	  

