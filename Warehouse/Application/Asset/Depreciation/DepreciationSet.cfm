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
<!---
<cf_screentop label="Depreciation" scroll="Yes" banner="green" layout="webapp" user="No">
--->

<cf_verifyOperational module="Accounting" Warning="No">

<cfif Operational eq "0">

	 <cf_tl id="Depreciation requires the General Ledger module to be activated." var="1" Class="Message">
	 <cfset msg1="#lt_text#">
	 <cf_tl id="Operation aborted.">
	 <cfset msg2="#lt_text#">
	 
     <cf_message message = "#msg1# #msg2#" return = "no">
     <cfabort>

</cfif>

<cfquery name="Parameter" 
    datasource="appsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT    *
    FROM      Ref_ParameterMission
	WHERE     Mission = '#URL.Mission#'
</cfquery>

<cfquery name="Ledger" 
    datasource="appsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT    *
    FROM      Ref_ParameterMission
	WHERE     Mission = '#URL.Mission#'
</cfquery> 

<cfquery name="Period" 
    datasource="appsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT    *
    FROM      Period
	WHERE     AccountPeriod = '#Ledger.CurrentAccountPeriod#'
</cfquery> 

<cfif Period.AccountYear lt Parameter.LastYearDepreciation>

	 <cf_tl id="Depreciation is up to date." var="1" Class="Message">
	 <cfset msg1="#lt_text#">
	 <cf_tl id="There is not need for calculation" var="1">
	 <cfset msg2="#lt_text#">
	 
	 <cfoutput>
	 <table width="100%" height="100%" bgcolor="white"><tr><td align="center" class="labellarge">
	 #msg1#<br><br>#msg2#
	 </td></tr></table>
	 </cfoutput>
	 
	 <cfabort>

</cfif> 
 
<cfoutput>

<cfform action="../Depreciation/DepreciationCalculation.cfm?Mission=#URL.Mission#" method="post">

<table width="100%" align="center" bgcolor="white" class="formpadding">

<tr><td valign="top">

	<table width="100%" border="0"></td></tr>
	   
	   <tr><td height="5"></td></tr>
	   <tr>
	      <td class="labellarge" style="padding-left:10px"><cf_tl id="Year">:</td>
		  <td>	  
		  <select name="Year" id="Year" style="font-size:25px;height:35px" class="regularxl">
		  
			  <option value="#Parameter.LastYearDepreciation#">#Parameter.LastYearDepreciation# (recalculate)</option>
			  
			  <!--- check if exisits --->
				  			  
		      <cfquery name="check" 
				    datasource="appsLedger" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    SELECT    *
				    FROM      Period
					WHERE     AccountYear = '#Parameter.LastYearDepreciation+1#'
			  </cfquery> 
			  
			  <cfif check.recordcount gte "1">	  	  
			  	<option value="#Parameter.LastYearDepreciation+1#">#Parameter.LastYearDepreciation+1#</option>	  
			  </cfif>
		  
		  </select>
		  </td>
	   </tr>
	   <tr><td height="5"></td></tr>
	   <tr><td height="1" colspan="2" bgcolor="E5E5E5"></td></tr>
	   <tr><td height="5"></td></tr>
	   <tr>
		   <cf_tl id="Apply now" var="1">
	      <td colspan="2" align="center" height="50"><input type="submit" class="button10g" style="width:160;height:30" name="Submit" id="Submit" value="#lt_text#"></td>
	   </tr>
	</table>
	
</td></tr>

</table>

</cfform>

</cfoutput>