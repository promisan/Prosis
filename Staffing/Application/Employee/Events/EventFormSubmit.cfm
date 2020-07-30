<cfparam name="URL.EventId"             default="">
<cfparam name="URL.Box"                 default="">
<cfparam name="URL.Scope"               default="">
<cfparam name="FORM.OrgUnit"            default="">
<cfparam name="FORM.GroupCode"          default="">
<cfparam name="FORM.GroupConditionCode" default="">
<cfparam name="FORM.Remarks"            default="">
<cfparam name="FORM.DateEventDue"       default="#Form.ActionDateEffective#">

<cfset date        = Evaluate("FORM.DateEvent")>
<cfset dateDue     = Evaluate("FORM.DateEventDue")>

<cfset dateValue = "">
<CF_DateConvert Value="#date#">
<cfset dte = dateValue>

<cfset dateValue = "">
<CF_DateConvert Value="#dateDue#">
<cfset dted = dateValue>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.ActionDateEffective#">
<cfset eff = dateValue>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.ActionDateExpiration#">
<cfset exp = dateValue>

<cfset vDocumentNo =0>

<cfif URL.eventid eq "">

	<cfquery name="qInsert" 
			 datasource="AppsEmployee" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 
			INSERT INTO PersonEvent
			           (EventId,
					   EventTrigger,
			           EventCode,
			           PersonNo,
			           Mission,
			           <cfif FORM.GroupCode neq "">
			           		ReasonCode,
			           		ReasonListCode,
			           </cfif>	
					   <cfif FORM.GroupConditionCode neq "">
			           		ConditionCode,
			           		ConditionListCode,
			           </cfif>	
					   
					   <cfif FORM.OrgUnit neq "">
					   OrgUnit,
					   </cfif>
					   <cfif FORM.PositionNo neq "">
					   PositionNo,
					   </cfif>
					   <cfif FORM.RequisitionNo neq "">
					   RequisitionNo,
					   </cfif>
			           DocumentNo,					   
			           DateEvent,
			           DateEventDue,
					   ActionDateEffective,
					   ActionDateExpiration,
			           ActionStatus,
			           Remarks,
			           OfficerUserId,
			           OfficerLastName,
			           OfficerFirstName)
			VALUES  ('#Form.Eventid#',
			         '#FORM.TriggerCode#',
			         '#FORM.EventCode#',
			         '#FORM.PersonNo#',
			         '#FORM.Mission#',
			         <cfif FORM.GroupCode neq "">
			         '#FORM.GroupCode#',
			         '#FORM.ReasonCode#',
			         </cfif>	
					 <cfif FORM.GroupConditionCode neq "">
					 '#FORM.GroupConditionCode#',
			         '#FORM.ConditionCode#',
					 </cfif>
					 <cfif FORM.OrgUnit neq "">
					     '#FORM.OrgUnit#',
					 </cfif>	
					 <cfif FORM.PositionNo neq "">
				         '#FORM.PositionNo#',
					 </cfif>	 
					 <cfif FORM.RequisitionNo neq "">
				         '#FORM.RequisitionNo#',
					 </cfif>	 
			         '#Form.DocumentNo#',					 
			         #dte#,
			         #dted#,
					 #eff#,
					 #exp#,
			         0,
			         '#FORM.Remarks#',
			         '#SESSION.acc#',
			         '#SESSION.last#',
			         '#SESSION.first#')
	</cfquery>
	
	<cfquery name="Event" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT PE.*, P.FullName, RPE.EntityClass
		FROM   PersonEvent PE
			   INNER JOIN Person P ON PE.PersonNo = P.PersonNo
			   LEFT OUTER JOIN Ref_PersonEvent RPE ON RPE.Code = PE.EventCode
		WHERE  PE.EventId = '#Form.Eventid#'
	</cfquery>
	
	<cfif Event.EntityClass neq "">
		<cfset entityclass = Event.EntityClass>		
	<cfelse>
		<cfset entityclass = "Standard">
	</cfif>
	
	<cfset link = "Staffing/Application/Employee/Events/EventDialog.cfm?id=#Form.Eventid#">
	
	<cf_ActionListing 
		    EntityCode       = "PersonEvent"
			EntityClass      = "#entityclass#"
			EntityStatus     = ""
			Mission          = "#Event.Mission#"
			OrgUnit          = "#Event.OrgUnit#" 
			PersonNo         = "#Event.PersonNo#" 
			ObjectReference  = "#Event.FullName#"
			ObjectReference2 = "#Event.Remarks#"			   
			ObjectKey4       = "#Form.eventid#"					
			Show             = "No"
			HideCurrent      = "No"			
			ObjectURL        = "#link#">
	
<cfelse>

	<cfquery name="qUpdate" 
			 datasource="AppsEmployee" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				UPDATE PersonEvent
				SET EventTrigger        = '#FORM.TriggerCode#',
					EventCode           = '#FORM.EventCode#',
					Mission             = '#FORM.Mission#',
					DocumentNo          = '#Form.DocumentNo#',					
		            <cfif FORM.PositionNo neq "">
					PositionNo          = '#FORM.PositionNo#',
					</cfif>
					<cfif FORM.OrgUnit neq "">
				    OrgUnit             = '#FORM.OrgUnit#',
					</cfif>
					<cfif FORM.RequisitionNo neq "">
				    RequisitionNo       = '#FORM.RequisitionNo#',
					</cfif>	 
		            <cfif FORM.GroupCode neq "">
		           		ReasonCode      = '#FORM.GroupCode#',
		           		ReasonListCode  = '#FORM.ReasonCode#',
		            </cfif>
					<cfif FORM.ConditionGroupCode neq "">
		           		ConditionCode      = '#FORM.GroupConditionCode#',
		           		ConditionListCode  = '#FORM.ConditionCode#',
		            </cfif>
		            DateEvent            = #dte#,
		            DateEventDue         = #dted#,
				    ActionDateEffective  = #eff#,
				    ActionDateExpiration = #exp#,
		            Remarks              = '#FORM.Remarks#' 
		      WHERE EventId = '#URL.eventId#'
	</cfquery>	

</cfif>

<!---
<cfoutput>
<script>
  alert('#url.scope#')
</script>
</cfoutput>
--->

<cfif url.box neq "">

	<cfoutput>
		<script>			
			try { ProsisUI.closeWindow('evdialog',true) } catch(e) {}
			// ptoken.open('#SESSION.root#/staffing/Application/Employee/Events/EventDialog.cfm?id=#form.EventId#','#form.eventid#')
			workflowreload('#url.box#');	
		</script>
	</cfoutput>
	
<cfelseif url.scope eq "portal">	

	<cfoutput>
		<script>
			ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/Selfservice.cfm?id=#FORM.PersonNo#','eventdetail');
			try { ProsisUI.closeWindow('evdialog',true) } catch(e) {}
		</script>
	</cfoutput>

<cfelseif url.scope neq "matrix">
	
	<cfoutput>
		<script>
			ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/EventsListing.cfm?id=#FORM.PersonNo#','eventdetail');
			try { ProsisUI.closeWindow('evdialog',true) } catch(e) {}
		</script>
	</cfoutput>

<cfelse>

	<cfoutput>
		<script>
			ptoken.open('#SESSION.root#/Staffing/Application/Employee/PersonView.cfm?id=#FORM.PersonNo#&template=personevent','#form.personno#');
			try { ProsisUI.closeWindow('evdialog',true) } catch(e) {}
		</script>
	</cfoutput>

</cfif>