<cf_tl id = "This category has been registered already!" var = "vAlready"> 

<cfif url.category eq ""> 

	<cfquery name="Verify" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_AssetEventCategory
			WHERE 	EventCode  = '#url.id1#' 
			AND		Category = '#form.category#'
	</cfquery>
	
	   <cfif Verify.recordCount gt 0>
	   
		   	<cfoutput>
			   <script>
			    	alert("#vAlready#");
			   </script>  
		   </cfoutput>
	  
	   <cfelse>
	   
			<cfquery name="Insert" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO Ref_AssetEventCategory
						(
							EventCode,
							Category,
							ModeIssuance,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						)
					VALUES
						(
							'#url.id1#',
							'#Form.Category#',
							#Form.ModeIssuance#,
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#'
						)
			</cfquery>
			
			<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
		     action="Insert"
			 content="#form#">
			
			<cfoutput>
				<script>
				    ColdFusion.Window.hide('mydialog');
					ColdFusion.navigate('RecordEditDetail.cfm?idmenu=#url.idmenu#&id1=#url.id1#','divDetail');
				</script> 
			</cfoutput>
			  
	    </cfif>		  
           
<cfelse>

	<cfquery name="Update" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_AssetEventCategory
		SET 
			ModeIssuance		= #Form.ModeIssuance#
		WHERE EventCode   		= '#url.id1#'
		AND   Category			= '#form.category#'
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
     action="Update"
	 content="#form#">
	
	<cfoutput>
		<script>
			ColdFusion.Window.hide('mydialog');
			ColdFusion.navigate('RecordEditDetail.cfm?idmenu=#url.idmenu#&id1=#url.id1#','divDetail');
		</script>
	</cfoutput>

</cfif>