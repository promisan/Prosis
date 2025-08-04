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

<cfparam name="URL.Mission"   default="SAT">
<cfparam name="URL.Period"    default="SAT">
<cfparam name="URL.PersonNo"  default="">
<cfparam name="URL.doFilter"  default="0">

<cf_tl id="All" var="1">
<cfset vAll=lt_text>

<cf_tl id="Reset" var="1">
<cfset vReset=lt_text>

<cf_tl id="Search" var="1">
<cfset vSearch=lt_text>

<cfquery name="Vendor" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT OrgUnit, OrgUnitName
	FROM  Organization
	WHERE OrgUnit IN (SELECT OrgUnitVendor 
	                  FROM Purchase.dbo.Purchase 
	                  WHERE Mission='#URL.Mission#'
					  AND Period = '#URL.Period#')
    ORDER BY OrgUnitName
</cfquery>

<cfquery name="Curr" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT DocumentCurrency
	FROM  Invoice
	WHERE Mission = '#URL.Mission#'
</cfquery>
			
<cfquery name="Class" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
           SELECT DISTINCT A.Code, A.Description
           FROM   ItemMaster I, Ref_EntryClass A
		   WHERE  I.EntryClass = A.Code
		   AND    Operational = 1
           AND    ( Mission = '#url.Mission#' OR Mission is NULL ) 
									  
</cfquery>

<cfquery name="tStatus" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Status sCode,Description sDescription
	FROM   Status
	WHERE  StatusClass = 'Requisition'
	AND    Status != '0'
	AND    Status IN (SELECT ActionStatus FROM RequisitionLine WHERE Mission = '#url.mission#')
	ORDER BY Status
</cfquery>


<cfquery name="tPeriod" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
      SELECT R.*, M.MandateNo 
      FROM Ref_Period R, Organization.dbo.Ref_MissionPeriod M
      WHERE IncludeListing = 1
      AND M.Mission = '#URL.Mission#'
      AND R.Period = M.Period 
</cfquery>

<!--- Search form --->
<cfform target="detail" name="formlocate" style="padding:0px" onsubmit="return false">
	
<table width="98%" align="center">

<tr class="hide"><td height="100" id="processmanual"></td></tr>

<!--- extended search --->
<tr><td>

	<table width="100%" class="formpadding">
	
		<!--- Field: Pur_head.OrderType=CHAR;20;TRUE --->
			
		
		<!--- disabled 1/1/2011 as it was not finished in the code --->
		
		<!---
		<cfif Parameter.EnableExecutionRequest eq "1">		
		
			<tr><td>Request class:</td>
						
			<td colspan="4" height="30">
			
				<input type="radio" name="RequestClass" value="requisition" checked>Procurement Requisition
				<input type="radio" name="RequestClass" value="execution">Procurement Execution Request
			
			</td>
				
			</tr>	
			<tr><td colspan="4" class="line"></td></tr>	
			<tr><td height="4"></td></tr>
		
		</cfif>
		
		--->
		
		<TR>
	
		<TD class="labelmedium2 fixlength"><cf_tl id="Period">:</TD>
				
		<td align="left" valign="top">
		<select name="period" id="period" size="1" class="regularxxl">
		    <option value="" selected>All</option>
		    <cfoutput query="tPeriod">
			<option value="#Period#" <cfif URL.Period eq Period>selected</cfif> >#Period#</option>
			</cfoutput>
		    </select>
		</td>	
	
		<TD class="labelmedium2 fixlength"><cf_tl id="Status">:</TD>
				
		<td align="left" valign="top">
			 <select name="actionstatus" id="actionstatus" size="1" class="regularxxl">
				 <option value="" selected>All</option>
				 <cfoutput query="tStatus">
			 		<option value="'#sCode#'">#sDescription#</option>
				 </cfoutput>
			 </select>
		</td>	
		
		</TR>
			
		<TR>
	
		<TD class="labelmedium2 fixlength">Class:</TD>
				
		<td align="left" valign="top">
		
			<select name="entryclass" id="entryclass" size="1" class="regularxxl">
		    <option value="" selected>All</option>
		    <cfoutput query="class">
			<option value="#Code#">#Description#</option>
			</cfoutput>
		    </select>
			
		</td>	
		
		<TD class="labelmedium2 fixlength">Staff/Contractor:</TD>		
				
		<td align="left">
		
			<cfset link = "#SESSION.root#/Procurement/Application/Requisition/RequisitionView/getEmployee.cfm?PersonNo=#URL.PersonNo#">	 	
			
			<table>
				<tr>
				
				<td style="width:30px;padding-left:2px">
				   <cf_selectlookup box        = "employee"
						button     = "Yes"
						link       = "#link#"
						icon       = "Search.png"
						iconheight = "24"
						iconwidth  = "25"
						close      = "Yes"
						type       = "employee"
						des1       = "Selected">
				</td>
							
				<td style="padding-left:3px">
				   <cf_securediv bind="url:#link#" id="employee">
				</td>	
					
				</tr>	
				
			</table>
			
		</td>		  
		
		</TR>
		
		<!--- Field: Pur_head.VendorName=CHAR;80;FALSE --->
		<TR>
		<TD class="labelmedium2 fixlength"><cf_tl id="Descriptive">:</TD>
				
		<td align="left">
		   <input type="text" name="RequestDescription" id="RequestDescription" value="" size="20" class="regularxxl">
		</td>	
			
		<TD class="labelmedium2 fixlength">Program/Project:</TD>
				
		<td>
		
			<cfoutput>
		
			<table>
			<tr>		
			
			<td style="width:30px;padding-left:2px">	
			  
				   <img src="#SESSION.root#/Images/search.png" alt="Select item master" name="img5" 
						  onMouseOver="document.img5.src='#SESSION.root#/Images/contract.gif'" 
						  onMouseOut="document.img5.src='#SESSION.root#/Images/search.png'"
						  style="cursor: pointer;" alt="" width="25" height="24" border="0" align="absmiddle" 
						  onClick="selectprogram('#URL.mission#',document.getElementById('period').value,'applyprogram','')">
						  
				  </td>
				    
				  <td style="padding-left:3px">		  
				  <input type="text" name="programdescription" id="programdescription" class="regularxxl" size="30" maxlength="80" readonly>
				  <input type="hidden" name="programcode" id="programcode" readonly>
					  
			
			</td>		
			
	        <td id="processmanual"></td>		
			</tr>
			</table>		
				  
			</cfoutput>	
					
		</td>	
			
		</tr>
			
		<!--- Field: Pur_head.AmountUSD=FLOAT;8;FALSE --->
		
		<TR>
		<TD class="labelmedium2 fixlength"><cf_tl id="Requisition No">:</TD>
		<TD>	
		<input type="text" name="Reference" id="Reference" value="" size="20" class="regularxxl">
		</TD>
				
		<cf_verifyOperational 
	         datasource= "appsSystem"
	         module    = "WorkOrder" 
			 Warning   = "No">
		
		<cfif Operational eq "0">
		
		<input type="hidden" name="workorderid" id="workorderid" size="40" maxlength="60" value="">		
		
		<cfelse>
			
		<TD class="labelmedium2 fixlength"><cf_tl id="WorkOrder">:</TD>					 
		<td>
			
			<cfparam name="url.workorderid" default="">
		
			<cfset link = "#SESSION.root#/Procurement/Application/Requisition/RequisitionView/getWorkorder.cfm?">	 	
			
			<table style="width:100%">
				<tr>
				
				<td style="width:30px;padding-left:2px">
				   <cf_selectlookup box = "workorder"
						button       = "Yes"
						link         = "#link#"
						icon         = "Search.png"
						iconheight   = "24"
						iconwidth    = "25"
						close        = "Yes"
						title        = "Locate workorder"
						filter1      = "w.mission"
						filter1value = "#url.mission#"
						class        = "workorder"
						des1         = "workorderid">
				</td>
				
				<td style="padding-left:0px;width:90%">				
				   <cf_securediv bind="url:#link#workOrderId=#URL.WorkOrderId#&doFilter=#URL.DoFilter#" id="workorder">
				</td>	
			
						
				</tr>	
				
			</table>
		
		</td>
		
		</cfif>
				
		</tr>	
				
		<TR>
		<TD class="labelmedium2 fixlength"><cf_tl id="Job Case No">:</TD>
				
		<td align="left">
		   <input type="text" name="CaseNo" id="CaseNo" value="" size="20" class="regularxxl">
		</td>	
		
		<td class="labelmedium2 fixlength"><cf_tl id="Classification">:</td>
		<td>
		<cf_annotationfilter>
		</td>				
			
		</tr>
				
		<!--- Field: Pur_head.AmountUSD=FLOAT;8;FALSE --->
		
		<cf_calendarscript>
		
		<TR>
		<TD class="labelmedium2 fixlength"><cf_tl id="Prepared in period from">:</TD>
		<TD>	
		
		 <cf_intelliCalendarDate9
			FieldName="datestart" 
			Default=""
			Class="regularxxl"
			AllowBlank="True">	
			
		</TD>
		
		<TD class="labelmedium2 fixlength"><cf_tl id="until">:</TD>
		<TD>
		
		<cf_intelliCalendarDate9
			FieldName="dateend" 
			Default=""
			Class="regularxxl"
			AllowBlank="True">	
			
		</TD>
		</tr>
		
	</TABLE>

</td></tr>

<tr class="line"><td class="line" align="center" height="30" >

	<cfoutput>	
	<input type="reset"  class="button10g" value="#vReset#" style="width:140px">
	<input type="button" name="Submit" id="Submit" value="#vSearch#" class="button10g" style="width:140px" onclick="filter()">
	</cfoutput>

</td></tr>

</table>

</CFFORM>
