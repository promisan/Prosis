<cfparam name="url.idmenu" default="">

<cfquery name="Get" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	Ref_Action
		WHERE   Code = '#URL.ID#'		
</cfquery>	 	


<cf_screentop height="100%" 
			  label="Domain" 
			  option="Action Maintenance" 
			  scroll="Yes"
			  layout="webapp" 
			  banner="blue" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
			  
			  
<cf_calendarscript>			  

<!--- Entry form --->

<cfform action="RecordSubmit.cfm?id=#url.id#&alias=AppsWorkOrder" method="POST" enablecab="Yes" name="dialog">

<cfoutput>

<table width="92%" cellspacing="4" cellpadding="4" align="center">
	
	<tr><td height="6"></td></tr>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Entity">:</TD>
    <TD>
	
	 	<cfquery name="getLookup" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_ParameterMission
			WHERE    Mission IN (SELECT Mission FROM Organization.dbo.Ref_MissionModule WHERE SystemModule = 'WorkOrder')
			</cfquery>
			
		<select name="mission" id="mission" class="regularxl">
			<cfloop query="getLookup">
			  <option value="#getLookup.mission#" <cfif get.mission eq getLookup.mission>selected</cfif>>#getLookup.mission#</option>
		  	</cfloop>
		</select>	
					 
	
    </TD>
	</TR>
	
    <TR>
    <TD width="25%" class="labelmedium"><cf_tl id="Code">:</TD>
    <TD>
  	   <cfinput type="Text" name="Code" value="#get.Code#" message="Please enter a code" required="Yes" size="20" maxlength="20" class="regularxl">
	   <input type="Hidden" name="CodeOld" value="#get.Code#">
    </TD>
	</TR>
	
	 <TR>
    <TD class="labelmedium"><cf_tl id="Description">:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Sort">:</TD>
    <TD>
  	   <cfinput type="Text" name="listingOrder" value="#get.Listingorder#" message="Please enter a numeric listing order" required="Yes" size="2" validate="integer" maxlength="3" class="regularxl">
    </TD>
	</TR>		
	
	<tr>
		<td class="labelmedium"><cf_tl id="Entry Mode">:</td>
		<td class="labelmedium">
			<table>
			<tr class="labelmedium">
				<td><input type="radio" class="radiol" name="EntryMode" id="EntryMode" value="Manual"  <cfif get.EntryMode eq "Manual">checked</cfif>></td>
				<td style="padding-left:4px">Manual</td>
				<td style="pading-left:10px"><input type="radio" class="radiol" name="EntryMode" id="EntryMode" value="System" <cfif get.EntryMode eq "System">checked</cfif>></td>
				<td style="padding-left:4px">System</td>
				<td style="pading-left:10px"><input type="radio" class="radiol" name="EntryMode" id="EntryMode" value="Batch" <cfif get.EntryMode eq "Batch">checked</cfif>></td>
				<td style="padding-left:4px">Batch generated</td>
				<td style="padding-left:4px">for next</td>	
				<td style="padding-left:4px">
				<input style="width:34px;text-align:center" class="regularxl" type="text" name="BatchDaysSpan" value="<cfif get.BatchDaysSpan eq "">1<cfelse>#get.BatchDaysSpan#</cfif>">
				</td>
				<td style="padding-left:4px">days</td>	
							
			</tr>
			</table>
		</td>
	</tr>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Notification action">:</TD>
    <TD>
	   <table><tr class="labelmedium">
	   <td>
	      <cfdiv bind="url:getActionNotification.cfm?action=#get.ActionNotification#&mission={mission}" id="notification">	     
	   </td>
	   
	   <td style="padding-left:3px">
	    <cfinput type="Text" name="ActionNotificationDays" value="#get.ActionNotificationDays#" style="text-align:center" message="Please enter a numeric listing order" required="Yes" size="2" validate="integer" maxlength="3" class="regularxl">
	   </td>
	   
	   <td class="labelit" style="padding-left:3px">days</td>		 
	   </tr></table>
	   
    </TD>
	</TR>		
	
	
	
	<tr>
		<td class="labelmedium"><cf_tl id="Request Mode">:</td>
		<td class="labelmedium">
		<table>
		<tr class="labelmedium">
		<td><input type="radio" class="radiol" name="ActionRequestMode" id="ActionRequestMode" value="0" <cfif get.ActionRequestMode neq "1">checked</cfif>></td><td style="padding-left:4px">No</td>
		<td style="pading-left:10px"><input type="radio" class="radiol" name="ActionRequestMode" id="ActionRequestMode" <cfif get.ActionRequestMode eq "1">checked</cfif> value="1"></td><td style="padding-left:4px">Yes</td>
		</tr>
		</table>
		</td>
	</tr>
	
	<tr>
		<td class="labelmedium"><cf_tl id="Action Planning">:</td>
		<td class="labelmedium">
		<table><tr class="labelmedium"><td>
		<select name="ActionFulfillment" class="regularxl" onchange="showmode(this.value)">
			<option value="Standard" <cfif get.ActionFulfillment eq "Standard">selected</cfif>>Standard</option>			
			<option value="Message"  <cfif get.ActionFulfillment eq "Message">selected</cfif>>Notification</option>
			<option value="Schedule" <cfif get.ActionFulfillment eq "Schedule">selected</cfif>>Schedule Actor</option>
			<!--- kuntz mode which is a more direct mode for effectively the same --->
			<option value="Workplan" <cfif get.ActionFulfillment eq "Workplan">selected</cfif>>Assign workplan</option>		
		</select>		
		</td>
		
		<script>
		
		 function showmode(box) {
		     if (box == "Message") {
			 	document.getElementById('boxmessage').className = "regular"
			 } else {
			    document.getElementById('boxmessage').className = "hide"
			 }		 
		 }
		 
		</script>
		
		<cfif get.ActionFulfillment eq "message">
			<cfset cl = "regular">
		<cfelse>
			<cfset cl = "hide">	
		</cfif>
		<td id="boxmessage" class="#cl#">
		<table>
		
		<tr class="labelmedium">
		<cfloop index="itm" list="SMS,TTS,SMTP">
							
		<cfquery name="getProtocol" 
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT 	*
				FROM   	Ref_ActionNotification
				WHERE   Code = '#URL.ID#'		
				AND     Protocol = '#itm#'
		</cfquery>	 	
				
		<td style="padding-left:6px"><input type="checkbox" name="Protocol" <cfif getprotocol.recordcount eq "1">checked</cfif> value="#itm#"></td><td style="padding-left:3px">#itm#</td>
		</cfloop>		
		</tr>
		
		</table>
		</td>
		</tr></table>
		</td>
	</tr>
	
	<tr>
		<td class="labelmedium"><cf_tl id="Date validation">:</td>
		<td class="labelmedium">
			<table>
			<tr class="labelmedium">
				<td><input type="radio" class="radiol" name="DateValidation" id="DateValidation" value="0"  <cfif get.DateValidation eq "0">checked</cfif>></td>
				<td style="padding-left:4px">No</td>
				<td style="pading-left:10px"><input type="radio" class="radiol" name="DateValidation" id="DateValidation" value="1" <cfif get.DateValidation eq "1">checked</cfif>></td>
				<td style="padding-left:4px">Future</td>
			</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td class="labelmedium"><cf_tl id="Operational">:</td>
		<td class="labelmedium">
		<table>
		<tr class="labelmedium">
		<td><input type="radio" class="radiol" name="Operational" id="Operational" value="0" <cfif get.Operational neq "1">checked</cfif>></td><td style="padding-left:4px">No</td>
		<td style="pading-left:10px"><input type="radio" checked class="radiol" name="Operational" id="Operational" value="1" <cfif get.Operational eq "1">checked</cfif>></td><td style="padding-left:4px">Yes</td>
		</tr>
		</table>
		</td>
	</tr>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="30">
	<table><tr><td>
    <input class="button10g" type="submit" name="Delete" id="Delete" value="Delete">
	</td>
	<td>
	<input class="button10g" type="submit" name="Insert" id="Insert" value="Save">
	</td></tr></table>
	</td>	
	
	</tr>
			
</table>
</cfoutput>	

</CFFORM>

<cf_screenbottom layout="innerbox">
