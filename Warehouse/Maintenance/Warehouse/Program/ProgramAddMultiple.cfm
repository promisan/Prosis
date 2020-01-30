
<cf_tl id="Add Project Warehouse"       var = "vHead">
<cf_tl id="Save"      					var = "vSave">

<cfquery name="Warehouse" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM 	Warehouse
	WHERE 	Warehouse = '#url.warehouse#'
</cfquery>

<cfquery name="get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT	P.*,
			(SELECT ProgramCode FROM Materials.dbo.WarehouseProgram WHERE Warehouse = '#url.warehouse#' AND ProgramCode = P.ProgramCode) as Selected
	FROM	Program P 
	WHERE	P.Mission      = '#Warehouse.Mission#'
	AND		P.ProgramClass != 'Program'
	ORDER BY ProgramName
</cfquery>


<cf_screentop height="100%" scroll="yes" label="#vHead#" layout="webapp" banner="yellow" user="no">

<table class="hide">
	<tr><td colspan="2"><iframe name="processProgramWarehouseMulti" id="processProgramWarehouseMulti" frameborder="0"></iframe></td></tr>
</table>

<cfform action="Program/ProgramAddMultipleSubmit.cfm?warehouse=#url.warehouse#" name="frmProgramWarehouseMulti" method="POST" target="processProgramWarehouseMulti">

<table width="100%" align="center">
	<tr><td height="10"></td></tr>
	<tr>
		<td>
			<table width="98%" align="center">
				<tr>
					<td width="20"></td>
					<td>
						<table width="100%" align="center">
							<tr>
								<cfset cols = 2> 
								<cfset cnt = 0>
								<cfoutput query="get">
									<cfset cnt = cnt + 1>
									<td style="width:#100/cols#%;" class="labelmedium">
										<input type="Checkbox" id="prog_#ProgramCode#" name="prog_#ProgramCode#" value="#ProgramCode#" <cfif selected eq ProgramCode>checked</cfif>> #ProgramCode# - #ProgramName#
									</td>
								
									<cfif cnt eq cols>
										<cfset cnt = 0>
										</tr>
										<tr>
									</cfif>
								</cfoutput>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td height="10"></td></tr>
	<tr><td class="line"></td></tr>
	<tr><td height="10"></td></tr>
	<tr>
		<td align="center">
			<cf_button2 type="submit" name="save" id="save" text="  Save  ">
		</td>
	</tr>
	
</table>

</cfform>