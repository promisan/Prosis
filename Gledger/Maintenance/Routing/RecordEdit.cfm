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

<cfparam name="url.idmenu" default="">

<cf_screentop height="100%"
			  scroll="Yes" 
			  layout="webapp" 
			  title="Edit Routing" 
			  label="Edit Routing" 
			  menuAccess="No" 
			  systemfunctionid="#url.idmenu#">



<cf_DialogLedger>


<cfquery name="Get" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	Select 
		R.RoutingNo,
		R.Mission, 
		R.DutyStation, 
		R.Fund, 
		R.OrgCode,
		R.PrgCode, 
		R.ObjectClass, 
		R.ObjectCode, 
		R.ObjectName,
		R.ReconcileMode,
		R.NOVA_GlAccount,
		R.NOVA_Object,
		R.NOVA_Fund,
		A.Description as GLDescription,
		A.AccountType
	FROM stLedgerRouting R LEFT OUTER JOIN
         Accounting.dbo.Ref_Account A ON R.NOVA_GLAccount = A.GLAccount
	WHERE R.RoutingNo = '#URL.RoutingNo#'
	Order by R.Mission, R.DutyStation, R.Fund, R.OrgCode, R.PrgCode, R.ObjectClass, R.ObjectCode
</cfquery>
  
  
<cfquery name="FundList" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_Fund
</cfquery>
  
  
<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- edit form --->

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
    <cfoutput>
	
	 <TR>
	 <TD width="80" class="labelit">Mission:&nbsp;</TD>  
	 <TD width="80%">
	 	<input type="hidden" name="RoutingNo" id="RoutingNo" value="#Get.RoutingNo#">
		#Get.Mission#
	 </TD>
	 </TR>
	 
	 <TR>
	 <TD width="80" class="labelit">Duty Station:&nbsp;</TD>  
	 <TD width="80%">
		#Get.DutyStation#	
	 </TD>
	 </TR>
	 	 
	 <TR>
	 <TD width="80" class="labelit">Fund:&nbsp;</TD>  
	 <TD width="80%">
		#Get.Fund#
	 </TD>
	</TR>
	
	<TR>
	 <TD class="labelit">Org Code:&nbsp;</TD>  
	 <TD>
		#Get.OrgCode#	
	 </TD>
	</TR>
	
    <TR>
    <TD class="labelit">Prg Code:&nbsp;</TD>
    <TD>
  	  	#Get.PrgCode#
	</TD>
	</TR>
	
    <TR>
    <TD class="labelit">Object Class&nbsp;Order:</TD>
    <TD>
  	  	#Get.ObjectClass#
	</TD>
	</TR>
	
	<TR>
    <TD class="labelit">Object Code:&nbsp;</TD>
	
	<TD class="labelit">
		#Get.ObjectCode#
    </TD>
	
	<tr><td class="labelit">Object Name:&nbsp;</td>	
	    <td id="labelit">
	    	#Get.ObjectName#
	    </td>		
	</tr>	

	<tr><td class="labelit">Reconcile Mode:&nbsp;</td>	
	    <td id="labelit">
	    	<input type="radio" name="mode" value="Add"   <cfif Get.ReconcileMode eq "add">checked</cfif>> Add<br>
			<input type="radio" name="mode" value="Match" <cfif Get.ReconcileMode eq "match">checked</cfif>> Match<br>
	    </td>		
	</tr>	
	
	<tr><td class="labelit">NOVA GL Account:&nbsp;</td>
		<td>
		  <img src="#SESSION.root#/Images/contract.gif" alt="Select account" name="img3" 
			  onMouseOver="document.img3.src='#SESSION.root#/Images/button.jpg'" 
			  onMouseOut="document.img3.src='#SESSION.root#/Images/contract.gif'"
			  style="cursor: pointer;" alt="" width="16" height="18" border="0" align="absmiddle" 
			  onClick="selectaccount('glaccount','gldescription','debitcredit','#get.mission#');">
				  
  		   <input type="text" name="glaccount"     id="glaccount"      value="#Get.NOVA_GLAccount#" size="6"  readonly class="regularxl" style="text-align: center;">
    	   <input type="text" name="gldescription" id="gldescription"  value="#Get.GLDescription#"  size="35" readonly class="regularxl" style="text-align: center;">
		   <input type="text" name="debitcredit"   id="debitcredit"    value="#Get.accounttype#"    size="3"  readonly class="regularxl" style="text-align: center;">
	
	   </td>		
	</tr>	
		
	<tr><td class="labelit">NOVA Object:&nbsp;</td>	
	    <td id="object">
	    	<cfset URL.Object =  Get.NOVA_Object>
	    	<cfinclude template="ObjectSelect.cfm">
	    </td>		
	</tr>	

	<tr><td class="labelit">NOVA Fund:&nbsp;</td>	
	    <td id="labelit">
		   <select name="fund" id="fund" class="regularxl">
		   		<option value=""></option>
           		<cfloop query="FundList">
			     	<option value="#FundList.Code#" <cfif Get.NOVA_Fund eq FundList.Code> selected</cfif>>#FundList.Code#</option>
		   		</cfloop>
	   	   </select>	    	
	    </td>		
	</tr>	
		
	</cfoutput>

	<tr><td height="1"></td></tr>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
  
	<tr>	
	<td colspan="2" height="35" align="center">	
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Update" value=" Update ">
	</td>	
	</tr>
	
</TABLE>
	

</cfform>

</BODY></HTML>