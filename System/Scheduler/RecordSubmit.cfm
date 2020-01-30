<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.operational" default="">

<cfif not FileExists("#SESSION.rootPath#\#Form.ScheduleTemplate#")>
  <script>
 	alert("You entered an invalid schedule template: <cfoutput>#SESSION.rootPath#\#Form.ScheduleTemplate#</cfoutput>. Operation not allowed.");
  </script>	
  <cfabort>

</cfif>


<cfif Len(Form.ScheduleMemo) gt 100>
	<script>
	 	alert("You entered a memo that exceeded the allowed size of 100 characters.");
	</script> 
	  <cfabort>
</cfif>
	
<cfset dateValue = "">
<CF_DateConvert Value="#DateFormat(Form.ScheduleStartDate,CLIENT.DateFormatShow)#">
<cfset dte = dateValue>

<cfset tm = "#form.hour#:#form.minute#">

<cfif len(tm) lt "5">
  <script>
	  alert("You entered an invalid time: <cfoutput>#form.hour#:#form.minute#</cfoutput>. Format should be HH:MM.");
  </script>
  <cfabort>

</cfif>
	
	<cfif URL.ID eq "">
	
	    <cfset name = replace(form.ScheduleName," ", "", "All")> 
		<cfset name = replace(form.ScheduleName,".", "", "All")> 
	
		<cfquery name="Check" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  *
		FROM    Schedule
		WHERE   ScheduleName = '#name#'
		</cfquery>
		
		<cfif check.recordcount eq "0">
		
			<cfquery name="Insert" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Schedule
				(SystemModule, 
				 ScheduleName, 
				 ScheduleTemplate, 
				 SchedulePassThru,
				 ScheduleInterval, 
				 ScheduleStartDate, 
				 ScheduleStartTime, 
				 ScheduleEndTime, 
				 ScheduleMemo, 
				 <cfif Form.misfire neq "">
				 	ScriptMisfire,
				 </cfif>
				 ScriptTimeOut,  
				 ScriptFailureMail, 
				 ScriptSuccessMail, 
				 ApplicationServer,
				 ParentScheduleId,
				 <cfif url.collectionid neq "">
				 CollectionId,
				 </cfif>
				 Operational,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
			 
			VALUES ('#form.SystemModule#', 
			        '#name#', 
					'#form.ScheduleTemplate#', 
					'#form.SchedulePassThru#',
					'#form.ScheduleInterval#', 
					#dte#, 
					'#form.hour#:#form.minute#',
					'#form.ehour#:#form.eminute#',
					'#form.ScheduleMemo#',
					<cfif Form.misfire neq "">
						'#form.misfire#',
					</cfif>
					'#form.ScriptTimeOut#',
					'#form.ScriptFailureMail#', 
					'#form.ScriptSuccessMail#',
					'#form.ApplicationServer#',
					<cfif Form.ParentScheduleId eq "">
					NULL,
					<cfelse>
					'#Form.ParentScheduleId#',
					</cfif>
					 <cfif url.collectionid neq "">
					 '#url.collectionid#',
					 </cfif>
					'0',
					'#SESSION.acc#',		
					'#SESSION.last#',				  
					'#SESSION.first#')	
			</cfquery>
		
		</cfif>
	
	<cfelse>
			
		<cfquery name="Update" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Schedule
		SET      ApplicationServer = '#Form.ApplicationServer#',
				 ScheduleInterval  = '#Form.ScheduleInterval#',
				 ScheduleStartDate = '#dateformat(dte,'MM/DD/YY')#',
				 ScheduleStartTime = '#form.hour#:#form.minute#',
				 <cfif Form.ScheduleInterval eq "600" or Form.ScheduleInterval eq "900" or Form.ScheduleInterval eq "3600">
				 ScheduleEndTime   = '#form.ehour#:#form.eminute#',
				 <cfelse>
				 ScheduleEndTime   = '',
				 </cfif>				
				 ScriptFailureMail = '#form.ScriptFailureMail#', 
				 ScriptSuccessMail = '#form.ScriptSuccessMail#',
				 ScheduleTemplate  = '#Form.ScheduleTemplate#', 
				 SchedulePassThru  = '#Form.SchedulePassThru#', 
				 ScheduleMemo      = '#Form.ScheduleMemo#',
				 <cfif Form.misfire neq "">
				 	ScriptMisfire = '#Form.misfire#',
				 </cfif>
				 ScriptTimeOut     = '#form.ScriptTimeOut#',
				 <cfif Form.ParentScheduleId eq "">
				 ParentScheduleId  = NULL
				 <cfelse>
				 ParentScheduleId  ='#Form.ParentScheduleId#'
				 </cfif>
				 <cfif form.operational neq "">		 
				 ,Operational       = '#Form.Operational#'
				 </cfif>
		WHERE ScheduleId = '#URL.ID#'
		</cfquery>
	
	</cfif>

<!--- ------------------------------ --->	
<!--- apply hierarchy within a group --->
<!--- ------------------------------ --->	

<cfquery name="reset" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Schedule
		SET   ScheduleHierarchy = NULL		
</cfquery>

<cfquery name="Get" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Schedule
		WHERE  ParentScheduleId is NULL
		ORDER BY SystemModule, ScheduleName
</cfquery>

<cfloop query="Get">

	<cfquery name="set" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Schedule
			SET    ScheduleHierarchy = '#currentrow#'
			WHERE  ScheduleId = '#scheduleid#'		
	</cfquery>
	
	<cfset lvl = "#currentrow#">

	<cfquery name="getSub" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * FROM Schedule
			WHERE ParentScheduleId = '#scheduleid#'		
			AND   ScheduleHierarchy is NULL		
	</cfquery>
	
	<cfloop query="getSub">
	
		<cfquery name="set" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE Schedule
				SET    ScheduleHierarchy = '#lvl#.#currentrow#'
				WHERE  ScheduleId = '#scheduleid#'		
		</cfquery>
		
		<cfquery name="getSub1" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * FROM Schedule
			WHERE ParentScheduleId = '#scheduleid#'		
			AND   ScheduleHierarchy is NULL		
		</cfquery>
		
		<cfset lvl = "#lvl#.#currentrow#">
		
			<cfloop query="getSub1">
			
				<cfquery name="set" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE Schedule
					SET    ScheduleHierarchy = '#lvl#.#currentrow#'
					WHERE  ScheduleId = '#scheduleid#'		
				</cfquery>
				
			</cfloop>	
				
	</cfloop>

</cfloop>

<!--- ------------------------------ --->	
<!--- ------------------------------ --->	

<cfif form.operational neq "">		
	
	<!--- apply schedule to cfmx engine --->
	<cfinclude template="ScheduleApply.cfm">
</cfif>
		
	
<script language="JavaScript">
    <cfif url.id eq "">		  
	   parent.window.close()
	   parent.opener.history.go()
	<cfelse>	   
       parent.window.close()	 	
	   parent.opener.history.go()
	</cfif>   
</script>  
	

