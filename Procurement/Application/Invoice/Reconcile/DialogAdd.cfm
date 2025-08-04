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

<cf_screentop height="100%" scroll="Yes" close="ColdFusion.Window.destroy('mydialog',true)" layout="webapp" banner="gray" label="Add Transaction as Disbursement">

<cfquery name="get"
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   stLedgerIMIS
	WHERE  transactionserialNo = '#url.transactionno#'
	AND    Mission = '#url.mission#'
</cfquery>

<!---
<cfoutput>
#get.transactionserialno#
</cfoutput>
--->

<cfquery name="program"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM  Program P, ProgramPeriod Pe
	WHERE P.ProgramCode = Pe.ProgramCode
	and Pe.Reference = '#get.activityCode#'
</cfquery>


<table width="91%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
<tr><td height="5"></td></tr>

<cfoutput>

<tr class="labelmedium"><td><b>Umoja</b> transaction</td></tr>
<tr class="labelit"><td width="100">Document:</td><td width="70%">#get.DocumentCode#</td></tr>
<tr class="labelit"><td width="100">Date:</td><td width="70%">#dateformat(get.Postingdate,CLIENT.DateFormatShow)#</td></tr>
<tr class="labelit"><td width="100">InvoiceNo:</td><td width="70%">#get.InvoiceNo#</td></tr>
<tr class="labelit"><td width="100">Vendor:</td><td width="70%">#get.VendorName#</td></tr>
<tr class="labelit"><td width="100">User:</td><td width="70%">#get.Userid#</td></tr>
<tr class="labelit"><td width="100">Year:</td><td width="70%">#get.FiscalYear#</td></tr>
<tr class="labelit"><td width="100">Fund:</td><td width="70%">#get.Fund#</td></tr>
<tr class="labelit"><td>Class:</td><td>#get.ObjectClass#</td></tr>
<tr class="labelit"><td>Object:</td><td>#get.ObjectCode# #get.ObjectName#</td></tr>
<tr class="labelit"><td>Organization:</td><td>#get.OrgCode#</td></tr>
<tr class="labelit"><td>Activity:</td>
     <td>
	 <table cellspacing="0" cellpadding="0">
	 <tr  class="labelit"><td>#get.activityCode# #program.ProgramName#</td></tr>
	 </table>
	 </td>
	 </tr>
<tr><td class="labelit">Amount:</td>
    <td class="labelmedium"><b>#numberformat(get.documentamount,'__,__.__')#</b></td>
</tr>
<tr><td height="8"></td></tr>


<cfquery name="Mapping"
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM  stLedgerRouting
	WHERE Fund        = '#get.fund#'
	AND   Mission     = '#get.mission#'
	AND   ObjectClass = '#get.ObjectClass#'
	AND   ObjectCode  = '#get.ObjectCode#'
	AND   orgCode     = '#get.OrgCode#'	
</cfquery>


<cfquery name="GL"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM  Ref_Account
	WHERE GLAccount IN (SELECT GLAccount 
	                    FROM   Ref_AccountMission 
						WHERE  Mission = '#url.mission#')	
</cfquery>

<cfquery name="PeriodList"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM  Ref_AllotmentEdition
	WHERE Mission = '#get.mission#'	
</cfquery>

<cfquery name="Period"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM  Ref_AllotmentEdition
	WHERE Mission = '#get.mission#'	
	AND   EditionId IN (
	                 SELECT EditionId 
					 FROM   Ref_AllotmentEditionFund 
					 WHERE  Fund = '#mapping.Nova_Fund#'
					 )
	AND   Period IN (
	                 SELECT   Period 
	                 FROM     Ref_Period 
					 WHERE    DateExpiration > '01/01/#get.fiscalyear#' 					 
					)
	ORDER BY EditionId				
</cfquery>

<tr class="labelit"><td><b>#SESSION.welcome# account</td></tr>
<tr class="labelit">
   <td height="20" width="100">Period:</td>
   <td width="70%">
   
   <select name="period" id="period" class="regularxl">
   <cfloop query="PeriodList">
   <cfif period neq "">
	   <option value="#Period#" <cfif period eq period.period>selected</cfif>>#Period#</option>
   </cfif>
   </cfloop>
   </select>
      
   </td>
</tr>
<tr>
    <td class="labelit" style="height:25px">Nova Fund:</td>
	<td  class="labelmedium">#Mapping.Nova_Fund#</td>
</tr>

<tr>
   <td class="labelit" style="height:25px">Nova Object</td>
   <td class="labelmedium">#Mapping.Nova_Object#</td>
</tr>   

<input type="hidden" name="object" id="object" value="#Mapping.Nova_Object#">

<tr class="labelit"><td height="20">Proposed Program/Project:</td>
	
	<td id="program">
	 <table cellspacing="0" cellpadding="0">
	 <tr><td height="20">
	 
	      <cf_DialogLedger>	
	 
	      <cfoutput>
			   <img src="#SESSION.root#/Images/contract.gif" alt="Select item master" name="img5" 
					  onMouseOver="document.img5.src='#SESSION.root#/Images/button.jpg'" 
					  onMouseOut="document.img5.src='#SESSION.root#/Images/contract.gif'"
					  style="cursor: pointer;" alt="" width="16" height="18" border="0" align="absmiddle" 
					  onClick="selectprogram('#get.mission#','#period.Period#','applyprogram','')">
					  
			  <input type="text" value="#program.ProgramName#" name="programdescription" id="programdescription" class="regularxl" size="30" maxlength="80" readonly>
			  <input type="text" value="#program.programcode#" name="programcode" id="programcode" class="regularxl" size="10" readonly>
			  
		  </cfoutput>			
	 
	 </td></tr>
	 </table>
	</td>
	
</tr>

<tr class="labelit">
    <td height="20">GL Account code:</td>
	<td>	
	
    <select name="glaccount" id="glaccount" class="regularxl" style="width:380px">
      <cfloop query="GL">
       <option value="#GLAccount#" <cfif GLAccount eq mapping.Nova_GLAccount>selected</cfif>>#GL.GLAccount# #GL.Description# (#GL.ObjectCode#)</option>
      </cfloop>
    </select>
		
	</td>
</tr>

</cfoutput>

<tr><td height="4"></td></tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
<tr><td height="4"></td></tr>
<tr><td colspan="2" align="center" style="padding-top:4px">

<cfoutput>

<cfif PeriodList.recordcount gte "1">

	<input type="button" name="Cancel" id="Cancel" value="Cancel" onclick="ColdFusion.Window.destroy('mydialog',true)" class="button10g">
	<input type="button" name="Save"   id="Save"   value="Submit" onclick="setprocess(document.getElementById('programcode').value,document.getElementById('period').value,document.getElementById('glaccount').value,document.getElementById('object').value,'#url.transactionno#','save')"      class="button10g">

<cfelse>

	<font color="FF0000">Problem determining the period and/or the GL account</font>
	
</cfif>

</cfoutput>

</td></tr>

</table>

<cf_screenbottom layout="innerbox">