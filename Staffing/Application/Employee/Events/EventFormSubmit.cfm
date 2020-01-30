<cfparam name="URL.EventId"  default="">
<cfparam name="URL.scope"    default="">
<cfparam name="FORM.OrgUnit" default="">

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
					   ContractNo,
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
					 '#FORM.ContractNo#',
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
					ContractNo          = '#Form.ContractNo#',
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
		            DateEvent            = #dte#,
		            DateEventDue         = #dted#,
				    ActionDateEffective  = #eff#,
				    ActionDateExpiration = #exp#,
		            Remarks              = '#FORM.Remarks#' 
		      WHERE EventId = '#URL.eventId#'
	</cfquery>	

</cfif>

<cfif url.scope neq "matrix">
	
	<cfoutput>
		<script>
			ColdFusion.navigate('#SESSION.root#/Staffing/Application/Employee/Events/EventsListing.cfm?id=#FORM.PersonNo#','eventdetail');
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