<cfset vSelectedColor = "##D2FDC6">

		
	<cfquery name="programStatus" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	S.*,
					(SELECT ProgramStatus FROM Ref_ProgramCategoryStatus WHERE Code = '#vThisCode#' AND ProgramStatus = S.Code) as Selected
			FROM 	Ref_ProgramStatus S
			ORDER BY S.StatusClass
	</cfquery>
	
	<cfoutput query="programStatus" group="StatusClass">
	
		<tr>
			<td class="labelmedium" width="10%" valign="top" style="padding-top:3px;">
				<table>
					<tr>
						<td class="labelmedium">
							#StatusClass#:
						</td>
					</tr>
				</table>
			</td>
		
			<td valign="top" style="padding-top:3px;">
				<table>
					<cfoutput>
					
						<cfset vStatusId = replace(code," ","","ALL")>
						
						<cfset vStatusStyle = "">
						<cfif Selected eq Code>
							<cfset vStatusStyle = "background-color:#vSelectedColor#;">
						</cfif>
						
							
							<tr class="navigation_row clsClass_#StatusClass#">
								<td style="#vStatusStyle#" class="row_#vStatusId#" width="2%">
									<input type="Checkbox" 
										id="status_#vStatusId#" 
										name="status_#vStatusId#" 
										onclick="selectorHL('.row_#vStatusId#','#vSelectedColor#',this.checked)" 
										<cfif Selected eq Code>checked</cfif>>
								</td>
								<td style="#vStatusStyle#" class="labelmedium row_#vStatusId#"><label for="status_#vStatusId#">#Description#</label></td>
							</tr>
						
						
					</cfoutput>
				</table>													
			</td>
		
		</tr>
		
		<tr><td colspan="2" class="linedotted"></td></tr>
		
	</cfoutput>
				
			
	<tr>
		<td class="labelmedium" valign="top" style="padding-top:3px;">Text entry areas:</td>
		<td valign="top" style="padding-top:3px;">
			<cfquery name="programProfile" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT 	A.*,
							(SELECT TextAreaCode FROM Ref_ProgramCategoryProfile WHERE Code = '#vThisCode#' AND TextAreaCode = A.Code) as Selected
					FROM 	Ref_TextArea A
					WHERE	A.TextAreaDomain = 'Category' 
					ORDER BY A.TextAreaDomain, A.TextAreaSection, A.ListingOrder ASC
			</cfquery>
			
			<table width="100%" class="navigation_table">
				<cfoutput query="programProfile">
					<cfset vProfileId = replace(code," ","","ALL")>
					
					<cfset vProfileStyle = "">
					<cfif Selected eq Code>
						<cfset vProfileStyle = "background-color:#vSelectedColor#;">
					</cfif>
					<tr class="navigation_row" id="rowp_#vProfileId#">
						<td style="#vProfileStyle#" width="2%">
							<input 
								type="Checkbox" 
								id="profile_#vProfileId#" 
								name="profile_#vProfileId#" 
								onclick="selectorHL('##rowp_#vProfileId#','#vSelectedColor#',this.checked)"
								<cfif Selected eq Code>checked</cfif>>
						</td>
						<td style="padding-left:6px; #vProfileStyle#" class="labelmedium">
							<label for="profile_#vProfileId#">
								#Description#
							</label>
						</td>
					</tr>
				</cfoutput>
			</table>
		</td>
	</tr>