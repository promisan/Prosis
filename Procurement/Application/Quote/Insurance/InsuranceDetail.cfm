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
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->


<cfif url.orgunit eq "">

<table width="100%">
	<tr><td align="center">Sorry, no vendor have been defined at this point</td></tr>
</table>

<cfelse>

<cfoutput>

<cfquery name="Job" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT *
		FROM   Job
		WHERE   JobNo = '#url.jobno#'				
</cfquery>

<cfquery name="Vendor" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT *
		FROM   Organization
		WHERE   OrgUnit = '#url.orgunit#'				
</cfquery>

<cfquery name="JobVendor" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT *
		FROM   JobVendor
		WHERE   OrgUnitVendor = '#url.orgunit#'				
		AND     JobNo = '#Url.JobNo#'
</cfquery>

<cfform name="insuranceinputform" onsubmit="return false">

	<table width="100%" align="center" class="formspacing">
	
		<cfoutput>
				
		<!--- ---------------------------- --->
		<!--- ------custom information---- --->
		<!--- ---------------------------- --->
		
		<cfinclude template="Event.cfm">	
		
		<tr class="labelmedium">
		<td height="18" width="200"><cf_tl id="Contract Description"></td>
		<td><font color="0080FF">#Job.Description#</td>
		</tr>
		
		<tr class="labelmedium">
		<td height="18"><cf_tl id="Amount"></td>
		
		<cfquery name="Amount" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT Currency, sum(QuoteAmountCost) as Cost, sum(QuoteAmountTax) as Tax
			FROM      RequisitionLineQuote Q
			WHERE     JobNo = '#JobNo#'  
			AND       OrgUnitVendor = '#url.orgunit#'			
		    AND      Selected = 1
			GROUP BY Currency
		</cfquery>
		
		<td>
		<table cellspacing="0" cellpadding="0">
		<cfloop query="Amount">
		<tr><td class="labelit"><font color="0080FF">#Currency# <cfif tax neq "">#numberformat(cost+tax,",.__")#<cfelse>#numberformat(cost,",.__")#</cfif></td></tr>
		</cfloop>
		</table>
		</td>
		
		</tr>
				
		<tr class="labelmedium">
		<td height="18"><cf_tl id="Object of Expenditure"></td>
		<td>
		
		<cfquery name="Object" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  DISTINCT R.Code, R.Description
				FROM    RequisitionLineQuote RQ INNER JOIN
                        RequisitionLineFunding L ON RQ.RequisitionNo = L.RequisitionNo INNER JOIN
                        Program.dbo.Ref_Object R ON L.ObjectCode = R.Code
				WHERE   RQ.JobNo = '#JobNo#'  
			    AND     RQ.OrgUnitVendor = '#url.orgunit#'				
		</cfquery>
		
		<table cellspacing="0" cellpadding="0">
		<cfloop query="Object">
		<tr><td class="labelit"><font color="0080FF">#Code# #Description#</td></tr>
		</cfloop>
		</table>
		
		</td>
		
		</tr>
			
		</cfoutput>
		   
		<tr><td height="3"></td></tr>
		<tr><td height="1" class="linedotted" colspan="2"></td></tr>		
		<cfoutput>
		
		<!---
		<tr>
			<td colspan="2" class="labelit" height="18"><font color="gray"><b>#Vendor.OrgUnitName# <cf_tl id="Contact Information"></td>			
		</tr>
		<tr><td height="1" class="linedotted" colspan="2"></td></tr>		
		--->
		
		</cfoutput>
		
		<!--- ---------------------------- --->
		<!--- ----Contact data  ---------- --->
		<!--- ---------------------------- --->
		
		<cfinclude template="VendorContact.cfm">
				
		
		<!--- ---------------------------- --->
		<!--- ----Insurance detail data--- --->
		<!--- ---------------------------- --->
		
		<tr><td height="3"></td></tr>
		<tr><td height="1" class="linedotted" colspan="2"></td></tr>			
		<tr>
			<td colspan="2" height="18" class="labelmedium"><cf_tl id="Insurance"></b></font></td>
		</tr>	
		<tr><td height="1" class="linedotted" colspan="2"></td></tr>	
		
		<tr>
			<td class="labelit">&nbsp;<cf_tl id="Insurance Type"></td>
			<td>
			<table cellspacing="0" cellpadding="0">
			<tr>
				<td>
				
				<cfquery name="List" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					SELECT *
					FROM Ref_JobVendorList
					WHERE Class = 'Insurance'
				</cfquery>
				
				<select name="Insurance" id="Insurance" class="regularxl">
				
					<cfloop query="list">
					  <option value="#code#" <cfif code eq JobVendor.Insurance>selected</cfif>>#Description#</option>
					</cfloop>
				
				</select>
				
				</td>
			
			<td>
			<td class="labelit">&nbsp;<cf_tl id="Number"></td>
			<td><input type="text" name="InsuranceNo" id="InsuranceNo" size="10" maxlength="20" value="#JobVendor.InsuranceNo#" class="regularxl"></td>
			<td class="labelit">&nbsp;<cf_tl id="Amount"></td>
			<td><cfinput type="Text"
		       name="InsuranceAmount" 
			   size="10"
			   value="#JobVendor.InsuranceAmount#"
		       validate="float" class="regularxl"
		       required="No">
		      </td>
			</table>
			</td>
		</tr>
			
		<!--- -------------------- --->
		<!--- show tracking fields --->
		<!--- -------------------- --->
				
		<cf_vendortracking jobNo="#url.jobNo#" orgunit="#url.OrgUnit#" class="Insurance">		
									
		<!--- ---------------------------- --->
		<!--- ----Contract detail data---- --->
		<!--- ---------------------------- --->		
		
		<tr><td height="3"></td></tr>
		<tr><td height="1" class="linedotted" colspan="2"></td></tr>		
		<tr>
			<td colspan="2" class="labelmedium" height="18"><cf_tl id="Contract Preparation data"></b></td>
		</tr>			
		<tr><td height="1" class="linedotted" colspan="2"></td></tr>
		
		<!--- -------------------------------------------- --->
		<!--- query to loop through the workflow for dates --->
		<!--- show only last entered action date per step  --->
		<!--- -------------------------------------------- --->
		
		<cfquery name="Object" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  Objectid
        FROM   OrganizationObject
        WHERE  ObjectKeyValue1 = '#url.jobno#' 
		AND Operational = 1
		</cfquery>
		
		<cfif Object.recordcount eq "1">
		
			<cf_vwActionReference objectId="#Object.ObjectId#">
		
		</cfif>
						
		<!--- -------------------- --->
		<!--- show tracking fields --->
		<!--- -------------------- --->
				
		<cf_vendortracking jobNo="#url.jobNo#" orgunit="#url.OrgUnit#" class="Contract">		
		
		<tr>
			<td class="labelit">&nbsp;<cf_tl id="Payment Condition"></td>
			<td><input type="text" name="PaymentCondition" id="PaymentCondition" value="#Jobvendor.paymentCondition#" size="20" maxlength="20" class="regularxl"></td>
		</tr>
		
	    <tr>
			<td class="labelit">&nbsp;<cf_tl id="Advance"></td>
			<td><input type="text" name="PaymentAdvance" id="PaymentAdvance" value="#Jobvendor.paymentAdvance#" size="20" maxlength="20" class="regularxl"></td>
		
		</tr>
		
		<tr>
			<td class="labelit">&nbsp;<cf_tl id="Contract type"></td>
			<td>
			
			<cfquery name="List" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					SELECT *
					FROM Ref_JobVendorList
					WHERE Class = 'ContractType'
				</cfquery>
				
				<select name="ContractType" id="ContractType" class="regularxl">
				
					<cfloop query="list">
					  <option value="#code#" <cfif code eq JobVendor.ContractType>selected</cfif>>#Description#</option>
					</cfloop>
				
				</select>
			
			</tr>
		<tr></tr>
				
		
		<cf_tl id="Save" var="1">
		<cfset vSave=#lt_text#>		
		<tr><td height="1" class="line" colspan="2"></td></tr>	
		<tr><td colspan="2" height="26" align="center">
		<input type="button" 
		   name="Save" 
           id="Save"
		   value="#vSave#" 
		   class="button10g" 
		   onclick="validateinsurance('insuranceinputform','#url.jobno#','#url.orgunit#')">
		</td></tr>
		
    </table>
		
	</cfform>		
	      
</cfoutput>

</cfif>

<cfset ajaxonload("doCalendar")>
