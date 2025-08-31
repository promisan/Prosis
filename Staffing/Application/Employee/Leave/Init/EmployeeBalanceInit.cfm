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
<cfquery name="LeaveType" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   R.*, 
	         C.Description as Parent, 
			 C.ListingOrder as ParentOrder
	FROM     Ref_LeaveType R, Ref_TimeClass C 
	WHERE    R.LeaveParent = C.TimeClass
	AND      LeaveAccrual IN ('1','2','3','4')
	AND      LeaveBalanceMode = 'Absolute'
	ORDER BY C.ListingOrder, R.ListingOrder 
</cfquery>

<cfquery name="StartDate" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT MIN(DateEffective) as Effective
    FROM   PersonContract
	WHERE  PersonNo = '#URL.ID#' 
	AND    ActionStatus != '9'	
</cfquery>

<cfquery name="OnBoard" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Position AS Pos INNER JOIN
	       PersonAssignment AS PA ON Pos.PositionNo = PA.PositionNo INNER JOIN
	       Person AS P ON PA.PersonNo = P.PersonNo INNER JOIN
	       Organization.dbo.Organization AS Org ON Pos.OrgUnitOperational = Org.OrgUnit
	WHERE  (Pos.DateEffective < GETDATE()) AND (Pos.DateExpiration >= GETDATE()) AND (PA.DateEffective < GETDATE()) AND (PA.DateExpiration >= GETDATE()) 
	AND    PA.AssignmentStatus IN ('0', '1')
	AND    PA.personNo='#URL.ID#' 
</cfquery>								  

<cfform action="Init/EmployeeBalanceInitSubmit.cfm" method="post">

<table><tr><td height="1"></td></tr></table>

<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
  <tr><td>
	
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="34" style="height:34" colspan="2" align="center" class="labelmedium"><font size="4"><cf_tl id="Set initial leave balance"> </td>
   </tr>
   <tr><td class="line" colspan="2"></td></tr>
   <tr>
  <td width="100%" colspan="2">
  <table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding">
  
	
<TR class="labelmedium">
    <td width="100" style="padding-left:10px"><cf_tl id="Leave type"></td>
    <TD width="100"><cf_tl id="Effective"></TD>
	<TD width="100"><cf_tl id="Balance"></TD>
	<TD width="100"><cf_tl id="Memo"></TD>
</TR>

<tr><td class="line" colspan="4"></td></tr>

<cfoutput>
	<input type="hidden" name="No"       value="#LeaveType.recordcount#">
	<input type="hidden" name="PersonNo" value="#URL.ID#">
</cfoutput>

<cfoutput query="LeaveType" group="ParentOrder">
		
		<tr><td height="4"></td></tr>
		<tr class="line"><td style="padding-left:10px" colspan="6" height="24" class="labellarge">#Parent#</td></tr>
				
<cfoutput>
	
	<tr>
	<TD class="labelmedium" style="padding-left:10px">#Description#:</TD>
	
		<input type="hidden" name="LeaveType#CurrentRow#" value="#LeaveType#">
		
		<cfquery name="Search" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   PersonLeaveBalanceInit
			WHERE  PersonNo   = '#URL.ID#' 
			AND    LeaveType  = '#LeaveType#'
		</cfquery>
	
		<td style="z-index:#10-currentrow#; position:relative;padding:0px">		
		
		 <cf_intelliCalendarDate9
			    Tooltip        = "Select Date"
				FieldName      = "DateEffective#CurrentRow#" 
				class          = "regularxl enterastab"
				DateValidStart = "#Dateformat(StartDate.Effective, 'YYYYMMDD')#"
				DateValidEnd   = "#Dateformat(now()+30, 'YYYYMMDD')#"
				Default        = "#Dateformat(Search.DateEffective, CLIENT.DateFormatShow)#"
				AllowBlank     = "True">	
		
		</td>
		<td>
	    <cfinput type="Text" class="regularxl enterastab" name="BalanceDays#CurrentRow#" value="#Search.BalanceDays#" style="text-align: center;" validate="float" required="No" size="4" maxlength="4">
		</td>
		<td>
	    <input type="text" name="Memo#CurrentRow#" value="#Search.Memo#" size="30" maxlength="30" class="regularxl enterastab" style="text-align: center;">
		</td>
		
	</tr>

</cfoutput>

</cfoutput>

<tr><td height="1" colspan="4" class="line"></td></tr>

<tr><td colspan="4" height="27" align="center" class="label"><font color="808080"> <cf_tl id="Attention"> : <cf_tl id="The initial balance only takes effect if the date lies after the contract start date which is"> 
<b><cfoutput>#Dateformat(StartDate.Effective,CLIENT.DateFormatShow)#</cfoutput></b></td></tr>

<tr><td height="1" colspan="4" class="line"></td></tr>

<tr><td height="30" colspan="4" align="center">
	<cfoutput>
	<cf_tl id="Back" var="1">
   <input type="button" name="cancel" value="#lt_text#" class="button10g" onClick="ptoken.navigate('LeaveBalances.cfm?id=#url.id#&mode=balance','contentbox2')">
   <!---
	   	<cfif OnBoard.recordcount neq "0">
		--->
			<cf_tl id="Apply" var="1">   
		   <input class="button10g" type="submit" name="Submit" value="#lt_text#" onclick="Prosis.busy('yes')">&nbsp;
		<!---   
		</cfif>	   
		--->
   </cfoutput>
</td></tr>

</TABLE>

</td>

</table>

</cfform>

<cfset ajaxOnLoad("doCalendar")>
