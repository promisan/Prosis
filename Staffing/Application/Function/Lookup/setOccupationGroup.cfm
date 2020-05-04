
<cfoutput>

			
	<cfquery name="OccGroupList" 
	  datasource="AppsSelection" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT   *
	      FROM     OccGroup
		  WHERE    Status = '1'
		  AND      OccupationalGroup IN (SELECT OccupationalGroup 
		                                 FROM   FunctionTitle 
					  				     WHERE  FunctionClass = '#url.functionclass#')		  
		  
		  <cfif url.occ neq "" and url.occ neq "roster" and SESSION.isAdministrator eq "no">
		  AND      OccupationalGroup = '#url.occ#'
		  </cfif>
		  ORDER BY Description 
	  </cfquery>
	  
	  <cfif URL.Mode eq "Lookup">	
	  
	  	  <cfset lk = "parent.ptoken.navigate('#session.root#/staffing/application/Function/Lookup/FunctionListing.cfm?functionclass=#url.functionclass#&ID0=OCC&edition=#url.edition#&owner=#url.owner#&mode=#url.mode#&ID1='+this.value+ '&FormName=#URL.formname#&fldfunctionno=#URL.fldfunctionno#&fldfunctiondescription=#URL.fldfunctiondescription#','rightme')">	
	 		  
	  <cfelse>
	  
		  <cfset lk = "parent.ptoken.navigate('#session.root#/staffing/application/Function/Lookup/FunctionListing.cfm?functionclass=#url.functionclass#&ID0=OCC&edition=#url.edition#&owner=#url.owner#&mode=#url.mode#&ID1='+this.value,'rightme')">	
	  
	  </cfif>	 
	  
	  <table style="height:100%;width:100%"><tr><td style="height:100%;width:100%">
	 		 			  			  
	  <select name="occgroup" multiple class="regularxl" style="width:100%;border:0px solid silver;height:100%" 
	  onClick="parent._cf_loadingtexthtml='';#lk#" onChange="parent._cf_loadingtexthtml='';#lk#">
	      <cfloop query="OccGroupList">
	      <option value="#occupationalgroup#">#Description#</option>
		  </cfloop>
	  </select>
	  
	  </td></tr></table> 
		 	 
</cfoutput>