<cfparam name="url.select" 		default="enddate">
<cfparam name="url.reference" 	default="">

<cfif isDefined("form.reference")>
	<cfset url.reference = form.reference>
</cfif>

 <cfquery name="Base" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    ProgramActivity  
	WHERE   ActivityId = '#URL.Id#'	
</cfquery>		

 <cfif url.select eq "enddate">
 
	   <cfquery name="Check" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   ProgramActivity  
		WHERE  ActivityId = '#URL.Id#'	
	   </cfquery>		
	 
	   <CF_DateConvert Value="#DateFormat(Check.ActivityDate,CLIENT.DateFormatShow)#">
	   <cfset Dte = dateValue>
	   <cfset def = 1>
	     
 <cfelse>
 
		 <cfset dateValue = "">
		 <CF_DateConvert Value="#url.ActivityOutputDate#">
		 <cfset Dte = dateValue>
		 <cfset def = 0>
		 
		 <cfoutput>
		 
		 <cfif not isDate(dte)>
		 
			 <script>
				 alert("You entered an Invalid target date.")
				 ColdFusion.navigate('OutputEntryDialog.cfm?completed=0&programaccess=#url.programaccess#&id=#URL.ID#&outputid=#url.outputid#','outputdialog')
			 </script>	 
			 <cfabort>
			 
		 </cfif>
	 
	     </cfoutput>
	 
	 <cfquery name="Check" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    ProgramActivity  
		WHERE   ActivityId = '#URL.Id#'	
		AND     ActivityDateStart < #dte#
	</cfquery>		
	
	<!---
	<cfif check.recordcount eq "0">
		
		<CF_DateConvert Value="#DateFormat(Check.ActivityDateStart,CLIENT.DateFormatShow)#">
		<cfset Dte = dateValue>
		<cfset def = 1>
	
	</cfif>	 
	--->
 
 </cfif>	
 
 <cfparam name="Form.ActivityOutput" default="">
 <cfparam name="Form.ProgramCategory" default="">
   	 
 <cfif URL.OutputId eq "0"> 
	
	<cfquery name="Insert" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO ProgramActivityOutput  
	         (ProgramCode, 
			  ActivityPeriod,
			  ActivityId, 
			  ActivityOutputDate,
			  ActivityOutputDefault,
			  ActivityOutput,
			  Reference,
			  ProgramCategory,
			  OfficerUserId,
			  OfficerLastName,
			  OfficerFirstName)
	  VALUES ('#URL.ProgramCode#', 
	  		  '#Base.ActivityPeriod#',
	  		  '#URL.Id#',
			  #dte#,
			  #def#,
			  '#form.ActivityOutput#', 
			  '#url.Reference#',
			  <cfif form.ProgramCategory neq "">
			  '#form.ProgramCategory#', 
			  <cfelse>
			  NULL, 
			  </cfif>
			  '#SESSION.acc#',
			  '#SESSION.last#',
			  '#SESSION.first#') 
	</cfquery>		
	
	<cfquery name="LastNo" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 SELECT Max(OutputId) as OutputId
		 FROM   ProgramActivityOutput
		 WHERE  ActivityID     = '#URL.id#'
		 <!---
		  AND   ProgramCode    = '#URL.ProgramCode#'
		  AND   ActivityPeriod = '#URL.Period#'
		  --->
		 </cfquery>
			
<cfelse>

    <cfquery name="Insert" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE ProgramActivityOutput  
	SET    ActivityOutputDate    = #Dte#,
	       ActivityOutputDefault = #def#,
	       ActivityOutput        = '#form.ActivityOutput#',
		   Reference             = '#Form.ReferenceOutput#',
		   <cfif form.ProgramCategory neq "">
		   ProgramCategory       = '#form.ProgramCategory#',
		   <cfelse>
		   ProgramCategory       = NULL,
		   </cfif>		 
		   OfficerUserId         = '#SESSION.acc#',
		   OfficerLastName       = '#SESSION.last#',
		   OfficerFirstName      = '#SESSION.first#'
    WHERE  OutputId             = '#URL.OutputId#'	
	</cfquery>		
	
</cfif>		

<cfoutput>
	<script>
	    ProsisUI.closeWindow('outputdialog')
		ptoken.navigate('OutputEntry.cfm?completed=0&programaccess=#url.programaccess#&id=#URL.ID#','outputbox')
	</script>
</cfoutput>

