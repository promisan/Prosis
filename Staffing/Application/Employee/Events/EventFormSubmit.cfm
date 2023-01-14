<cfparam name="URL.EventId"             default="">
<cfparam name="URL.Portal"              default="0">
<cfparam name="URL.Box"                 default="">
<cfparam name="URL.Scope"               default="">
<cfparam name="FORM.OrgUnit"            default="">
<cfparam name="FORM.GroupCode"          default="">
<cfparam name="FORM.GroupConditionCode" default="">
<cfparam name="FORM.Remarks"            default="">
<cfparam name="FORM.DateEventDue"       default="#dateformat(now()+7,client.dateformatshow)#">
<cfparam name="FORM.EventPriority"      default="">
<cfparam name="FORM.EventPriorityMemo"  default="">

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

<!--- Position will rule the orgunit --->

<cfif FORM.PositionNo neq "">
	
	<cfquery name="Position" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Position
			WHERE  PositionNo = '#form.PositionNo#'
	</cfquery>	
	
	<cfset org = Position.OrgUnitOperational>
	
<cfelse>

    <cfset org = FORM.OrgUnit>

</cfif>			 
	
<cfif URL.eventid eq "">

	<!---- before we have used : form.eventId --->
	
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
					    <cfif org neq "">
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
						Source,
						EventPriority,
						EventPriorityMemo,						
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
					 <cfif Org neq "">
					     '#org#',
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
					 <cfif url.portal eq "1" or url.scope eq "Inquiry">
					 'Portal',
					 <cfelse>
					 'Manual',
					 </cfif>
					 '#Form.EventPriority#',
					 '#Form.EventPriorityMemo#',
			         '#SESSION.acc#',
			         '#SESSION.last#',
			         '#SESSION.first#')
	</cfquery>
	
	<cfquery name="Event" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT PE.*, P.FullName, RPE.EntityClass, RPE.Description
		FROM   PersonEvent PE
			   INNER JOIN Person P ON PE.PersonNo = P.PersonNo
			   LEFT OUTER JOIN Ref_PersonEvent RPE ON RPE.Code = PE.EventCode
		WHERE  PE.EventId = '#Form.EventId#'
	</cfquery>
	
	<cfif Event.EntityClass neq "">
		<cfset entityclass = Event.EntityClass>		
	<cfelse>
		<cfset entityclass = "Standard">
	</cfif>
	
	<cfset link = "Staffing/Application/Employee/Events/EventDialog.cfm?id=#Form.EventId#">
	
	<!--- scope inquiry is just to ask a questiomn from the portal --->
	<cfif url.scope eq "Inquiry">
		<cfset autocomplete = "Yes">
	<cfelse>
		<cfset autocomplete = "No">	
	</cfif>	
	
	<cf_ActionListing 
		    EntityCode       = "PersonEvent"
			EntityClass      = "#entityclass#"
			EntityStatus     = ""
			Mission          = "#Event.Mission#"
			OrgUnit          = "#Event.OrgUnit#" 
			PersonNo         = "#Event.PersonNo#" 
			ObjectDue        = "#Event.DateEventDue#"
			ObjectReference  = "#Event.FullName#"
			ObjectReference2 = "#Event.Description#"			   
			ObjectKey4       = "#Form.EventId#"	
			CompleteFirst    = "#autocomplete#"				
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
					EventPriority        = '#Form.EventPriority#',
					EventPriorityMemo    = '#Form.EventPriorityMemo#',		
		            Remarks              = '#FORM.Remarks#' 
		      WHERE EventId = '#URL.eventId#'
	</cfquery>	

</cfif>

<cfif url.box neq ""> <!--- this mode is to show the portal only the workflow object --->

	<cfoutput>
		<script>	
		    	   
			try { ProsisUI.closeWindow('evdialog',true) } catch(e) {}
			// ptoken.open('#SESSION.root#/staffing/Application/Employee/Events/EventDialog.cfm?id=#form.EventId#','#form.eventid#')
			workflowreload('#url.box#');	
			
		</script>
	</cfoutput>
	
<cfelseif url.scope eq "inquiry" or url.scope eq "personal">	<!--- this mode is to show the general inquiry in the portal --->

	<cfoutput>
		<script>	
			  
			ptoken.navigate('#SESSION.root#/Staffing/Portal/Events/EventBaseDialog.cfm?portal=1&scope=#url.scope#&id=#FORM.PersonNo#&mission=#form.mission#&trigger=#form.triggercode#&event=inquiry','divEventDetail');
			try { ProsisUI.closeWindow('evdialog',true) } catch(e) {}
		</script>
	</cfoutput>

<cfelseif url.scope neq "matrix"> <!--- this is to show the update in the listing only --->
	
	<cfoutput>
		<script>			  		 
			ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/EventsListing.cfm?id=#FORM.PersonNo#','eventdetail');
			try { ProsisUI.closeWindow('evdialog',true) } catch(e) {}
		</script>
	</cfoutput>

<cfelse>   <!--- this is to update a basic entry in the back office as manual and to refresh the full screen --->

	<cfoutput>
		<script>
			ptoken.open('#SESSION.root#/Staffing/Application/Employee/PersonView.cfm?id=#FORM.PersonNo#&template=personevent','#form.personno#');
			try { ProsisUI.closeWindow('evdialog',true) } catch(e) {}
		</script>
	</cfoutput>

</cfif>