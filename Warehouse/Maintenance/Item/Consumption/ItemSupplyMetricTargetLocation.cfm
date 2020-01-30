<cfquery name="getLookup" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*,
			(SELECT Description FROM Ref_LocationClass WHERE Code = L.LocationClass) as ClassDescription
	FROM 	Location L
	WHERE 	Mission = '#url.mission#'
	AND		StockLocation = 1
	ORDER BY LocationName
</cfquery>

<cfif getLookup.recordcount gt 0>

	<table width="100%">
		<tr>
			<td width="25%"><cf_tl id="Geographical Location">:</td>
			<td>
			
			<cfif url.action eq "new">
			<!-- <cfform> -->
			
			<cfselect 	name="Location" 
						value="location" 
						display="LocationName" 
						group="ClassDescription" 
						query="getLookup" 
						selected="#url.location#" queryposition="below">
						<option value=""></option>
			</cfselect>
			
			<!-- </cfform> -->
			
			<cfoutput>
			<input type="Hidden" name="LocationOld" id="LocationOld" value="#url.location#">	
			</cfoutput>	
			
			<cfelse>
				<cfoutput>				
				<input type="Hidden" name="Location" id="Location" value="#url.location#">	
				<input type="Hidden" name="LocationOld" id="LocationOld" value="#url.location#">	
				</cfoutput>
			</cfif>
			
			</td>
		</tr>
	</table>

<cfelse>

	<table class="hide">
		<tr>
			<td>
				<input type="Hidden" name="Location" id="location" value="">
				<input type="Hidden" name="LocationOld" id="LocationOld" value="">
			</td>
		</tr>
	</table>

</cfif>