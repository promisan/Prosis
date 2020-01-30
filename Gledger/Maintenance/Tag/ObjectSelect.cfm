<cfparam name="url.val" default="">
<cfparam name="url.mode" default="Add">

<cfif url.val neq "">

	<cfif url.mode eq "Add">
	
	<cfquery name="Insert" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_CategoryObject
		(Code,Object)
		VALUES
		('#URL.ID1#','#URL.Val#')
	</cfquery>
	
	<cfelse>
	
	<cfquery name="Delete" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_CategoryObject
			WHERE  Code  = '#URL.ID1#'
			AND    Object = '#URL.Val#'
	</cfquery>
	
	</cfif>

</cfif>

<cfoutput>

<table width="99%" aling="center" border="0" bgcolor="ffffff" cellspacing="0" cellpadding="0">
				
		<cfquery name="ObjSel" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_CategoryObject
			WHERE  Code = '#URL.ID1#'
		</cfquery>
		
		<cfset o = "">
						
		<cfloop query="ObjSel">
		
			<cfif o eq "">
				<cfset o = "'#Object#'">
			<cfelse>
				<cfset o = "#o#,'#Object#'">
			</cfif>
					
			<cfquery name="Object" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_Object
					WHERE  Code = '#Object#' 
			</cfquery>
			
		    <tr>
				<td height="25" class="labelit" width="90%">&nbsp;#Object# #Object.Description#</td>
				<td style="padding-top:3px;"> <cf_img icon="delete" onclick="selected('#Object#','delete')"> </td>
			</tr>
			
		</cfloop>	
		
		<cfquery name="ObjectList" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT ObjectUsage,Code, Code+' '+Description as Description
			FROM   Ref_Object
			<cfif o neq "">
			WHERE  Code NOT IN (#preservesingleQuotes(o)#)
			</cfif>
			ORDER BY ObjectUsage
		</cfquery>
			
		<cfform>			
		<TR>
		    <TD colspan="2">
			
			<cfselect name="obj" group="ObjectUsage" style="width:340" query="ObjectList" value="Code" display="Description" visible="Yes" enabled="Yes" class="regularxl" 
			    onChange="selected(this.value,'add')"/>	
			
			</TD>
		</TR>
			
		</cfform>
			
		</table>
		
</cfoutput>		