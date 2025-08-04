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

<cf_screentop label="Associate a position" line="no" scroll="No" layout="webapp" banner="gray">

<cfquery name="Line" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT *
	   FROM   RequisitionLine 
	   WHERE  RequisitionNo = '#url.reqid#'
</cfquery>

<cfquery name="Period" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT *
	   FROM   Ref_Period 
	   WHERE  Period = '#Line.Period#'
</cfquery>

<cfoutput>

<cfform style="height:100%" name="select" method="post">

<table width="100%" height="99%" border="0" cellspacing="0" cellpadding="0">

<tr><td style="padding-top:4px">

	<table align="left">
	
	<tr class="labelmedium">
	   <td style="padding-left:20px"><cf_tl id="RequisitionNo">:</td>
	   <td style="padding-left:5px"><cfif Line.Reference eq ""><font color="808080"><i><cf_tl id="New"></font><cfelse>#Line.Reference#</cfif></td>
	   <td style="padding-left:20px"><cf_tl id="funding expiration date">:</td>
	
		<td style="padding-left:5px">
		
		<cf_calendarscript>
		
		<cf_intelliCalendarDate9
					FieldName="fundeduntil" 
					Default=""
					DateValidStart="#Dateformat(Period.DateEffective, 'YYYYMMDD')#"
					DateValidEnd="#Dateformat(Period.DateExpiration, 'YYYYMMDD')#"
					class="regularxl"
					AllowBlank="True">	
		</td>
	</tr>
	</table>
	
</td>
<tr>
	<td colspan="2" align="center" height="100%" style="padding-left:3px;padding-right:3px" valign="top">		    
	  	<cfinclude template="PositionResult.cfm">
	</td>
</tr>

</table>

</CFFORM>

</cfoutput>

