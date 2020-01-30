<cfif trim(url.orgunit) neq "">

	<cfquery name="Org"
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	* 
			FROM  	Organization 
			WHERE  	OrgUnit = '#url.orgunit#'
	</cfquery>           

	<cfoutput>
		<table>
			<tr>
				<td>
					<img src="#SESSION.root#/Images/search.png" alt="Select Implementer" name="img66" 
						onMouseOver="document.img66.src='#SESSION.root#/Images/search1.png'" 
						onMouseOut="document.img66.src='#SESSION.root#/Images/search.png'"
						style="cursor: pointer;border:1px solid black;border-radius:4px;" alt="" width="25" height="23" border="0" align="absmiddle" 
						onClick="selectorgN('#url.mission#','Administrative','orgunit1_#mission#','setOrgUnit','#url.mission#','1','modal')">
				</td>
				<td style="padding-left:5px;">
					<input 
						type="text"   
						name="orgunitname1_#mission#"  
						id="orgunitname1_#mission#" 
						class="regularxl orgunit" 
						value="#Org.OrgUnitName#" 
						style="width:300px;"
						data-value="#mission#" 
						readonly>
					<input type="hidden" name="orgunit1_#mission#" id="orgunit1_#mission#"  value="#Org.OrgUnit#">
				</td>
			</tr>
		</table>
	</cfoutput>

</cfif>