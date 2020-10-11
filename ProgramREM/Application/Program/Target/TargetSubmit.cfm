<cfset dateValue = "">
<CF_DateConvert Value="#form.TargetDueDate#">
<cfset vDueDate = dateValue>

<cfparam name="form.targetclass" default="">
<cfparam name="form.category"    default="">

<cfif trim(url.targetid) eq "">

	<cf_assignid>
	
	<cfquery name="insert" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	   	
		INSERT INTO ProgramTarget (
				ProgramCode,
				Period,
				TargetId,
				ProgramCategory,
				Listingorder,
				TargetReference,
				TargetDescription,
				TargetClass,
				TargetDueDate,
				TargetIndicator,
				Outcome,
				OutcomeVerification,
				ExternalFactor,
				ActionStatus,
				RecordStatus,
				OfficerUserId,
				OfficerLastName,
				OfficerFirstName )
		VALUES	(
				'#url.programCode#',
				'#url.period#',
				'#RowGuid#',
				<cfif url.category neq "">
					'#url.category#',
				<cfelse>
					NULL,
				</cfif>
				'#Form.ListingOrder#',
				'#trim(Form.TargetReference)#',
				'#left(trim(Form.TargetDescription),2000)#',
				'#trim(Form.TargetClass)#',
				<cfif trim(form.TargetDueDate) eq "">null<cfelse>#vDueDate#</cfif>,
				'#left(trim(Form.TargetIndicator),2000)#',
				'#left(trim(Form.Outcome),2000)#',
				'#trim(Form.OutcomeVerification)#',
				'#trim(Form.ExternalFactor)#',
				'0',
				'1',
				'#session.acc#',
				'#session.last#',
				'#session.first#' )
			
	</cfquery>
	
<cfelse>

	<cfquery name="update" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		
			UPDATE 	ProgramTarget
			SET		ListingOrder          = '#Form.ListingOrder#',
					TargetReference       = '#trim(Form.TargetReference)#',
			        TargetDescription     = '#left(trim(Form.TargetDescription),2000)#',
					TargetClass           = '#trim(Form.TargetClass)#',
					TargetDueDate         = <cfif trim(form.TargetDueDate) eq "">null<cfelse>#vDueDate#</cfif>,
					TargetIndicator       = '#left(trim(Form.TargetIndicator),2000)#',
					Outcome               = '#left(trim(Form.Outcome),2000)#',
					OutcomeVerification   = '#trim(Form.OutcomeVerification)#',
					ExternalFactor        = '#trim(Form.ExternalFactor)#'
			WHERE	ProgramCode = '#url.programcode#'
			AND		Period      = '#url.period#'
			AND		Targetid    = '#url.targetid#'
		
	</cfquery>

</cfif>

<cfoutput>
	<script>
	  	parent.targetrefresh('#url.programcode#','#url.period#','#url.targetid#','#url.category#','#url.programaccess#');
	   	parent.ProsisUI.closeWindow('target')
	</script>
</cfoutput>
