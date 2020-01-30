
<cfquery name="Grd" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_PostGrade
		WHERE    PostGrade IN (SELECT PostGrade FROM Position WHERE Mission = '#url.mission#')			
		ORDER BY PostOrder
</cfquery>		
		
<select name="postgrade" id="postgrade" class="regularxl" style="height:;font-size:27px;height:39px">
			 
	 <cfoutput query="Grd">
			<option value="#PostGrade#" class="regularxl">#PostGrade#</option>
	 </cfoutput>
		
</select>
	
	