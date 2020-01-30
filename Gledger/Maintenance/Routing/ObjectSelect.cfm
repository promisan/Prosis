<cfparam name="url.object" default="">

<cfoutput>

<table width="99%" aling="center" border="0" bgcolor="ffffff" cellspacing="0" cellpadding="0">
				
		<cfquery name="ObjectList" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT ObjectUsage,Code, Code+' '+Description as Description
			FROM   Ref_Object
			ORDER BY ObjectUsage
		</cfquery>
			
		<TR>
		    <TD colspan="2">
				<cfselect 
					name	="obj" 
					group	="ObjectUsage" 
					style	="width:360" 
					query	="ObjectList" 
					value	="Code" 
					display	="Description" 
					visible	="Yes"
					selected="#URL.object#"  
					enabled	="Yes"
					required="No" 
					class	="regularxl" 
			    	onChange="selected(this.value,'add')"
					queryPosition="below">
						<option value=""></option>	
				</cfselect>			
			</TD>
		</TR>
			
		</table>
		
</cfoutput>		