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
<cf_screentop height="100%" html="No">

<cfparam name="URL.FunctionId" default="">
<cfparam name="URL.SerialNo"   default="">
<cfparam name="URL.FieldId"    default="">
<cfparam name="URL.Type"       default="">
<cfparam name="URL.ListValue"  default="">

<cfoutput>
	<script>
		function edit(code){
			window.location = 'FieldEditLookup.cfm?FunctionId=#URL.FunctionId#&SerialNo=#URL.SerialNo#&FieldId=#URL.FieldId#&Type=#URL.Type#&ListValue='+code;
		}

		function deleteRecord(code){
			window.location = 'FieldEditLookupPurge.cfm?FunctionId=#URL.FunctionId#&SerialNo=#URL.SerialNo#&FieldId=#URL.FieldId#&Type=#URL.Type#&ListValue='+code;
		}
	</script>
	
</cfoutput>

<cfset cnt = 0>

<cfquery name="Field" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ModuleControlDetailField
	WHERE SystemFunctionId = '#URL.FunctionId#'
	AND   FunctionSerialNo = '#URL.SerialNo#' 
	AND   FieldId		   = '#URL.FieldId#'
</cfquery>

<cfquery name="List" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ModuleControlDetailFieldList
	WHERE SystemFunctionId = '#URL.FunctionId#'
	AND   FunctionSerialNo = '#URL.SerialNo#' 
	AND   FieldId		   = '#URL.FieldId#'
	AND   ListType		   = '#URL.Type#'
	ORDER BY ListOrder
</cfquery>

<cfoutput>

<cfform action="FieldEditLookupSubmit.cfm" method="POST" name="form#URL.Type#" id="form#URL.Type#">

<table width="95%" cellpadding="0" align="left">
	    
	 <cfinput type = "hidden" value="#URL.FunctionId#" id="FunctionId" name="FunctionId">
	 <cfinput type = "hidden" value="#URL.SerialNo#"   id="SerialNo"   name="SerialNo">
	 <cfinput type = "hidden" value="#URL.FieldId#"    id="FieldId"    name="FieldId">
	 <cfinput type = "hidden" value="#URL.Type#"       id="Type"       name="Type">
	 <tr>
	    <td width="100%" class="regular">
	    <table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
			
	    <TR class="labelmedium line">
		   <td width="38%">Value</td>
		   <td width="48%">Description</td>
		   <td>Sorting</td>
		   <td width="10%" align="center">Enable</td>
		   <td width="7%"></td>
		   <td width="7%"></td>
	    </TR>	
					
		<cfloop query="List">
		
		<cfset nm = ListValue>
		<cfset de = ListDisplay>
		<cfset od = ListOrder>
		<cfset op = Operational>
												
		<cfif URL.ListValue eq nm>
		
		    <cfinput type="hidden" name="ListValue" id="ListValue" value="#nm#">
												
			<TR>
			   <td>&nbsp;#nm#</td>
			   <td>
			   	   <cfinput type="Text" value="#de#" name="ListDisplay" message="You must enter a description" required="Yes" size="30" maxlength="30" class="regularxl">
	           </td>
			    <td>
			   	   <cfinput type="Text"
			       name="ListOrder"
			       value="#od#"
			       message="You must enter a valid order"
			       validate="integer"			      	     
			       size="2"
			       maxlength="2"
			       class="regularxl">
	           </td>
			   <td class="regular" align="center">
			      <cfinput type="checkbox" name="Operational" id="Operational" value="1" >
				</td>
			   <td colspan="2" align="right"><cfinput type="submit" value=" Update " name="Update" id="Update">&nbsp;</td>
		    </TR>	
					
		<cfelse>
		
			<TR class="labelmedium line">
			   <td>#nm#</td>
			   <td>#de#</td>
			   <td>#od#</td>
			   <td align="center"><cfif #op# eq "0"><b>No</b><cfelse>Yes</cfif></td>
			   <td>
			   	<cf_img icon="edit" onclick="edit('#ListValue#')">
			   </td>
			   <td width="30">
			   	 <cf_img icon="delete" onclick="deleteRecord('#ListValue#')">
				<a>
			  </td>
			   
		    </TR>	
		
		</cfif>
						
		</cfloop>
						
		<cfif URL.ListValue eq "">
					
			<TR>
			<td><cfinput type="Text" name="ListValue" message="You must enter a value" required="Yes" size="20" maxlength="20" class="regularxl"></td>			
			<td><cfinput type="Text" name="ListDisplay" message="You must enter a description" required="Yes" size="30" maxlength="30" class="regularxl"></td>
			<td>
			  <cfinput type="Text"
			       name="ListOrder"
			       value="#List.recordcount+1#"
			       message="You must enter a valid order"
			       validate="integer"			      	     
				   style="text-align:center"
			       size="1"
			       maxlength="2"
			       class="regularxl">
			</td>			
			<td align="center"><cfinput type="checkbox" name="Operational" id="Operational" value="1" checked></td>
			<td colspan="2" align="right"><cfinput type="submit" value=" Add " id="Add" name="Add" class="button4"></td>			    
			</TR>	
			
			<cfset cnt = cnt + 25>
								
		</cfif>	
		
		</table>
		
		</td>
		</tr>
						
	</table>	
		
</cfform>

<script language="JavaScript">
	
	{	frm  = parent.document.getElementById("lookup#URL.Type#");
		he = 28+#cnt#+#list.recordcount*25#;
		frm.height = he
	}
	
</script>

</cfoutput>
