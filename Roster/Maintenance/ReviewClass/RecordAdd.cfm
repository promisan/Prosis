<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
		      scroll="Yes" 
			  layout="webapp" 
			  label="Add Review Class" 
			  menuAccess="Yes"
			  jquery="yes" 
			  systemfunctionid="#url.idmenu#">
			  
<cfajaximport tags="cfform">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">


<!--- Entry form --->

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	<tr><td height="10"></td></tr>
    <TR>
    <TD class="labelmedium" width="20%">Code:</TD>
    <TD class="labelmedium">
  	   <cfinput 
	   		type="Text" 
			name="Code" 
			id="Code" 
			value="" 
			message="Please enter a code" 
			required="Yes" 
			size="10" 
			maxlength="10" 
			onchange="ColdFusion.navigate('Owner.cfm?code='+this.value,'divOwner');" 
			class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
			
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD class="labelmedium">
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="30" class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
		
	<cfquery name="Category" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ParameterSkill
	</cfquery>
	
	<TR>
    <TD class="labelmedium">Category:</TD>
    <TD>
	   <select name="ExperienceCategory" class="regularxl">
	   <option selected></option>
	   <cfoutput query="category">
	   <option value="#Code#">#Description#</option>
	   </cfoutput>
	   </select>
  	</TD>
	</TR>
	
	<tr>
		<td class="labelmedium" valign="top" style="padding-top:5px;">Owners:</td>
		<td class="labelmedium" valign="top" style="padding-top:3px;">
			<cf_securediv id="divOwner" bind="url:Owner.cfm?code=">
		</td>
	</tr>

	<tr><td colspan="2" height="6"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" height="6"></td></tr>	
		
	<tr>
		<td colspan="2" align="center">
	    <input class="button10g" type="submit" name="Insert" value=" Save ">
		</td>	
	</tr>
		
</table>




</CFFORM>


</BODY></HTML>