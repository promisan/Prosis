
<cfif url.class eq "Asset">
	
	<cfquery name="TopicList" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     *
		FROM       Ref_Topic
		<cfif url.class eq "Asset">
		WHERE      TopicClass = 'Asset'
		<cfelse>
		WHERE      TopicClass = 'Detail'
		</cfif>
	</cfquery>
	
	<cfif topiclist.recordcount lt "5">
	 <cfset l = topiclist.recordcount>
	<cfelse>
	  <cfset l = 5> 
	</cfif>
	
	<table width="90%" cellspacing="0" cellpadding="0">
	
	<tr>
	    
		<cfset c = 0>
								
		<cfoutput query="TopicList">
		
			<cfset c=c+1>
			
			<cfif c eq "5">
				<tr>
				<cfset c = 1>
			</cfif>
			
			<td width="25%">
			
				<table cellspacing="0" cellpadding="0">
				<tr>
					<td>
				
						<cfquery name="Check" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT     *
							FROM       ItemTopic
							WHERE      ItemNo = '#url.id#'
							AND        Topic  = '#code#'
						</cfquery>
									
						<input type="checkbox" class="radiol" name="Topic" id="Topic" value="#code#" <cfif check.recordcount eq 1>checked</cfif>>
						
					</td>
					<td class="labelit" style="padding-left:3px">#Description#</td>
				</tr>
				</table>	
				
			</td>	
			
			<cfif c eq "4">
				</tr>			
			</cfif>		
		
		</cfoutput>		
	
	</tr>
	</table>	
	
	<script>
		document.getElementById('custombox').className = "regular"
	</script>

<cfelse>

	<script>
		document.getElementById('custombox').className = "hide"
	</script>

</cfif>

<cfif url.class eq "Supply">

	<script>
		document.getElementById('boxprecision').className    = "regular"
		document.getElementById('boxvaluation').className    = "regular"
		document.getElementById('boxbarcode').className      = "regular"
		document.getElementById('boxdepreciation').className = "hide"
	</script>

<cfelseif url.class eq "Asset">

	<script>
		document.getElementById('boxprecision').className = "hide"
		document.getElementById('boxvaluation').className = "hide"
		document.getElementById('boxbarcode').className = "hide"
		document.getElementById('boxdepreciation').className = "regular"
	</script>
	
<cfelse>	

	<script>
		document.getElementById('boxprecision').className = "hide"
		document.getElementById('boxvaluation').className = "hide"
		document.getElementById('boxbarcode').className = "hide"
		document.getElementById('boxdepreciation').className = "hide"
	</script>

</cfif>