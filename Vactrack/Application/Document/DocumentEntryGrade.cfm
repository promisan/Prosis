
<cfquery name="Grd" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_PostGrade
		WHERE    PostGrade IN (SELECT PostGrade FROM Position WHERE Mission = '#url.mission#')			
		ORDER BY PostOrder
</cfquery>		
		
<select name="postgrade" id="postgrade" class="regularxxl" style="font-size:20px;height:34px;border:0px;background-color:f1f1f1;">
			 
	 <cfoutput query="Grd">
			<option value="#PostGrade#">#PostGrade#</option>
	 </cfoutput>
		
</select>
	
	