
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
<cfform target="detail" name="formlocate" onsubmit="return false">
	
<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="silver" class="formpadding">
<tr><td style="padding:8px"></td></tr>

<tr class="hide"><td height="100" id="processmanual"></td></tr>

<!--- extended search --->
<tr><td>

<table width="100%" cellspacing="0" cellpadding="0">

	<!--- Field: Pur_head.OrderType=CHAR;20;TRUE --->
			
	<tr><td height="2"></td></tr>
	
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

	<TD class="labelmedium"><cf_tl id="Period">:</TD>
			
	<td align="left" valign="top">
	<select name="period" id="period" size="1" class="regularxl">
	    <option value="" selected>All</option>
	    <cfoutput query="tPeriod">
		<option value="#Period#" <cfif URL.Period eq Period>selected</cfif> >#Period#</option>
		</cfoutput>
	    </select>
	</td>	

	<TD class="labelmedium"><cf_tl id="Status">:</TD>
			
	<td align="left" valign="top">
		 <select name="actionstatus" id="actionstatus" size="1" class="regularxl">
			 <option value="" selected>All</option>
			 <cfoutput query="tStatus">
		 		<option value="'#sCode#'">#sDescription#</option>
			 </cfoutput>
		 </select>
	</td>	
	
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>

	<TD class="labelmedium">Class:</TD>
			
	<td align="left" valign="top">
	
		<select name="entryclass" id="entryclass" size="1" class="regularxl">
	    <option value="" selected>All</option>
	    <cfoutput query="class">
		<option value="#Code#">#Description#</option>
		</cfoutput>
	    </select>
		
	</td>	
	
	<TD class="labelmedium">Staff/Contractor:</TD>
		
			
	<td align="left">
	
		<cfset link = "#SESSION.root#/Procurement/Application/Requisition/RequisitionView/getEmployee.cfm?PersonNo=#URL.PersonNo#">	 	
		
		<table cellspacing="0" cellpadding="0">
			<tr>
			<td>
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
			
			<td style="padding-left:0px">
			   <cfdiv bind="url:#link#" id="employee"/>
			</td>			
			</tr>	
			
		</table>
		
	</td>		  
	
	</TR>
	
	<tr><td height="2"></td></tr>

	<!--- Field: Pur_head.VendorName=CHAR;80;FALSE --->
	<TR>
	<TD class="labelmedium"><cf_tl id="Descriptive">:</TD>
			
	<td align="left">
	   <input type="text" name="RequestDescription" id="RequestDescription" value="" size="20" class="regularxl">
	</td>	
		
	<TD class="labelmedium">Program/Project:</TD>
			
	<td align="left">
	
		<table cellspacing="0" cellpadding="0"><tr><td style="padding-left:2px">
	
		  <cfoutput>
			   <img src="#SESSION.root#/Images/search.png" alt="Select item master" name="img5" 
					  onMouseOver="document.img5.src='#SESSION.root#/Images/contract.gif'" 
					  onMouseOut="document.img5.src='#SESSION.root#/Images/search.png'"
					  style="cursor: pointer;" alt="" width="25" height="24" border="0" align="absmiddle" 
					  onClick="selectprogram('#URL.mission#',document.getElementById('period').value,'applyprogram','')">
					  
			  </td>		  
			  <td style="padding-left:2px">		  
			  <input type="text" name="programdescription" id="programdescription" class="regularxl" size="30" maxlength="80" readonly>
			  <input type="hidden" name="programcode" id="programcode" readonly>
			  
		</cfoutput>			  
		
		</td>
		<td id="processmanual"></td>
		</tr></table>

		
	</td>	
		
	</tr>
		
	<tr><td height="2"></td></tr>
	
	<!--- Field: Pur_head.AmountUSD=FLOAT;8;FALSE --->
	
	<TR>
	<TD class="labelmedium"><cf_tl id="Requisition No">:</TD>
	<TD>	
	<input type="text" name="Reference" id="Reference" value="" size="20" class="regularxl">
	</TD>
			
	<cf_verifyOperational 
         datasource= "appsSystem"
         module    = "WorkOrder" 
		 Warning   = "No">
	
	<cfif Operational eq "0">
	
	<input type="hidden" name="workorderid" id="workorderid" size="40" maxlength="60" value="">		
	
	<cfelse>
		
	<TD class="labelmedium"><cf_tl id="WorkOrder">:</TD>					 
	<td>
		
		<cfparam name="url.workorderid" default="">
	
		<cfset link = "#SESSION.root#/Procurement/Application/Requisition/RequisitionView/getWorkorder.cfm?">	 	
		
		<table cellspacing="0" cellpadding="0">
			<tr>
			<td>
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
			
			<td style="padding-left:0px">
			   <cfdiv bind="url:#link#workOrderId=#URL.WorkOrderId#&doFilter=#URL.DoFilter#" id="workorder"/>
			</td>			
			</tr>	
			
		</table>
	
	</td>
	
	</cfif>
			
	</tr>	
	
	<tr><td height="2"></td></tr>
		
	<TR>
	<TD class="labelmedium"><cf_tl id="Job Case No">:</TD>
			
	<td align="left">
	   <input type="text" name="CaseNo" id="CaseNo" value="" size="20" class="regularxl">
	</td>	
	
	<td class="labelmedium"><cf_tl id="Classification">:</td>
	<td>
	<cf_annotationfilter>
	</td>				
		
	</tr>
		
	<tr><td height="2"></td></tr>
	
	<!--- Field: Pur_head.AmountUSD=FLOAT;8;FALSE --->
	
	<cf_calendarscript>
	
	<TR>
	<TD class="labelmedium"><cf_tl id="Prepared in period from">:</TD>
	<TD style="z-index:10; position:relative;padding:0px">	
	
	 <cf_intelliCalendarDate9
		FieldName="datestart" 
		Default=""
		Class="regularxl"
		AllowBlank="True">	
		
	</TD>
	
	<TD class="labelmedium"><cf_tl id="until">:</TD>
	<TD style="z-index:10; position:relative;padding:0px">
	
	<cf_intelliCalendarDate9
		FieldName="dateend" 
		Default=""
		Class="regularxl"
		AllowBlank="True">	
		
	</TD>
	</tr>
	
</TABLE>

</td></tr>
<tr><td class="linedotted" height="10"></td></tr>
<tr><td align="center" height="30" >

	<cfoutput>	
	<input type="reset"  class="button10g" value="#vReset#" style="width:140px">
	<input type="button" name="Submit" id="Submit" value="#vSearch#" class="button10g" style="width:140px" onclick="filter()">
	</cfoutput>

</td></tr>

</table>

</CFFORM>
