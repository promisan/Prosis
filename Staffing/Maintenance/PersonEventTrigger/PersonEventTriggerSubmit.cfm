
<cfif url.code eq "">

	<cfquery name="validate"
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT 	*
			FROM 	Ref_PersonEventTrigger
			WHERE	EventTrigger = '#url.trigger#'
			AND		EventCode = '#form.code#'
	</cfquery>
	
	<cfif validate.recordCount gt 0>
	
		<script>
			alert('Event code is in use.');
		</script>
	
	<cfelse>
	
		<cfquery name="insert"
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO Ref_PersonEventTrigger
			         (EventTrigger,
					 EventCode,
					 ActionImpact,
					 <cfif trim(Form.ReasonCode) neq "">ReasonCode,</cfif>
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			  VALUES ('#url.trigger#',
			          '#Form.Code#', 
					  '#Form.ActionImpact#', 
					  <cfif trim(Form.ReasonCode) neq "">'#Form.ReasonCode#',</cfif> 
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
		</cfquery>
		
		<cfoutput>
			<script>
				ColdFusion.navigate('PersonEventListing.cfm?id1=#URL.trigger#','divPersonEvent');
				ColdFusion.Window.hide('mydialog');
			</script>
		</cfoutput>
		
	</cfif>
	
<cfelse>

	<cfquery name="update"
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE	Ref_PersonEventTrigger
			SET		ActionImpact = '#Form.ActionImpact#',
					ReasonCode = <cfif trim(Form.ReasonCode) neq "">'#Form.ReasonCode#'<cfelse>null</cfif>
			WHERE	EventTrigger = '#url.trigger#'
			AND		EventCode = '#url.code#'
	</cfquery>
	
	<cfoutput>
		<script>
			ColdFusion.navigate('PersonEventListing.cfm?id1=#URL.trigger#','divPersonEvent');
			ColdFusion.Window.hide('mydialog');
		</script>
	</cfoutput>

</cfif>