<!---
	Travel/Application/DocumentEditSubmit.cfm
	
	Processing page for Personnel Request Edit page
	
	Called by:	Travel/Application/DocumentEdit.cfm

	Modification History:
	10May04 - added SatDate, TravelArrangement, and TaNumber fields
	16Jun04 - added code to save updates to PersonCategory field
			- also to first check if the SAT Date field exists in the calling form and control SAT Date field processing as appropriate
--->

<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>">

<cfparam name="Form.ActionId" default="">
<cfparam name="Form.ActionStatus" default="">
<cfparam name="Form.ActionDatePlanningId" default="">
<cfparam name="Form.ActionMemoId" default="">
<cfparam name="Form.TANumber" default=""> <!--- Added by Armin June 2013 ---->
<cfparam name="Form.PayResponsibility" default=""> <!--- Added by Armin June 2013 ---->
<cfparam name="Form.TuStaff" default=""> 		<!--- Added by Armin June 2013 ---->
<cfparam name="Form.TicketingThru" default=""> 		<!--- Added by Armin June 2013 ---->
<cfparam name="Form.RemarksTvl" default=""> 		<!--- Added by Armin June 2013 ---->


<!--- If submit is from DocumentRotatingPersonList.cfm --->
<cfif ParameterExists(Form.delete)>

	<cfquery name="Delete" datasource="#CLIENT.Datasource#" 
	 username="#SESSION.login#" password="#SESSION.dbpw#">
   	 	DELETE DocumentRotatingPerson 
		WHERE DocumentNo = '#Form.DocumentNo#' 
	    AND PersonNo IN (#PreserveSingleQuotes(Form.DeleteRotate)#)
	 </cfquery>
	 
     <script>
        opener.location.reload()
     </script>
 
     <cflocation url="DocumentEdit.cfm?ID=#Form.DocumentNo#" addtoken="No">	 

<cfelse>
<!----------------------- Else ------------------------->

	<!--- CASE I - User is allowed to edit the upper part of the Request Edit page ---->
	<cfif #FORM.AllowDocEditFlag#>
		<!--- If Document Header info can be edited...  
		<CF_RegisterAction 
		SystemFunctionId="1240" 
		ActionClass="Document" 
		ActionType="Update" 
		ActionReference="#FORM.DocumentNo#" 
		ActionScript="">
--->

		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.RequestDate#">
		<cfset ReqDate = #dateValue#>

		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.PlannedDeployment#">
		<cfset PlanDeploy = #dateValue#>

		<!--- added 10May04 --->
		<cfif ParameterExists(Form.SatDate)>
			<cfset SatDt = "">
			<cfif #Form.SatDate# NEQ "">
				<cfset dateValue = "">
				<CF_DateConvert Value="#Form.SatDate#">
				<cfset SatDt = #dateValue#>		
			</cfif>
		</cfif>
	
		<cfquery name="UpdateDocumentHeader" datasource="#CLIENT.Datasource#" 
		username="#SESSION.login#" password="#SESSION.dbpw#">
		UPDATE Document
		SET 
		Status            = '#Form.Status#',
		PermanentMissionId = #Form.PermanentMissionId#,
		Mission			  = '#Form.Mission#',
		PersonCategory	  = '#Form.Category#',
		RequestDate       = #ReqDate#,
		PersonCount		  = #Form.PersonCount#,
		LevelRequired     = Left('#Form.LevelRequired#',200),
		Qualification     = Left('#Form.Qualification#',200),
		DutyLength		  = #Form.DutyLength#,
		PlannedDeployment = #PlanDeploy#,
		<cfif ParameterExists(Form.SatDate)>		
			SatDate = <cfif #SatDt# NEQ "">#SatDt#,<cfelse>NULL,</cfif>			<!--- added 10May04 --->
		</cfif>
		TravelArrangement = '#Form.TvlArrBy#',								<!--- added 10May04 --->
		ReferenceNo       = '#Form.ReferenceNo#',
		RequestType		  = #Form.RequestType#,	
		Remarks			  = Left('#Form.Remarks#',200),
		UsualOrigin		  = #Form.UsualOrigin#,
		Attention		  = #Form.Attention#
		
		<!--- TaNumber		  	  = Left('#Form.TaNumber#',30),				1Nov04 --->		<!--- added 10May04 --->
		<!--- PayResponsibility   = '#Form.PayResponsibility#',				1Nov04  --->
		<!--- TuStaff			  = '#Form.TuStaff#',						1Nov04  --->
		<!--- TicketingThru 	  = '#Form.TicketingThru#',					1Nov04 --->
		<!--- RemarksTvl		  = Left('#Form.RemarksTvl#',200)			1Nov04  --->
		
		WHERE DocumentNo  = '#Form.DocumentNo#'
		</cfquery>
	<cfelse>
		<!--- If Document Header info CANNOT be edited.  Update fields that are always open for edit --->	
		
		<!--- CASE II - User is allowed to edit the lower (TRAVEL) part of the Request Edit page ---->
		<cfquery name="UpdateDocumentHeader" datasource="#CLIENT.Datasource#" 
 		username="#SESSION.login#" password="#SESSION.dbpw#">
		UPDATE Document
		SET 
		Status 			  = '#Form.Status#',
		TaNumber		  = '#Form.TaNumber#',								<!--- added 10May04 --->		
		PayResponsibility = '#Form.PayResponsibility#', 
		TuStaff			  = '#Form.TuStaff#',
		TicketingThru	  = '#Form.TicketingThru#',
		RemarksTvl		  = '#Form.RemarksTvl#'
		<!--- Attention		  = #Form.Attention#,							1Nov04 --->
		
		WHERE DocumentNo  = '#Form.DocumentNo#'	
		</cfquery>		
	</cfif>
		   
	<cfinclude template="Template/DocumentEditSubmit_Lines.cfm">

</cfif>