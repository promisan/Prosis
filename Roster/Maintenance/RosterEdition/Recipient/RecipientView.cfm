
<cfparam name="Object.ObjectKeyValue1" default="">
<cfparam name="url.submissionedition" default="#Object.ObjectKeyValue1#">

<cfinclude template="RecipientViewInit.cfm">


<cfoutput>

<!----- Getting default values ----->
<cfquery name="qExercise"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT EX.*
	FROM   Ref_ExerciseClass EX INNER JOIN Ref_SubmissionEdition S
			ON EX.ExcerciseClass = S.ExerciseClass
	WHERE S.SubmissionEdition = '#url.submissionedition#'
</cfquery>
	
<table width="96%" border="0" align="center">

<tr><td style="height:10px"></td></tr>

<!--- Select latest profile created by user through the workflow --->
<cfquery name="qLatestProfile"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 ActionId
	FROM   Ref_SubmissionEditionProfile
	WHERE  SubmissionEdition = '#url.submissionedition#'
	AND    ActionStatus = '1' <!--- ready to be sent, ActionStatus=1 is set by the WF step forward action --->
	ORDER  BY Created DESC
</cfquery>

<!--- Do parsing of profiles only if triggered from the WF and if there are profiles ready to be sent --->
<cfif Object.ObjectKeyValue1 neq "" and qLatestProfile.RecordCount eq 1>
		
	<TR>
		<TD colspan="3" style="padding:5px;padding-left:5px" id="preparation">
		
			<input type="button" class="button10g" id="Send" name="Send" value="Broadcast Edition" style="border-radius:7px;height:30;width:220" onclick="doSend('#url.submissionedition#','#qLatestProfile.ActionId#')">				
			
			<cfset Session.Status = 0>
										
			<cfprogressbar name="pBar" 
			    style="bgcolor:gray;progresscolor:black" 					
				height="20" 
				bind="cfc:service.Authorization.AuthorizationBatch.getstatus()"				
				interval="1000" 
				autoDisplay="false" 
				width="506"/> 
		</TD>		
	</TR>
	
	<tr><td colspan="3" class="linedotted"></tr>

<!--- Otherwise, just send a broadcast (no parsing of profiles) --->
<cfelse>

	<TR>
		<TD colspan="3" style="padding:5px;padding-left:5px" id="preparation">
			<input class="button10g" type="button" id="Send" name="Send" value="Ad hoc Broadcast" style="height:26;width:210" onclick="broadcast('#url.submissionedition#','prior')">				
		</TD>		
	</TR>
	
	<tr><td colspan="3" class="linedotted"></tr>
	
	
</cfif>

<TR>
	<TD></TD>
	<TD height="30">
		<table>
			<tr>				
				<td class="labelmedium" id="ltypesrecipients">Addressee Selection</b></td>
				<cfset link = "#SESSION.root#/roster/maintenance/rosteredition/Recipient/RecipientAddressType.cfm?submissionedition=#url.submissionedition#">			
				<TD  class="labelmedium" style="padding-right:40px" id="dTypesRecipients">
				<cf_securediv bind="url:#link#" id="types"/>
				</TD>
			</tr>
		</table>
	</TD>
	
</TR>

<tr><td colspan="3" class="linedotted"></td></tr>

<tr><td class="hide" id="recipientprocess"></td></tr>

<TR>
	<TD></TD>
	<TD height="25">
		<table>
			<tr>				
				<td class="labelmedium"  class="labelit" id="lrecipients"><cf_tl id="Recipients"></td>
				<td style="padding-left:7px" class="labelmedium"><a href="javascript:recipientselectall('#url.submissionedition#')"><font color="0080C0">[Select all]</font></a></td>
				<td style="padding-left:5px" class="labelmedium"><a href="javascript:recipientremoveall('#url.submissionedition#')"><font color="0080C0">[Remove all]</font></a></td>
			</tr>
		</table>
	</TD>
	<TD></TD>
</TR>

<cfset link = "#SESSION.root#/roster/maintenance/rosteredition/Recipient/RecipientViewDetail.cfm?submissionedition=#url.submissionedition#">		
	
<TR>
	<TD></TD>
	<TD colspan="2" style="border:1px dotted silver" id="dRecipients"><cf_securediv bind="url:#link#" id="recipients"/></TD>
</TR>

</TABLE>
						
</cfoutput>
