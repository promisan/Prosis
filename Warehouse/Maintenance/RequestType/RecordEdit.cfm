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
			  label="Request Type" 
			  layout="webapp" 
			  option="Maintain request type [#url.id1#]" 
			  banner="yellow"
			  JQuery="yes" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Request
	WHERE  Code = '#URL.ID1#'
</cfquery>

<cfquery name="CountRec" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  	SELECT TOP 1 RequestType
 	FROM  	RequestHeader
  	WHERE 	RequestType = '#URL.ID1#' 
</cfquery>

<script language="JavaScript">
	
	function ask() {
		if (confirm("Do you want to remove this record ?")) {	
		return true 	
		}	
		return false	
	}
	
	function validateFileFields(control) {			 			
		
		var controlValidate = document.getElementById('validateTemplate');
	
		if (controlValidate) {
			if (controlValidate.value == 0 && $('#TemplateApply').val() != '') {
				alert('Template path does not exist.');
				return false;
			}
		}
		
		if (control != null) control.focus();		
		return true;
	}


	function editworkflow(id1,id2) {
	   
	   	var vWidth = 900;
		var vHeight = 700;    
				   
		ColdFusion.Window.create('mydialog', 'Warehouse Edit', '',{x:30,y:30,height:vHeight,width:vWidth,modal:true,center:true});    
		ColdFusion.Window.show('mydialog'); 				
		ColdFusion.navigate('RequestWorkflowEdit.cfm?ID1='+id1+'&ID2='+id2+'&ts='+new Date().getTime(),'mydialog'); 
	   
	}
	
	function deleteworkflow(t,a) {
		if (confirm('Do you want to delete this workflow ?')) {
			ColdFusion.navigate('RequestWorkflowPurge.cfm?id1='+t+'&id2='+a,'listing');
		}
	}
	
	function validateFileFields2(control) {			 			
		document.frmRequestWorkflow.customForm.focus(); 
		document.frmRequestWorkflow.customForm.blur();
		
		var controlValidate = document.getElementById('validateTemplate');
		
		if (controlValidate) {
			if (controlValidate.value == 0 && document.frmRequestWorkflow.customForm.value != '') {
				alert('Custom form path does not exist.');
				return false;
			}
		}
		
		if (control != null) control.focus();
		
		return true;
	}
	
	function ask() {
		if (confirm("Do you want to remove this record ?")) {	
		return true 	
		}	
		return false	
	}

</script>

<cfajaximport tags="cfform">

<!--- edit form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="frmRequestType">

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding formpadding">

	<tr><td height="6"></td></tr>
    <cfoutput>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="labelmedium" colspan="2">
	   <cfif CountRec.recordCount eq 0>
  	   		<cfinput type="text" name="Code" value="#get.Code#" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
	   <cfelse>
	   		#get.Code#
	   </cfif>
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.Code#" size="20" maxlength="20" readonly>
    </TD>
	</TR>
	
	 <TR>
    <TD class="labelmedium">Description:</TD>
    <TD colspan="2">
  	   <cfinput type="text" name="Description" value="#get.Description#" message="Please enter a code" required="No" size="30" maxlength="50" class="regularxl">	   
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Template:</TD>
    <TD width="300" class="labelit">
	
		<!--- #SESSION.root# --->Warehouse/Application/
	 	<cfset templateDirectory = "Warehouse/Application/">
		
	 	<cfinput type="Text" 
			name="TemplateApply" 
			value="#get.TemplateApply#" 
			message="Please enter a template" 
			onblur= "ColdFusion.navigate('CollectionTemplate.cfm?template=#templateDirectory#'+this.value+'&container=templateValidationDiv&resultField=validateTemplate','templateValidationDiv')"
			required="No" 
			size="30" 
			maxlength="30" 
			class="regularxl">		
											
	 </TD>
	 <td width="35%" valign="left">
	 	<cfdiv id="templateValidationDiv" bind="url:CollectionTemplate.cfm?template=#templateDirectory##get.TemplateApply#&container=templateValidationDiv&resultField=validateTemplate">				
	 </td>
	</TR>
	
	<TR>
    <TD class="labelmedium">Order:</TD>
    <TD colspan="2">
  	   <cfinput type="Text" name="listingOrder" value="#get.listingOrder#" message="Please enter a numeric listing order" validate="integer" required="Yes" size="2" maxlength="3" class="regularxl" style="text-align:center;">
    </TD>
	</TR>
	
		
	<TR>
		<TD style="width:150" class="labelmedium">Enforce Program:</TD>
	    <TD class="labelmedium" colspan="2">
		    <table><tr class="labelmedium" >
			<td><input type="radio" name="ForceProgram" id="ForceProgram" value="0" <cfif get.ForceProgram eq 0>checked</cfif>></td>
			<td style="padding-left:6px">No</td>
			<td style="padding-left:9px"><input type="radio" name="ForceProgram" id="ForceProgram" value="1" <cfif get.ForceProgram eq 1>checked</cfif>></td>
			<td style="padding-left:6px">Yes</td>
			</tr>
			</table>
	    </TD>
	</TR>
	
	<TR>
		<TD class="labelmedium">Shipment Order:</TD>
	    <TD class="labelmedium" colspan="2">
		    <table><tr class="labelmedium" >
			<td><input type="radio" name="StockOrderMode" id="StockOrderMode" value="0" <cfif get.StockOrderMode eq 0>checked</cfif>></td>
			<td style="padding-left:6px">No</td>
			<td style="padding-left:9px"><input type="radio" name="StockOrderMode" id="StockOrderMode" value="1" <cfif get.StockOrderMode eq 1>checked</cfif>></td>
			<td style="padding-left:6px">Yes</td>
			</tr>
			</table>
		  
	    </TD>
	</TR>
	
	<TR>
		<TD class="labelmedium">Operational:</TD>
	    <TD class="labelmedium" colspan="2">
		
			  <table><tr class="labelmedium" >
			<td><input type="radio" name="Operational" id="Operational" value="0" <cfif get.operational eq 0>checked</cfif>></td>
			<td style="padding-left:6px">No</td>
			<td style="padding-left:9px"><input type="radio" name="Operational" id="Operational" value="1" <cfif get.operational eq 1>checked</cfif>></td>
			<td style="padding-left:6px">Yes</td>
			</tr>	
		</table>		
	    </TD>
	</TR>
	
			
	</cfoutput>
	
	<tr><td colspan="3" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="3" height="40">
	<cf_button type="button" style="width:80" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">			
	<cfif CountRec.recordcount eq "0"><cf_button class="button10g" type="submit" style="width:80" name="Delete" id="Delete" value="Delete" onclick="return ask()"></cfif>
    <cf_button type="submit" style="width:80" name="Update" id="Update" value="Update" onclick="return validateFileFields(this)">
	</td>	
	
	</tr>
	
</table>

</cfform>


<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	<tr><td height="4"></td></tr>
	<tr><td class="line">
	<TR>
		<TD valign="middle" class="labellarge">
		    <font color="0080C0">			
			Request actions (and associated workflow)
			</font>
		</TD>	
	</TR>	
		
	<tr>
	<td>
			
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
			<tr>	
			    <td width="100%" id="listing">
				
					<cfinclude template="RequestWorkflowListing.cfm">			
				</td>		
			</tr>		
		
		</table>	
		
	</td></tr>
</table>

<cf_screenbottom layout="webapp">
	