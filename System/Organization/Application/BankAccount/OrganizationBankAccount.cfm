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

<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">

<table width="100%" align="center">

	<tr><td>
		<cfinclude template="../UnitView/UnitViewHeader.cfm">
	</td></tr>
	
</table>

<script language="JavaScript">

function account(orgunit) {
    ptoken.location('AccountEntry.cfm?ID=' + orgunit);
}

function edit(org,acc) {
   ptoken.location('AccountEdit.cfm?id='+org+'&id1='+acc)
}

</script>

<!--- Query returning search results --->
<cfquery name="Search" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
    FROM OrganizationBankAccount L, Ref_Bank R
	WHERE L.OrgUnit = '#URL.ID#' 
	AND  R.Code = L.BankCode	
</cfquery>

<table width="95%" align="center" border="0" cellspacing="0">
  <tr><td>
	
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
  <tr>
    <td style="height:30" class="labellarge" style="padding-left:3px"><cf_tl id="Bank accounts"></td>
	<cfoutput>
    <td align="right" height="30">
	<cfinvoke component="Service.Access"  
	          method="Org"  
			  OrgUnit="#URL.ID#" 
			  returnvariable="access">
    <cfif access eq "EDIT" or access eq "ALL">
		<cf_tl id="Add" var="vAdd">
    	<input type="button" 
		       value="#vAdd#" 
			   class="button10g" 
			   onClick="javascript:account('#URL.ID#')">
	</cfif>&nbsp;
    </td>
	</cfoutput>
   </tr>
   <tr>
  <td width="100%" colspan="2">
  
<table border="0" cellpadding="0" cellspacing="0" width="100%" class="navigation_table">
	  
		
	<TR class="labelmedium line">
	    <td width="5%" align="center"></td>
	    <td width="10%"><cf_tl id="Bank"></td>
		<td width="30%"><cf_tl id="Address"></td>
		<td width="10%"><cf_tl id="Type"></td>
		<TD width="6%"><cf_tl id="Curr"></TD>
		<TD width="13%"><cf_tl id="Account"></TD>
		<TD width="13%"><cf_tl id="ABA"></TD>
		<TD width="10%"><cf_tl id="Swift"></TD>
	</TR>
		
	<cfset last = '1'>
	
	<cfoutput query="Search">
			
	<tr class="labelmedium navigation_row">
		<td align="center" height="20">
		
		     <cfinvoke component="Service.Access"  method="employee"  personno="#URL.ID#" returnvariable="access">
			 
		     <cfif access eq "EDIT" or access eq "ALL">
			  			    
		             <img src="#SESSION.root#/Images/bank.gif" alt="" name="img0_#currentRow#"
					  onMouseOver="document.img0_#CurrentRow#.src='#SESSION.root#/Images/button.jpg'" 
					  onMouseOut="document.img0_#CurrentRow#.src='#SESSION.root#/Images/bank.gif'"  
					  style="cursor:pointer"
					  width="17" 
					  height="12" 
					  class="navigation_action"
					  onclick="edit('#URL.ID#','#AccountId#')"
					  border="0" 
					  align="absmiddle">
		       
			 </cfif>  
			 
		</td>	
		<td><a href="javascript:edit('#URL.ID#','#AccountId#')">#Description#</a></td>
		<td>#BankAddress#</td>
		<td>#AccountType#</td>
		<TD>#AccountCurrency#</TD>
		<td>#AccountNo#</td>
		<TD>#AccountABA#</TD>
		<TD>#Swiftcode#</TD>
	
	
		<TR class="navigation_row_child line" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F6F6F6'))#">
			<td colspan="8" style="padding-left:30px">#Remarks#</td>
		</tr>
	
	 
		
	</cfoutput>
	
	</TABLE>
	
	</tr>

</td>

</table>

<cfset ajaxonload("doHighlight")>