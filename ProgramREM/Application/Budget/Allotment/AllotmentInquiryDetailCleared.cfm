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

<cfparam name="init" default="0">

<cfif init eq "0">

	<cfinclude template="setAllotmentAmount.cfm">
	
	<!--- refresh --->
	
	<cfoutput>
		<script>
		 try {
		   ColdFusion.navigate('#SESSION.root#/programrem/application/budget/allotment/getRequirementAllocation.cfm?requirementid=#url.requirementid#','#url.requirementid#_detail')
		 } catch(e) {} 
		
		</script>
	</cfoutput>											 
	
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
				 (SELECT TOP 1 RequirementId 
				  FROM   ProgramAllotmentDetailRequest 
				  WHERE  TransactionId = P.TransactionId) as RequirementId			 
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
								   WHERE  Period       = '#url.period#'
								   AND    PeriodHierarchy LIKE '#url.programhierarchy#%')		
		</cfif>
		
		<!--- period --->	
		AND      PR.Mission    = '#URL.Mission#'
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
				 								 
		AND      P.Status IN ('0','1') <!--- all lines of allotment --->
		
		ORDER BY P.Status,P.TransactionDate
		
	</cfquery>
	
</cfif>	

<cfparam name="detail.transactionid" default="">

<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">  	
		
	 <cfif detail.transactionid neq "">	     
		 
		  <cfquery name="Totals" 
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		 	 SELECT  ISNULL(SUM(AmountBaseAllotment*AmountBasePercentageDue),0) as TotalRelease
			 FROM    ProgramAllotmentRequest
			 WHERE   RequirementId IN (
				                       SELECT RequirementId
				                       FROM   ProgramAllotmentDetailRequest AR 
								       WHERE  TransactionId IN (#quotedValueList(detail.transactionid)#)
									   )
			 AND      ActionStatus = '1'
		 </cfquery>
		 
		 <cfquery name="Check" 
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT     *
		     FROM       ProgramAllotment P
		     WHERE      P.EditionId   = '#url.Edition#'					
			 AND        P.ProgramCode = '#url.ProgramCode#'
			 AND        P.Period      = '#url.period#' 
		</cfquery>  	
		 
		<cfset release   = 	0>
		<cfif check.recordCount gt 0 and Totals.recordCount gt 0>
			<cfset release   = 	Round(Totals.TotalRelease   / check.amountrounding) * check.amountrounding>
		</cfif>		
					
	 	<cfoutput> 
		    <tr><td height="5"></td></tr>
		    <tr class="line">
			  <td class="labelmedium" colspan="9" style="font-weight:200;font-size:20px;padding-left:0px">Due for Allocation: <b>#numberformat(Totals.TotalRelease,',__.__')#</b> (<font color="008000">--> rounded: #numberformat(release,',__.__')#</font>)</td></tr>
			<tr><td height="5"></td></tr>
		</cfoutput>
	   
	 </cfif>	
	 
	 <cfquery name="getProgram" 
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT     *
		     FROM       Program P
		     WHERE      P.ProgramCode = '#url.ProgramCode#'			 
	 </cfquery>  		
	 
	  <cfquery name="Param" 
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT     *
		     FROM       Ref_ParameterMission 
		     WHERE      Mission = '#getProgram.Mission#'			 
	 </cfquery>  		  
	 
	 <cfoutput>
	
	 <tr class="labelmedium line">
		   <td style="padding-right:4px"></td>			   
		   <td style="padding-right:4px"><cf_tl id="Fund"></td> 
		   <td style="padding-right:4px"><cf_tl id="Object"></td>
	       <td style="padding-right:4px"><cf_tl id="Date"></td>
		   <td style="padding-right:4px"><cf_tl id="Program"></td>		
		   <td style="padding-right:4px"></td>	   
		   <td style="padding-right:4px"><cf_tl id="Officer"></td>
		      
		   <td style="padding-left:4px;padding-right:4px"><cf_tl id="Status"></td>
		   <td align="right" style="min-width:120px;padding-right:4px"><cf_tl id="Amount">#Detail.Currency#</td>	
	 </tr>
	 
	 </cfoutput> 
	  			 
	 <cfoutput query="Detail">
	 
	 <tr id="t#requirementid#" class="navigation_row labelmedium line">
	 
	    <td width="20"  style="padding-left:4px;padding-right:4px" align="center">#currentrow#.</td>		
	    <td width="80"  style="padding-right:4px">#Fund#</td>
		<td width="120" style="padding-right:4px">#ObjectCode#<!--- <font size="1">(#CodeDisplay#)</font> ---></td>
	    <td width="90" align="center">#dateformat(TransactionDate,CLIENT.DateFormatShow)#</td>			
		<td width="55%" style="padding-left:4px;padding-right:4px">	
			
		    #ProgramName#  
			
			<cfif actionId neq "">
				
				<cfquery name="Action" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     ProgramAllotmentAction
					WHERE    ActionId = '#ActionId#'	
				</cfquery>
					
				: #Action.ActionClass# #Action.ActionMemo#
				
			</cfif>	
			
		</td>		
		
		
		<cfif Param.EnableForecast eq "1">
		
			<cfif requirementid neq "">
			    <cfset req = requirementid>
			<cfelse>
				<cfset req = transactionid>
			</cfif>
		
			<td width="80"  style="min-width:120px;padding-right:4px;padding-top:0px" onmouseover="cursor:pointer"
			   onclick="ProcReqNew('#getProgram.mission#','budget','#req#','#url.period#','#rowguid#')">
			  			  	
				<!--- adding a requisition --->		
				<cfif url.resource neq "resource" and detail.status eq "1">				
					<u><font color="0080C0"><cf_tl id="Add pre-encum"></font></u>				
				</cfif>
				
			</td>
		
		<cfelse>
		
		<td></td>	
		
		</cfif>
		
		</td>	
		<td width="10%" style="padding-left:3px">#OfficerLastName#</td>   
		
		<cfif Detail.Status eq "1">
		
			<td style="min-width:100px;padding-left:0px;border:1px solid silver"  bgcolor="00FF00">
			
				<table width="100%">
					<tr class="labelmedium"><td style="text-align:center;padding-left:4px;padding-right:5px"><cf_tl id="Cleared"></td>
					
					<!--- disabled hanno 10/12/2017 as i think removing this should be done from the maintenance control for the program
					<cfif ActionId neq "" and getAdministrator("*") eq "1">
					
						<cfif Action.ActionType eq "Transfer" or Action.ActionType eq "Amendment"> 
						
							<td style="padding-left:3px;padding-right:3px">
							<img style="cursor:pointer" src="#SESSION.root#/images/delete5.gif"				
							onclick="ptoken.navigate('#SESSION.root#/programrem/application/budget/allotment/AllotmentVerify.cfm?delete=#action.actionid#&isParent=#url.isParent#&programcode=#url.programcode#&period=#url.period#&edition=#url.edition#&fund=#url.fund#&object=#url.object#')#','')"				
							border="0" height="11" width="11" align="absmiddle">
							</td>
							
						</cfif>			
						
						
					</cfif>
					
					--->
					
					</tr>
				</table>
			
			</td>
			
		<cfelseif Detail.status eq "0">
		
			<td style="text-align:center;border:1px solid silver;padding-left:4px;padding-right:3px" bgcolor="yellow"><cf_tl id="Pending"></td>
		
		<!---	
		<cfelse>	
				
			<td width="10%" style="border:1px solid silver;padding-left:4px;padding-right:0px" class="labelit" bgcolor="d4d4d4"><i>On Hold</td>						
			--->
			
		</cfif>
		
		<td colspan="1" style="padding-right:4px" width="10%"	align="right" id="t#transactionid#">#numberformat(amount,",__")#</td>		
	
			
	</tr>
		
	<cfif actionid neq "">
	
		<cfquery name="Related" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    Fund,
				          ObjectCode,
						  ActionId,					  				 
						  A.TransactionDate, 
						  TransactionType, 
						  A.OfficerLastName, 
				          O.CodeDisplay, 
						  P.ProgramName, 
						  A.Status,
						  
						  (  SELECT Reference 
						     FROM   ProgramAllotmentAction 
						     WHERE  ActionId = A.Actionid  ) as Reference,
							 
						  SUM(Amount) as Total
				FROM      ProgramAllotmentDetail A,			 
				          Ref_Object O, 
						  Program P
				WHERE     P.ProgramCode    = '#ProgramCode#' 
				AND       TransactionId   <> '#transactionid#' 
				AND       ActionId         = '#actionid#'
				AND       A.ObjectCode     = O.Code
				AND       A.ProgramCode    = P.ProgramCode
				AND       Amount <> 0
				AND       A.Status != '9'
				
				GROUP BY  Fund,
				          ObjectCode,
						  ProgramName,
						  A.Status,
						  CodeDisplay,
						  ActionId,
						  TransactionDate,
						  TransactionType,
						  A.OfficerLastName
						  
				ORDER BY  ObjectCode
		</cfquery>
		
		<cfif related.recordcount gte "1">
		
		<tr><td colspan="9" class="line"></td></tr>
		
		<tr>
		    <td></td>
			<td colspan="6" class="labelit" style="height:30px;padding-left;4px"><font color="0080C0">Other transaction submitted under #Related.reference#</font></td>
		</tr>
		
		</cfif>
		
		<cfloop query="related">
		
			<tr class="labelmedium line" style="height:15px">
			    <td width="30"  style="padding-left:8px" align="center"></td>
			    <td width="80"  style="padding-left:8px" align="center"><font color="808080">#Fund#</td>
				<td width="120" style="padding-left:8px"><font color="808080">#ObjectCode#<!---&nbsp;<font size="1">(#CodeDisplay#)</font>---></td>
			    <td width="90"  class="labelit" align="center"><font color="808080">#dateformat(TransactionDate,CLIENT.DateFormatShow)#</td>					
				<td width="60%" style="padding-left:8px"><font color="808080"><!---#ProgramName#---></td>	
			
				<cfif Status eq "1">				
					<td width="10%" style="padding-left:3px;padding-right:5px"><font color="gray"><cf_tl id="cleared"> <cfif TransactionType eq "support">Support</cfif></td>					
				<cfelseif Status eq "0">				
					<td width="10%" style="padding-left:3px;padding-right:5px"><font color="808080">Pending <cfif TransactionType eq "support">Support</cfif></td>					
				<cfelse>					
					<td width="10%" style="padding-left:3px;padding-right:5px"><font color="silver">On Hold <cfif TransactionType eq "support">Support</cfif></td>										
				</cfif>
				
				<td width="10%" style="padding-left:2px"><font color="808080">#OfficerLastName#</td>   
				<td colspan="2" style="padding-right:2px" width="10%" align="right"><font color="808080">#numberformat(Total,",__")#</td>	
			</tr>		
		
		</cfloop>	
			
	</cfif>
			
	</cfoutput>	
	
	<cfoutput>
	
	<tr><td colspan="9" id="requisition_#rowguid#">	
	    <cfset url.box = rowguid>
		<cfinclude template="AllotmentInquiryDetailRequisition.cfm">	
	</td></tr>
	
	<tr><td colspan="9" class="hide">
	
		<a id="refresh_#rowguid#" 
		   href="javascript:preencdetail('#url.programcode#','#url.programhierarchy#','#url.period#','#url.edition#','#url.fund#','#url.object#','#rowguid#','#url.isparent#','#url.resource#')">R</a>
	
	</td></tr>
	
	</cfoutput>
	
</table>

<cfoutput>
<script>
	if (document.getElementById('box#url.edition#')) {	    
		_cf_loadingtexthtml='';	
		ptoken.navigate('AllotmentClear.cfm?programcode=#url.programcode#&period=#url.period#&editionid=#url.edition#','box#url.edition#')	
		ptoken.navigate('AllotmentInquiryAmount.cfm?scope=detail&programcode=#url.programcode#&period=#url.period#&editionid=#url.edition#&objectcode=#url.object#&execution=0','moveresult') 	
	}
</script>
</cfoutput>

<cfif init eq "0">
	<cfset ajaxOnLoad("doHighlight")>
</cfif>

