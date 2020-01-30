<cfparam name="url.idmenu" default="">

<cfset vTitle = "Edit">
<cfif url.code eq "">
	<cfset vTitle = "Associate">
</cfif>

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="#vTitle# Person Event Trigger" 
			  menuAccess="Yes" 
			  banner="gray"
			  jQuery="yes"
			  line="No"
			  user="no"
			  systemfunctionid="#url.idmenu#">

<cfquery name="get"
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	T.*,
				(
					SELECT 	Description
					FROM 	Ref_PersonEvent
					WHERE	Code = T.EventCode
				) as EventDescription
		FROM 	Ref_PersonEventTrigger T
		WHERE	T.EventTrigger = '#url.trigger#'
		AND		T.EventCode = '#url.code#'
</cfquery>


<cfform action="PersonEventTriggerSubmit.cfm?trigger=#URL.trigger#&code=#url.code#" method="POST"  name="dialogEvent">

<table width="92%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

    <tr><td></td></tr>
    <cfoutput>
    <TR class="labelmedium">
    <TD width="120">Code:</TD>
    <TD>
	   <cfif url.code neq "">
	   
	   	  #get.EventDescription#	
	      <input type="hidden" name="Code" value="#get.EventCode#" size="10" maxlength="10">
		  
	   <cfelse>
	   
	      <cfquery name="getEvent"
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT 	PE.*,
						(PE.Code + ' - ' + PE.Description) as Display
				FROM 	Ref_PersonEvent PE
				WHERE	PE.Code NOT IN
						(
							SELECT 	EventCode
							FROM 	Ref_PersonEventTrigger
							WHERE	EventTrigger = '#url.trigger#'
						)
				ORDER BY PE.ListingOrder ASC
			</cfquery>
			
			<cfselect name="Code" id="Code" query="getEvent" display="Display" value="Code" class="regularxl" message="Please, select a valid event code" required="Yes"></cfselect>
			
	   </cfif>
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Action Impact:</TD>
    <TD>
  	   <cfinput type="Text" name="ActionImpact" value="#get.ActionImpact#" message="Please enter a action impact" required="Yes" size="20" maxlength="20" class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Reason Code:</TD>
    <TD>
  	   <cfquery name="getReason"
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT 	*,
						(Code + ' - ' + Description) as Display
				FROM 	Ref_PersonGroup
				WHERE	Context     = 'Event'
				AND		Operational = '1'
			</cfquery>
			
			<cfselect name="ReasonCode" id="ReasonCode" query="getReason" display="Display" value="Code" class="regularxl" message="Please, select a valid reason code" required="No" selected="#get.ReasonCode#" queryposition=
			"below">
				<option value = "">None</option> 
			</cfselect>
    </TD>
	</TR>
	
	</cfoutput>
	
	<tr class="line"><td colspan="2"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2">
    <input class="button10g" type="submit" name="Update" value="Save">
	</td>	
	
	</tr>

</TABLE>

</CFFORM>