
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  title="Add Financial Tag" 
			  label="Add Financial Tag" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Entity" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Entity
</cfquery>

<cfquery name="Class" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_CategoryClass
</cfquery>

<cfquery name="MissionSelect" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_ParameterMission
</cfquery>

<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

     <tr><td></td></tr>
	
	 <TR>
	 <TD width="80" class="labelmedium">Entity:&nbsp;</TD>  
	 <TD width="90%">
	 	<select name="EntityCode" class="regularxl">
		<cfoutput query="entity">
		<option value="#EntityCode#">#EntityDescription#</option>
		</cfoutput>
		</select>
	 </TD>
	 </TR>	 
	  
	 <TR>
	 <TD width="80"  class="labelmedium">Mission:&nbsp;</TD>  
	 <TD width="80%">
	 	<select name="Mission" class="regularxl">
		<option value="">any</option>
		<cfoutput query="missionSelect">
		<option value="#Mission#">#Mission#</option>
		</cfoutput>
		</select>
	 </TD>
	 </TR>
	 
	 <TR>
	 <TD width="80"  class="labelmedium">Class:&nbsp;</TD>  
	 <TD width="80%">
	 	<select name="CategoryClass" class="regularxl">
		<cfoutput query="Class">
		<option value="#Code#">#Description#</option>
		</cfoutput>
		</select>
	 </TD>
	</TR>
	 	
	<TR>
	 <TD class="labelmedium">Code:&nbsp;</TD>  
	 <TD>
		<cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="20" maxlength="20"
		class="regularxl">
	 </TD>
	</TR>
		
    <TR>
    <TD class="labelmedium">Description:&nbsp;</TD>
    <TD>
		<cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="50"
		class="regularxl">				
    </TD>
	</TR>
			
	<cfquery name="ObjectList" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT ObjectUsage,Code, Code+' '+Description as Description
		FROM Ref_Object
		ORDER BY ObjectUsage
	</cfquery>
	
    <TR>
    <TD class="labelmedium">Show for Object:&nbsp;<cf_space spaces="40"></TD>
    <TD>
	
	<cfselect name="Object1" group="ObjectUsage" query="ObjectList" style="width:350px" value="Code" display="Description" visible="Yes" enabled="Yes" class="regularxl"></cfselect>
						
    </TD>
	</TR>
	
    <TR>
    <TD class="labelmedium">additional:&nbsp;</TD>
    <TD>
	
	<cfselect name="Object2" group="ObjectUsage" query="ObjectList" style="width:350px" value="Code" display="Description" visible="Yes" enabled="Yes" class="regularxl"></cfselect>
					
    </TD>
	</TR>
	
	<tr><td height="4"></td></tr>
		
	<tr><td colspan="2" class="linedotted"></td></tr>
  
	<tr>
	
	<td colspan="2" height="40" align="center">
	<input class="button10g"  type="button" name="Cancel" value="Close" onClick="window.close()">
	<input class="button10g"  type="submit" name="Insert" value="Save">
	</td>
	</tr>
	
</table>

</CFFORM>
