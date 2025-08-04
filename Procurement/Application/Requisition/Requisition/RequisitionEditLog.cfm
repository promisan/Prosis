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

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   RequisitionLine
	WHERE  RequisitionNo = '#URL.ID#'
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT *
	   FROM   Ref_ParameterMission
	   WHERE  Mission = '#Line.Mission#' 
</cfquery>

<table width="100%"
       border="0" class="formpadding"
       align="center">

<cfoutput>
		
<tr class="labelmedium line">	
	<td height="22" width="130"><cf_tl id="Period">:</td>
	<TD>#Line.Period#</td>	
</tr>   

<cfquery name="OrgUnit" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Organization
	<cfif line.actionstatus neq "0">
	WHERE OrgUnit = '#Line.OrgUnit#'
	<cfelse>
	WHERE OrgUnit = '#client.orgunit#' 
	</cfif>
</cfquery>
			
<tr class="labelmedium line">
   <TD height="22"><cf_space spaces="27"><cf_tl id="Funding Unit">:</td>
   <TD>#OrgUnit.Mission# - #OrgUnit.orgunitName#</TD>
</TR>	

<cfquery name="OrgImplement" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Organization
	<cfif line.actionstatus neq "0">
	WHERE OrgUnit = '#Line.OrgUnitImplement#'
	<cfelse>
	WHERE OrgUnit = '#client.orgunit#' 
	</cfif>
</cfquery>
		
<tr class="labelmedium line">
   <TD height="22" style="min-width:145px"><cf_tl id="Implementer">:</td>
   <TD>#OrgImplement.Mission# - #OrgImplement.orgunitName#</TD>
</TR>	

<cfquery name="Master" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM ItemMaster
	WHERE Code = '#Line.ItemMaster#'
</cfquery>
	
<tr class="labelmedium line">
    <TD width="120" height="22"><cf_tl id="Request Class">:</TD>
    <TD>#Master.Description#</TD>
</TR>
							
<tr class="labelmedium line">
  <TD height="22"><cf_tl id="Item Type">:</TD>
  <TD>#Line.RequestType#</TD>
</TR>	
			
<tr class="labelmedium line">
  <TD height="22"><cf_tl id="RequestDate">:</TD>
  <TD>#dateformat(line.RequestDate,CLIENT.DateFormatShow)#</TD>
</TR>

<cfif Line.RequestDue neq "">
	
	<tr class="labelmedium line">
	  <TD height="22"><cf_tl id="DueDate">:</TD>
	  <TD>#dateformat(line.RequestDue,CLIENT.DateFormatShow)#</TD>
	</TR>		

</cfif>		
			
<TR <tr class="labelmedium line">
  <TD height="22"><cf_tl id="Item">:</TD>
  <TD>#line.RequestDescription#</TD>
</TR>
					 	 
<tr class="labelmedium line">
    <TD height="22"><cf_tl id="Quantity">:</TD>
    <TD>#line.RequestQuantity#</td>
</tr>
		
<tr class="labelmedium line">	
	<td height="22"><cf_tl id="REQ020">:</td>
	<td>#APPLICATION.BaseCurrency# #numberFormat(Line.RequestCostPrice,",.__")#</td>
</tr>	
		
<tr class="labelmedium line">
    <td height="22"><cf_tl id="REQ021">:</td>
	<td>#APPLICATION.BaseCurrency# #numberFormat(Line.RequestAmountBase,",.__")#</td>
</TR> 

<tr class="labelmedium line">

	<TD height="22"><cf_tl id="Funding">:</TD>
	<TD height="22" colspan="1">
			
		<cfquery name="Funding" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   F.*, 
			         O.Description, 
				     P.ProgramName
			FROM     RequisitionLineFunding F INNER JOIN
                     Program.dbo.Ref_Object O ON F.ObjectCode = O.Code LEFT OUTER JOIN
                     Program.dbo.Program P ON F.ProgramCode = P.ProgramCode			   
			WHERE    RequisitionNo = '#URL.ID#'			
			ORDER BY F.Created 
		</cfquery>
		
		<table width="98%">
	
			<cfloop query="Funding">
			
				<TR height="17" class="labelmedium">
				   <td>#ProgramPeriod#</td>
				   <td>#Fund#</td>				  
				   
				    <cfquery name="Program" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT * 
								FROM  ProgramPeriod
								WHERE ProgramCode = '#ProgramCode#'
								AND   Period = (SELECT PlanningPeriod 
								                FROM   Organization.dbo.Ref_MissionPeriod 
												WHERE  Mission = '#Line.Mission#' 
												AND    Period = '#ProgramPeriod#')					
					</cfquery>
				  
				    <td>
					   <cfif Program.reference neq "">
						#Program.Reference#
					   <cfelse>
						#ProgramCode#
					   </cfif>
					   <cfif ProgramName eq "">undefined<cfelse>#ProgramName#</cfif>
				   </td>
				   
				   <td>#ObjectCode# #Description# </td>
				   <td>#Percentage*100#%</td>				 
				   <cfset amt = line.requestamountbase*percentage>
				   <td width="80" align="right">#numberformat(amt,",.__")#</td>
				</tr>   
			
			</cfloop>
		
		</table>
										
	 </TD>
</TR>	
	
<TR <tr class="labelmedium line">
    <td height="22"><cf_tl id="Attachments">:</td>
		<TD>		
		
		    <cf_filelibraryN
				DocumentPath="#Parameter.RequisitionLibrary#"
				SubDirectory="#url.id#" 
				Filter=""
				Insert="no"
				Remove="no"
				loadscript="No"
				reload="true"
				width="99%"
				align="left"
				border="1">			
				
		</TD>
</TR>

<cfquery name="Buyer" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     RequisitionLineActor
		WHERE    RequisitionNo = '#Line.RequisitionNo#'    		
		</cfquery>
		
	<cfif buyer.recordcount gte "1">
	
	<tr <tr class="labelmedium line">
	    <td height="22"><cf_tl id="Assigned Buyers">:</td>
		
		<td>
		<table>
		
			<cfloop query="Buyer">
			<tr class="labelmedium"><td>#ActorFirstName# #ActorLastName# (#dateformat(created,CLIENT.DateFormatShow)#)</td></tr>
			</cfloop>	
		
		</table>
		</td>
		
	</tr>
	
	</cfif>		
	
	<cfquery name="Purchase" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   P.Purchaseno, P.ActionStatus
		FROM     Purchaseline PL, Purchase P
		WHERE    PL.PurchaseNo = P.PurchaseNo
		AND      RequisitionNo = '#Line.RequisitionNo#'   		
	</cfquery>
		
	<cfif purchase.recordcount gte "1">
	
	<tr <tr class="labelmedium line">
	    <td style="min-width:120px" height="22"><cf_tl id="Purchase"></td>		
		<td><a href="javascript:ProcPO('#purchase.purchaseno#')">#Purchase.PurchaseNo#</a></td>		
	</tr>
	
	</cfif>			

<tr class="labelmedium line">     
 	<td class="labelmedium" height="22"><cf_tl id="REQ022">:</td> 	
	<td>
	<cfset text = replace(Line.Remarks,"<script","disable","all")>
	<cfset text = replace(text,"<iframe","disable","all")>			
	#text#
	</td>
</tr>
		
</table>
	
</cfoutput>

	