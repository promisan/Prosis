
<cf_screentop layout="webapp" user="No" bannerheight="1" height="100%" html="Yes" label="Copy Workflow Settings">

<cfoutput>

<cfquery name="EntClass" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	Select EntityClass, EntityClassName
	FROM Ref_EntityClass
	WHERE EntityCode = '#URL.EntityCode#' 
	<cfif URL.PublishNo eq "">
		AND EntityClass != '#URL.EntityClass#'
	</cfif>
</cfquery>
	


<!--- edit form --->

<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="10"></td></tr>
	<tr><td colspan="2" class="labelmedium">	
	This option allows you to copy and overwrite the draft workflow of a workflow of your choice. 
	</td></tr>
	
	<tr><td colspan="2" class="labelmedium">	
	You may copy a workflow to a different class under the same entity. 
	</td></tr>
	
	<tr><td height="10"></td></tr>
	<tr><td colspan="2" class="labelmedium">
	<font color="FF8080">Use with care as this action can not be undone.
	</td></tr>
	<tr><td height="10"></td></tr>
	
	<TR>
    <TD class="labelmedium">Select Class to restore:</TD>
    <TD>
            <select name="EClass" id="EClass" class="regularxl">
            <cfloop query="EntClass">
            	<option value="#EntityClass#"<cfif EntityClass eq Url.EntityClass>Selected="Yes"</cfif>>#EntityClassName#</option>
            </cfloop>
			</select>					
	</TD>
	</TR>
	
	<tr><td height="40"></td></tr>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<tr><td height="5"></td></tr>

	<td align="center" colspan="2">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="ColdFusion.Window.hide('mydialog');">
    <input class="button10g" type="button" name="Print" id="Print" value=" Copy " onClick="copytoreturn();">
	</td>	
	
</TABLE>

</cfoutput>

<cf_screenbottom layout="webapp">
