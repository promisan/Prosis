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
		  
	<cfquery name="Detail" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   P.*, 
		         PR.ProgramName, 
		         R.Period as ExecutionPeriod, 
				 R.BudgetEntryMode,				 
				 O.CodeDisplay			 
		FROM     ProgramAllotmentAllocationDetail P, 
		         Ref_AllotmentEdition R,
				 Program PR,
				 Ref_Object O
		WHERE    P.ProgramCode = PR.ProgramCode		
		AND      O.Code        = P.ObjectCode 
		
		<!--- period --->	
		AND      PR.Mission    = '#Program.mission#'
		AND      P.Period      = '#URL.Period#'
		AND      P.EditionId   = R.EditionId
		
		<!--- edition --->	
		AND      P.EditionId   = '#url.edition#' 	
		
		<!--- program --->	
		<cfif url.programhierarchy eq "" or url.programhierarchy eq "undefined">		 
		
		AND      P.ProgramCode = '#URL.ProgramCode#'
		
		<cfelse>
		
		AND      P.ProgramCode IN (SELECT ProgramCode 
				                   FROM   ProgramPeriod Pe
								   WHERE  Pe.Period   = '#url.period#'
								   AND    Pe.PeriodHierarchy LIKE '#url.programhierarchy#%')		
		</cfif>
					
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
		          abs(amount) > 0.05 
				 )						 								 
				
		ORDER BY P.DateAllocation
		
	</cfquery>
	
	
	<table width="100%" cellspacing="0" cellpadding="0"><tr><td style="padding:0px"></td>
	
	<tr><td style="padding:2px">
		 
	 	<table width="100%" cellspacing="0" cellpadding="0">
	 
		 <cfif detail.recordcount neq "0">
		 
			 <tr>
			 <td colspan="1" class="labelmedium" valign="top" style="height:20px;padding-top:6px;padding-left:12px;padding-right:4px">
			
				 <cfoutput>
				 <b><u>Allocation</u></b> for Plan period: <b>#URL.Period#</b> and execution in: <b><cfif detail.executionPeriod eq "">All<cfelse>#detail.executionPeriod#</cfif></b>
				 </cfoutput>
			
			 </td>
						
			 </tr>
		 </cfif> 
	 
		 <cfquery name="Total" dbtype="query">
			SELECT   SUM(Amount) as TotaL 
			FROM     Detail
		</cfquery>
		 
		 <cfif detail.recordcount eq "0" or abs(total.total) lt 0.5>
			 
			  <cfinvoke component="Service.Access"  <!--- get access levels based on top Program--->
						Method         = "budget"
						ProgramCode    = "#URL.ProgramCode#"
						Period         = "#URL.Period#"	
						EditionId      = "#URL.edition#"  
						Role           = "'BudgetManager'"
						ReturnVariable = "BudgetAccess">	
						
			<cfif BudgetAccess eq "ALL" and url.fund neq "Total" and url.fund neq "">	
			
			<cf_assignid>			
			 
			<tr><td colspan="2" bgcolor="ffffff" align="center" 
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
					  		
						<a href="javascript:ptoken.navigate('#SESSION.root#/ProgramREM/Application/Budget/Allotment/AllotmentInquiryEnforce.cfm?action=0&programcode=#url.programcode#&object=#url.object#&fund=#url.fund#&rowguid=#rowguid#','enforce#rowguid#')">
						<font color="green">No records found but this #url.fund# and #url.object# combination will be shown to the requester for selection. </font>
						</a>					
						
					<cfelse>	
						
						<a href="javascript:ptoken.navigate('#SESSION.root#/ProgramREM/Application/Budget/Allotment/AllotmentInquiryEnforce.cfm?action=1&programcode=#url.programcode#&object=#url.object#&fund=#url.fund#&rowguid=#rowguid#','enforce#rowguid#')">
						<font color="6688aa">This #url.fund# and #url.object# combination is not accessible for funding for the requester as there are NO budget/allotment records recorded. </font>
						</a>
						
					</cfif>		
									
				</cfoutput>
				 
			 </td></tr>
			 
			 </cfif>
		 
		 </cfif>
	 
	 	<tr>
		   <td colspan="2" style="padding:2px;border 1px dotted silver;padding-left:40">  			 
		   
			   <table width="96%" cellspacing="0" class="navigation_table"> 
		   
		   	   <tr class="labelit line">
		   
		   		   <td></td>	
		   		   <td>Fund</td> 
				   <td style="padding-left:4px">Object</td>
			       <td>Date Allocation</td>
				   <td>Remarks</td>
				   <td>Officer</td>
				   <td align="right">Amount</td>
			   
			   </tr>
			 	  	   			
				<cfoutput query="detail">
				
				 <tr class="navigation_row line labelit">
				   <td width="30" height="15" align="center">#currentrow#.</td>
	   			   <td>#Fund#</td>
				   <td>#ObjectCode#&nbsp;<font size="1">(#CodeDisplay#)</font></td>	
			       <td>#dateformat(DateAllocation,client.dateformatshow)#</td>
				   <td>#Remarks#</td>
				   <td>#officerFirstName# #officerLastName#</td>
				   <td style="padding-right:4px" align="right">#numberformat(amount,",__")#</td>		   
		        </tr>
								
				</cfoutput>
				
				<cfquery name="total" dbtype="query">
					SELECT   SUM(Amount) as Amount
					FROM     Detail
				</cfquery>
				
				<cfoutput>
				 <tr class="navigation_row line">
				   <td colspan="6" width="30" class="labelit" height="15" align="center"></td>	   			  
				   <td class="labelit" style="padding-right:4px" align="right"><b>#numberformat(total.amount,",__")#</b></td>		   
		        </tr>
				</cfoutput>			
				
					
			</table>		
						 	   
		   </td>
		</tr>
		
		</table>
				
	</td>
	</tr>	
	
	</table>
	
	<cfset ajaxonload("doHighlight")>
		  