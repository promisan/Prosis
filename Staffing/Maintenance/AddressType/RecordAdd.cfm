<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Address Type" 
			  scroll="Yes" 
			  layout="webapp" 			  
			  menuAccess="Yes" 
			  jquery="Yes"
			  systemfunctionid="#url.idmenu#">
			  
			  
<cf_colorScript>			  

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

    <tr><td height="6"></td></tr>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD>
  	   <cfinput type="Text" name="AddressType" value="" message="Please enter a code" required="Yes" size="20" maxlength="20" class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium" valign="top" style="padding-top:4px">Description:</TD>
    <TD class="labelmedium">
	
	<cf_LanguageInput
		TableCode       = "Ref_AddressType" 
		Mode            = "Edit"
		Name            = "Description"
		Value           = ""
		Key1Value       = ""
		Type            = "Input"
		Required        = "Yes"
		Message         = "Please enter a description"
		MaxLength       = "50"
		Size            = "35"
		Class           = "regularxxl">	
		
		<!---	
	  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="35" maxlength="40" class="labelmedium">
	    --->
	   
    </TD>
	</TR>
	
	
	<TR>
    <TD class="labelmedium">Listing order:</TD>
    <TD class="labelmedium">
  	   <cfinput type="Text" name="ListingOrder" value="1" message="Please enter a description" required="Yes" size="1" maxlength="50" class="regularxxl">
    </TD>
	</TR>
	
	<cfquery name="Workflow" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_EntityClass
		WHERE EntityCode = 'PersonAddress'
	</cfquery>
	
	<tr class="labelmedium">
	<td>Workflow Class:</td>
	<td>
		
		<select name="EntityClass" class="regularxxl">
		    <option value="">N/A</option>
			<cfoutput query="WorkFlow">
				<option value="#EntityClass#">#EntityClassName#</option>
			</cfoutput>		
		</select>		
		
	</td>
	</tr>
	
	<tr class="labelmedium">
	<td>Marker Color:</td>
	<td>		  					  					   
		<cf_color 	name="color" 
			style="cursor: pointer; font-size: 0; border: 1px solid gray; height: 20; width: 20; ime-mode: disabled; layout-flow: vertical-ideographic;">   				     
	</td>
	</tr>
	
	<tr class="labelmedium">
	<TD>Operational:</TD>
	    <TD>
			<input type="radio" class="radiol" name="operational" value="0">No
			<input type="radio" class="radiol" name="operational" value="1" checked>Yes	
	    </TD>
	</tr>
	
</table>

<cf_dialogBottom option="add">

</CFFORM>


