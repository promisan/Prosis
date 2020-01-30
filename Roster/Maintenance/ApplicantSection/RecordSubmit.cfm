
<cfif url.id1 eq ""> 

	<cfquery name="Verify" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ApplicantSection
		WHERE 	Code  = '#Form.Code#' 
	</cfquery>

   <cfif Verify.recordCount is 1>
   		<cf_tl id="A record with this code has been registered already!" var="1">
		<cfoutput>
		   	<script>
				alert("#lt_text#");
	   		</script> 
		</cfoutput> 
	  
   <cfelse>
   
		<cfquery name="Insert" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_ApplicantSection
					(
						Code,
						<cfif trim(Form.TriggerGroup) neq "">TriggerGroup,</cfif>
						<cfif trim(Form.Description) neq "">Description,</cfif>
						<cfif trim(Form.DescriptionTooltip) neq "">DescriptionTooltip,</cfif>
						<cfif trim(Form.Instruction) neq "">Instruction,</cfif>
						<cfif trim(Form.InstructionImage) neq "">InstructionImage,</cfif>
						<cfif trim(Form.ShowCondition) neq "">ShowCondition,</cfif>
						<cfif trim(Form.TemplateTopicId) neq "">TemplateTopicId,</cfif>
						<cfif trim(Form.TemplateURL) neq "">TemplateURL,</cfif>
						<cfif trim(Form.TemplateCondition) neq "">TemplateCondition,</cfif>
						ProgressCheckBox,
						<cfif trim(Form.ProgressIconDone) neq "">ProgressIconDone,</cfif>
						<cfif trim(Form.ProgressIconPending) neq "">ProgressIconPending,</cfif>
						ListingOrder,
						ResetOnUpdate,
						<cfif trim(Form.ProgressIconPending) neq "">ResetOnUpdateParent,</cfif>
						Obligatory,
						Operational,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#Form.Code#',
						<cfif trim(Form.TriggerGroup) neq "">'#Form.TriggerGroup#',</cfif>
						<cfif trim(Form.Description) neq "">'#Form.Description#',</cfif>
						<cfif trim(Form.DescriptionTooltip) neq "">'#Form.DescriptionTooltip#',</cfif>
						<cfif trim(Form.Instruction) neq "">'#Form.Instruction#',</cfif>
						<cfif trim(Form.InstructionImage) neq "">'#Form.InstructionImage#',</cfif>
						<cfif trim(Form.ShowCondition) neq "">'#Form.ShowCondition#',</cfif>
						<cfif trim(Form.TemplateTopicId) neq "">'#Form.TemplateTopicId#',</cfif>
						<cfif trim(Form.TemplateURL) neq "">'#Form.TemplateURL#',</cfif>
						<cfif trim(Form.TemplateCondition) neq "">'#Form.TemplateCondition#',</cfif>
						'#Form.ProgressCheckBox#',
						<cfif trim(Form.ProgressIconDone) neq "">'#Form.ProgressIconDone#',</cfif>
						<cfif trim(Form.ProgressIconPending) neq "">'#Form.ProgressIconPending#',</cfif>
						'#Form.ListingOrder#',
						'#Form.ResetOnUpdate#',
						<cfif trim(Form.ProgressIconPending) neq "">'#Form.ResetOnUpdateParent#',</cfif>
						'#Form.Obligatory#',
						'#Form.Operational#',
						'#session.acc#',
						'#session.last#',
						'#session.first#'
					)
			
		</cfquery>
		
		<cfset url.currentCode = Form.Code>
		<cfinclude template="SectionOwnersSubmit.cfm">
		
		<script>
		     window.close();
			 opener.location.reload();
		</script>  	
		  
    </cfif>		  
           
<cfelse>

	<cfquery name="Update" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE 	Ref_ApplicantSection
		SET   	TriggerGroup = <cfif trim(Form.TriggerGroup) neq "">'#Form.TriggerGroup#'<cfelse>null</cfif>,
				Description = <cfif trim(Form.Description) neq "">'#Form.Description#'<cfelse>null</cfif>,
				DescriptionTooltip = <cfif trim(Form.DescriptionTooltip) neq "">'#Form.DescriptionTooltip#'<cfelse>null</cfif>,
				Instruction = <cfif trim(Form.Instruction) neq "">'#Form.Instruction#'<cfelse>null</cfif>,
				InstructionImage = <cfif trim(Form.InstructionImage) neq "">'#Form.InstructionImage#'<cfelse>null</cfif>,
				ShowCondition = <cfif trim(Form.ShowCondition) neq "">'#Form.ShowCondition#'<cfelse>null</cfif>,
				TemplateTopicId = <cfif trim(Form.TemplateTopicId) neq "">'#Form.TemplateTopicId#'<cfelse>null</cfif>,
				TemplateURL = <cfif trim(Form.TemplateURL) neq "">'#Form.TemplateURL#'<cfelse>null</cfif>,
				TemplateCondition = <cfif trim(Form.TemplateCondition) neq "">'#Form.TemplateCondition#'<cfelse>null</cfif>,
				ProgressCheckBox = '#Form.ProgressCheckBox#',
				ProgressIconDone = <cfif trim(Form.ProgressIconDone) neq "">'#Form.ProgressIconDone#'<cfelse>null</cfif>,
				ProgressIconPending = <cfif trim(Form.ProgressIconPending) neq "">'#Form.ProgressIconPending#'<cfelse>null</cfif>,
				ListingOrder = '#Form.ListingOrder#',
				ResetOnUpdate = '#Form.ResetOnUpdate#',
				ResetOnUpdateParent = <cfif trim(Form.ProgressIconPending) neq "">'#Form.ResetOnUpdateParent#'<cfelse>null</cfif>,
				Obligatory = '#Form.Obligatory#',
				Operational = '#Form.Operational#'
		WHERE  Code = '#Form.CodeOld#'
	</cfquery>
	
	<cfset url.currentCode = Form.CodeOld>
	<cfinclude template="SectionOwnersSubmit.cfm">
	
	<script>
	     window.close();
		 opener.location.reload();
	</script>  

</cfif>	
