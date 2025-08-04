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

<cfquery name="get" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   RequisitionLine
	WHERE  RequisitionNo = '#url.RequisitionNo#'
</cfquery>	

<cfquery name="Funding" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   RequisitionLineFunding
	WHERE  RequisitionNo = '#url.requisitionno#'
	AND    FundingId = '#url.fundingid#'
</cfquery>	

<cfset amount = Funding.Percentage * get.RequestAmountBase>
	
<table width="100%" height="100%" bgcolor="FFFFFC">

<tr><td height="15"></td></tr>
<cfoutput>
<tr>
<td style="width:45px;padding-left:20px" ><img src="#session.root#/images/logos/program/activityblack.png" alt="" width="54" height="54" border="0"></td>

<td width="100%" class="labellarge" style="font-size:25px;padding-left:10px">

	<table>
	
			
		<cfquery name="program" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
			FROM   Program
			WHERE  ProgramCode = '#funding.ProgramCode#'
		</cfquery>	
		
		<tr><td class="labellarge" style="font-size:27px;padding-left:20px"><b>#Program.ProgramName#</td></tr>
		<tr><td class="labellarge" style="font-size:22px;padding-left:20px">
		<cf_tl id="distribute"> #application.basecurrency# #numberformat(amount,",_.__")# <cf_tl id="across activities">
		</tr>
	</table>

</cfoutput>
<tr><td colspan="2" style="padding-left:25px;padding-right:25px;padding-top:15px" height="100%">

	<cf_divscroll>
	
		<table width="100%" class="navigation_table">
		
			<tr class="labelmedium line">
				<td style="width:50%"><cf_tl id="Activity"></td>
				<td><cf_tl id="Effective"></td>
				<td><cf_tl id="Expiration"></td>
				<td><cf_tl id="Percent"></td>
				<td align="right" style="width:100"><cf_tl id="Amount"></td>
			</tr>
					
			<cfquery name="Activity" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
				SELECT    ProgramCode,
						  ActivityPeriod,
				          ActivityId,
				          ActivityDescription,
				          ActivityDateStart,
						  ActivityDateEnd,
						  ActivityCompleted	
						  
				FROM      ProgramActivity A
				WHERE     ProgramCode = '#funding.ProgramCode#' 
				AND       RecordStatus <> '9' OR
		                      (ProgramCode = '#funding.ProgramCode#') AND EXISTS
		                          (SELECT     'X'
		                            FROM       Purchase.dbo.RequisitionLineFundingActivity
									WHERE      RequisitionNo = '#funding.RequisitionNo#'
		                            AND        ActivityId    = A.ActivityId)
				ORDER BY ActivityDateStart					
			</cfquery>		
		
			<cfoutput query="Activity">		
							
				  <cfquery name="get" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
						
					SELECT    *			  
					FROM      RequisitionLineFundingActivity
					WHERE     RequisitionNo = '#funding.RequisitionNo#'
			        AND       ActivityId = '#activityid#'
					
				</cfquery>		
				
				<cfif get.Percentage neq "">
					<cfset amt = amount * get.percentage>
					<cfset per = get.percentage * 100>
				<cfelse>
					<cfset amt = "0">
					<cfset per = "0">
				</cfif>			 
			  		
				<tr class="labelmedium navigation_row">
					<td style="padding-left:3px;height:30px">#ActivityDescription#</td>
					<td>#DateFormat(ActivityDateStart,client.dateformatshow)#</td>
					<td>#DateFormat(ActivityDateEnd,client.dateformatshow)#</td>
					<td>
					<input class="regularxl enterastab" 
					style="width:40;text-align:center" 
				    value="#per#"
					type="text" name="percentage_#activityid#" 
					onchange="_cf_loadingtexthtml='';ptoken.navigate('#session.root#/Procurement/Application/Requisition/Requisition/Activity/setAmount.cfm?requisitionno=#url.requisitionno#&fundingid=#url.fundingid#&activityid=#activityid#&percentage='+this.value,'amount_#activityid#')"></td>
					<td style="padding-right:4px" align="right" id="amount_#activityid#">#numberformat(amt,",_.__")#</td>
				</tr>
				<tr><td colspan="5" class="line"></td></tr>
				
			</cfoutput>	
			
			<tr class="labelmedium">
			<td align="right" colspan="3" class="labelmedium"><font color="808080"><cf_tl id="Distributed">:</td>			
			<td></td>
			<td id="activitytotal" align="right" style="padding-right:4px">			
							
				<cfquery name="check" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
					SELECT   SUM(Percentage) as Percentage			  
					FROM     RequisitionLineFundingActivity
					WHERE    RequisitionNo = '#url.requisitionno#'
					AND      FundingId  = '#url.fundingid#'	
				</cfquery>		
				
				<cfif check.percentage eq "">
				
					<cfset amt = 0>
				
				<cfelse>
				
					<cfset amt = amount * check.percentage>
				
				</cfif>
				
				<cfif check.percentage neq 1>				
					<cfset cl = "red">					
				<cfelse>				
					<cfset cl = "black">					
				</cfif>
				
				<cfoutput>
				
					<font color="#cl#">#numberformat(amt,",_.__")#</font>
	
				</cfoutput>
			
			</td>
			<td></td>
			</tr>
			
		</table>
	
	</cf_divscroll>

</td></tr>
</table>

<cfset ajaxonload("doHighlight")>