
<cf_assignId>

<!--- 1. create event                      --->
<!--- 2. create workflow                   --->
<!--- 3. refresh box that contains the     --->
<!--- 4. open the dialog to submit stuff   --->

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
		           <cfif url.GroupCode neq "">
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
		           DateEvent,
		           DateEventDue,
				   ActionDateEffective,
				   ActionDateExpiration,
		           ActionStatus,		           
		           OfficerUserId,
		           OfficerLastName,
		           OfficerFirstName)
		VALUES  ('#rowguid#',
		         '#url.TriggerCode#',
		         '#url.EventCode#',
		         '#url.PersonNo#',
		         '#url.Mission#',
		         <cfif FORM.GroupCode neq "">
		         '#url.GroupCode#',
		         '#url.ReasonCode#',
		         </cfif>				
				 <cfif FORM.OrgUnit neq "">
				     '#FORM.OrgUnit#',
				 </cfif>	
				 <cfif FORM.PositionNo neq "">
			         '#FORM.PositionNo#',
				 </cfif>	 				
		         #dte#,
		         #dted#,
				 #eff#,
				 #exp#,
		         0,		        
		         '#SESSION.acc#',
		         '#SESSION.last#',
		         '#SESSION.first#')
</cfquery>