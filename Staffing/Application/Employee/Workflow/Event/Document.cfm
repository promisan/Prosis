

<cfset eventclass = "Contract">

<cfquery name="Event" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   PersonEvent
	WHERE    EventId    = '#Object.ObjectKeyvalue4#'
</cfquery>

<cfswitch expression="#eventclass#">

	<cfcase value="Contract">
		
		<!--- get personNo and Postnumber and obtain the last assignment record --->
		
		<table style="width:100%" align="center">
		
		    <cfoutput>
			<tr><td class="labelmedium2" colspan="7" style="font-size:20px;padding-top:6px;height:40px;">Select the incumbency to be updated in #session.welcome# and press continuet</td></tr>
			</cfoutput>
			
			<tr class="line labelmedium2 fixlengthlist">
			    <td><cf_tl id="Position"></td>
				<td><cf_tl id="Grade"></td>
				<td><cf_tl id="Title"></td>
				<td><cf_tl id="Effective"></td>
				<td><cf_tl id="Class"></td>
				<td><cf_tl id="Expiration"></td>
				<td><cf_tl id="Update"></td>
			</tr>
			
			<cfquery name="get" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				  	 SELECT   TOP 1 PA.*, P.SourcePostNumber, P.PostGrade, P.FunctionDescription
					 FROM     PersonAssignment PA INNER JOIN Position P ON PA.PositionNo = P.PositionNo
					 WHERE    PersonNo = '#event.PersonNo#'
					 AND      MissionOperational  = '#event.Mission#'
					 AND      AssignmentStatus IN ('0','1')
					 AND      Incumbency = '100'
				  	 ORDER BY DateEffective DESC
					 
			</cfquery>		
			
			<!--- incumbency 100%, type actual, post and person --->
			
			<cfoutput query="get">
				<tr class="line labelmedium2 fixlengthlist" style="height:40px">
				    <td><cfif sourcePostNumber neq "">#sourcePostNumber#<cfelse>#PositionNo#</cfif></td>
					<td>#PostGrade#	</td>
					<td>#FunctionDescription#</td>
					<td>#dateformat(dateEffective,client.dateformatshow)#</td>
					<td>#AssignmentClass#</td>
					<td>	
						<cf_intelliCalendarDate9
							FieldName="DateExpiration100" 
							Manual="True"		
							class="regularxl"					
							DateValidStart="#Dateformat(Event.ActionDateEffective, 'YYYYMMDD')#"									
							Default="#Dateformat(Event.ActionDateExpiration, client.dateformatshow)#"
							AllowBlank="False">	
					
					</td>
					<td><input type="checkbox" style="height:18px;width:18px" class="radiol" name="Assignment100" value="1"></td>
				</tr>
			</cfoutput>
			
			<cfquery name="get" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				  	 SELECT   TOP 1 PA.*, P.SourcePostNumber, P.PostGrade, P.FunctionDescription
					 FROM     PersonAssignment PA INNER JOIN Position P ON PA.PositionNo = P.PositionNo
					 WHERE    PersonNo = '#event.PersonNo#'
					 AND      MissionOperational  = '#event.Mission#'
					 AND      AssignmentStatus IN ('0','1')
					 AND      PA.DateExpiration > getDate()
					 AND      Incumbency = '0'
				  	 ORDER BY DateEffective DESC
			</cfquery>		
			
			<cfoutput query="get">
				<tr class="line labelmedium2 fixlengthlist" style="height:40px">
				    <td><cfif sourcePostNumber neq "">#sourcePostNumber#<cfelse>#PositionNo#</cfif></td>
					<td>#PostGrade#	</td>
					<td>#FunctionDescription#</td>
					<td>#dateformat(dateEffective,client.dateformatshow)#</td>
					<td>#AssignmentClass#</td>
					<td>	
						<cf_intelliCalendarDate9
							FieldName="DateExpiration0" 
							Manual="True"		
							class="regularxl"					
							DateValidStart="#Dateformat(Event.ActionDateEffective, 'YYYYMMDD')#"									
							Default="#Dateformat(Event.ActionDateExpiration, client.dateformatshow)#"
							AllowBlank="False">	
					
					</td>
					<td><input type="checkbox" style="height:18px;width:18px" class="radiol" name="Assignment0" value="1"></td>
				</tr>
			</cfoutput>
			
		<tr><td> 
		<input name="savecustom" type="hidden"  
		    value="Staffing/Application/Employee/Workflow/Event/DocumentSubmit.cfm">
		</td>
     	</tr> 
		
		</table>
	
	</cfcase>

</cfswitch>
	