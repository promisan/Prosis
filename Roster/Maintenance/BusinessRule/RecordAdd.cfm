
<cfparam name="url.idmenu" default="">

<cfinclude template="Script.cfm">
		
<cf_screentop height="100%"
              banner="Gray"			  
			  scroll="Yes" 
			  layout="webapp" 
			  label="Add Business Rule" 
			  menuAccess="Yes"
			  line="No" 
			  systemfunctionid="#url.idmenu#">
			  
<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="95%" cellspacing="0" cellpadding="0" align="center" id="myTable" class="formpadding">
	
    <tr>
    <td class="labelit" style="">Owner:</td>
    <td>
	
		<cfquery name="GetOwners" 
				 datasource="AppsSelection" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 
				 	SELECT DISTINCT Owner
					FROM   Ref_StatusCode
				 
		</cfquery>
		
		<cfselect name="Owner" id="Owner">
			<cfoutput query="GetOwners">
				<option value="#Owner#">#Owner#</option>
			</cfoutput>
		</cfselect>
		
    </td>
	</tr>
	
    <tr>
    <td class="labelit" style="" width="20%">Trigger Group:</td>
    <td>
  	   <cfselect id="TriggerGroup" name="TriggerGroup" onChange="showFields()">
		   	<option value="Bucket">Bucket</option>
			<option value="Process">Process</option>
	   </cfselect>
    </td>
	</tr>
	
    <tr>
    <td class="labelit" style="">Code:</td>
    <td>
  	   <cfinput type="Text" name="Code" id="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10">
    </td>
	</tr>
	
    <tr>
    <td class="labelit" style="">Description:</td>
    <td>
  	   <cfinput type="Text" name="Description" id="Description" value="" style="width:100%" maxlength="100">
    </td>
	</tr>
	
    <tr valign="top" class="r_Process">
    <td class="labelit" style="">Message:</td>
    <td>
		 <textarea style="width:100%" maxlength="300" rows="4" class="regular" name="MessagePerson" id="MessagePerson" onkeyup="return ismaxlength(this)" ></textarea>
    </td>
	</tr>

	<tr class="r_Process">
		<td class="labelit" style="">Color:</td>
		<td>
			 <cfinput type="Text" name="Color" id="Color" value="" size="38" maxlength="20">
		</td>
	</tr>

    <tr class="r_Process">
	   	<td colspan="2" style="" width="100%">
			<table width="100%">
				<tr>
					<td class="labelit" width="20%"> Validation Path:</td><td align="left"><cfinput type="Text" name="ValidationPath" id="ValidationPath" value="" size="38" maxlength="120" onBlur="validateTemplate()"></td>
					<td class="labelit" style="padding-left:5px" align="left">Template:</td><td><cfinput type="Text" name="ValidationTemplate" id="ValidationTemplate" value="" size="20" maxlength="50" onBlur="validateTemplate()"></td>
					<td id="templateValidation"></td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr class="r_Bucket">
		<td class="labelit" style="">Status To:</td>
		<td>
			 <cf_securediv bind="url:getStatus.cfm?owner={Owner}" bindOnLoad="yes">
		</td>
	</tr>

	<tr>
		<td class="labelit" style="">Source:</td>
		<td> Manual
			<input type="hidden" value="Manual" id="Source" name="Source">
		</td>
	</tr>

	<tr>
		<td class="labelit" style="">Operational:</td>
		<td>
			 <cfinput type="checkbox" name="Operational" id="Operational" value="1" checked>
		</td>
	</tr>
	
	<tr>
		<td colspan="2" height="10px"></td>
	</tr>
	
	<tr>	
	<td align="center" colspan="2"  valign="bottom">
		<input class="button10g" type="submit" name="Insert" value=" Submit ">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	</td>	
	</tr>
			
</TABLE>

</CFFORM>

<cfset AjaxOnLoad("showFields")> 