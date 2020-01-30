
<cfparam name="form.fromprogramcode"  default="">
<cfparam name="form.requirementid"    default="">
<cfparam name="form.orgunit"          default="">
<cfparam name="form.programcode"      default="">
<cfparam name="form.fund"             default="">

<cfif form.requirementid eq "" or form.ProgramCode eq "">

	<cfoutput>

	<script>		
		alert("No requirements were selected to be moved")</script>
	<cfabort>
	
	</cfoutput>

</cfif>

<cfset obj = "">
<cfset ids = "">

 <cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM       Program
	WHERE      ProgramCode = '#Form.programCode#'			
</cfquery>

 <cfquery name="Param" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM       Ref_ParameterMission
	WHERE      Mission = '#Program.Mission#'			
</cfquery>

<cftransaction>
	
	<cfloop index="id" list="#form.requirementid#">
				
		<cfquery name="get" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  * 
				FROM    ProgramAllotmentRequest
				WHERE   RequirementId = '#id#'	   
		</cfquery>		
		
				<!--- check also the status --->
		
		<cfif get.Recordcount eq "1">
		
		    <cfif ids eq "">
			    <cfset ids = "'#id#'">
			<cfelse>
				<cfset ids = "#ids#,'#id#'">
			</cfif>	
		
			<cfif obj eq "">
			  <cfset obj = get.ObjectCode>
			<cfelse>
			  <cfset obj = "#obj#,#get.ObjectCode#">  
			</cfif>
			
			 <cfquery name="Check" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT     *
					FROM       ProgramAllotment
					WHERE      ProgramCode = '#Form.programCode#'	
					AND        Period      = '#get.period#'   
					AND        EditionId   = '#get.EditionId#'	
			  </cfquery>
			  
			  <cfif Check.recordcount eq "0">
			  
				  <cfquery name="Insert" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO ProgramAllotment
							( ProgramCode, 
							  Period, 
							  EditionId,
							  SupportPercentage,
							  SupportObjectCode,
							  OfficerUserId, 
							  OfficerLastName, 
							  OfficerFirstName)
							  
					VALUES ( '#Form.ProgramCode#', 
					         '#get.Period#', 
							 '#get.EditionId#', 
							 '#param.SupportPercentage#',
							 <cfif param.SupportObjectCode neq "">
							 '#param.SupportObjectCode#',
							 <cfelse>
							 NULL,
							 </cfif>
							 '#SESSION.acc#', 
							 '#SESSION.last#', 
							 '#SESSION.first#' )
				  </cfquery>
			
			  </cfif>
			
			<!--- change Program and/or Fund to be moved --->
					
			<cfquery name="Update" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE   ProgramAllotmentRequest
				SET      ProgramCode = '#Form.ProgramCode#'
				<cfif Form.Fund neq "">
				, Fund = '#Form.Fund#' 
				</cfif>		
				WHERE    RequirementId = '#id#'	   
			</cfquery>
			
			<!--- check init --->
			
			<cfquery name="Check" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   ProgramAllotmentRequestMove			
				WHERE  RequirementId = '#id#'	   
			</cfquery>
			
			<cfif check.recordcount eq "0">
			
				<!--- initial record --->
			
				<cfquery name="Update" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO ProgramAllotmentRequestMove
					     (RequirementId,
						  Action,
						  ProgramCode,
						  Period,
						  Fund,
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName,
						  Created)
					VALUES 
						('#id#',
						 'Initial',
						 '#get.ProgramCode#',
						 '#get.Period#',
						 '#get.Fund#',
						 '#get.officerUserId#',
						 '#get.officerLastName#',
						 '#get.officerFirstName#',
						 '#get.created#') 			
				</cfquery>		
			
			</cfif>
					
			<cfquery name="LogMove" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO ProgramAllotmentRequestMove
					(RequirementId,
					 Action,
					 ProgramCode,
					 Period,
					 Fund,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
				VALUES 
					('#id#',
					 'Move',
					 '#Form.ProgramCode#',
					 '#get.Period#',
					 '<cfif Form.Fund neq "">#Form.Fund#</cfif>',
					 '#SESSION.acc#',
					 '#SESSION.last#',
					 '#SESSION.first#') 			
			</cfquery>		
			
			<cfif get.PositionNo neq "">
		
				<cfquery name="movePosition" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE  Ref_AllotmentEditionPosition
						SET     OrgUnitOperational = '#form.OrgUnit#'
						WHERE   EditionId          = '#get.EditionId#'
						AND		PositionNo         = '#get.PositionNo#'				  
				</cfquery>
		
			</cfif>
				
		</cfif>
			
	</cfloop>
	
</cftransaction>
		  
<!--- recalculate the FROM --->			

<cfinvoke component = "Service.Process.Program.Program"  
	   method           = "SyncProgramBudget" 
	   ProgramCode      = "#get.ProgramCode#" 
	   Period           = "#get.Period#"
	   EditionId        = "#get.EditionId#">	  
	   
<!--- recalculate the TO --->
	
<cfinvoke component = "Service.Process.Program.Program"  
	   method           = "SyncProgramBudget" 
	   ProgramCode      = "#Form.ProgramCode#" 
	   Period           = "#get.Period#"
	   EditionId        = "#get.EditionId#">		   
		  
<!--- 
refresh the caller 
refresh the summary and hide the move transactons
--->	

<cfoutput>			  
	<script language="JavaScript">	     
		 Prosis.busy('no')	
		 ptoken.navigate('../Request/RequestSummary.cfm?history=no&summarymode=program&programcode=#form.programcodefrom#&period=#get.period#&editionid=#get.editionid#','programfrom')		 
		 ptoken.navigate('../Request/RequestSummary.cfm?history=no&summarymode=program&programcode=#form.programcode#&period=#get.period#&editionid=#get.editionid#','programtarget')		 
		 opener.ColdFusion.navigate('AllotmentInquiryAmount.cfm?programcode=#form.programcodefrom#&period=#get.period#&editionid=#get.editionid#&objectcode=#obj#','moveresult') 			 				
	</script>	
</cfoutput>		  

<cfquery name="Req" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     *
		FROM       ProgramAllotmentRequest
		WHERE      RequirementId IN (#preservesingleQuotes(ids)#)	   
		AND        ProgramCode = '#get.ProgramCode#'
</cfquery>	  

<cfif req.recordcount eq "0">
	<script> window.close()</script>
</cfif>

<!--- sync the programs old and new --->

 