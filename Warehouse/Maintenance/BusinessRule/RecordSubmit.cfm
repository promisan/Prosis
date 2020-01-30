<cfoutput>

<cf_tl id = "A rule with this code has been registered already!" var = "vAlready"> 

<cfif url.id1 eq ""> 

	<cfquery name="Verify" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_BusinessRule
			WHERE 	Code  = '#Form.Code#' 
	</cfquery>
	
	   <cfif Verify.recordCount gt 0>
	   
		   <script language="JavaScript">
		   
		    	alert("#vAlready#");
				history.go(-1);
		     
		   </script>  
	  
	   <cfelse>
	   
			<cfquery name="Insert" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO Ref_BusinessRule
						(
							Code,
							TriggerGroup,
							RuleClass,
							Description,
							<cfif trim(Form.MessagePerson) neq "">MessagePerson,</cfif>
							ValidationPath,
							ValidationTemplate,
							Color,
							Operational,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						)
					VALUES
						(
							'#Form.Code#',
							'#Form.TriggerGroup#',
							'#Form.RuleClass#',
							'#Form.Description#',
							<cfif trim(Form.MessagePerson) neq "">'#Form.MessagePerson#',</cfif>
							'#Form.ValidationPath#',
							'#Form.ValidationTemplate#',
							'#Form.Color#',
							#Form.Operational#,
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#'
						)
			</cfquery>
			
			<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
		     action="Insert"
			 content="#form#">				
			
			<cfset url.code = form.code>
			<cfinclude template="RecordSubmitMission.cfm">
			
			<script language="JavaScript">
   
			     window.close()
				 opener.location.reload()
        
			</script> 
			  
	    </cfif>		  
           
<cfelse>


	<cfquery name="Update" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_BusinessRule
		SET 
	    	TriggerGroup    	= '#Form.TriggerGroup#',
			RuleClass			= '#Form.RuleClass#',
			Description			= '#Form.Description#',
			MessagePerson		= <cfif trim(Form.MessagePerson) eq "">null<cfelse>'#Form.MessagePerson#'</cfif>,
			ValidationPath 		= '#Form.ValidationPath#',
			ValidationTemplate	= '#Form.ValidationTemplate#',
			Color				= '#Form.Color#',
			Operational			= #Form.Operational#
		WHERE Code         		= '#Form.CodeOld#'
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
     action="Update"
	 content="#form#">				
	
	
	<cfset url.code = form.codeOld>
	<cfinclude template="RecordSubmitMission.cfm">
	
	<script language="JavaScript">
   
	     window.close()
		 opener.location.reload()
        
	</script>

</cfif>

</cfoutput>



