
<TITLE>Submit Metrics and Events</TITLE>

<cftransaction action="BEGIN">

<!--- save metrics --->

<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Program 
		WHERE  ProgramCode = '#URL.ProgramCode#'			 
</cfquery>

<!--- save dates --->

<cfquery name="EventsAll" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ProgramEvent
		WHERE  Code IN (SELECT ProgramEvent
			            FROM   Ref_ProgramEventMission	   
						WHERE  Mission = '#Program.Mission#')
	    ORDER BY ListingOrder, Description
</cfquery>
 
<cfloop query="eventsall">

  <cfparam name="FORM.code_#currentrow#" default="">
  
  <cfif Evaluate("FORM.code_#currentrow#") neq "">
  
	  <cfset code        = Evaluate("FORM.code_#currentrow#")> 
	  <cfset date        = Evaluate("FORM.dateEvent_#currentrow#")>
	  <cfset entityclass = Evaluate("FORM.entityClass_#currentrow#")>
	  <cfset remarks     = Evaluate("FORM.remarks_#currentrow#")>
	  
	  <cfif len(remarks) gte 200>
		    <cfset remarks = left(remarks,200)>
	  </cfif>
	   
	  <cfset dateValue = "">
	    
	  <cfif date eq "">
	  
	     <!--- remove prior entry --->
	     <cfquery name="Reset" 
	      datasource="AppsProgram" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      DELETE 
		  FROM    ProgramEvent
	      WHERE   ProgramCode  = '#url.ProgramCode#'
		    AND   ProgramEvent = '#Code#'
	     </cfquery>	
	  
	  <cfelse>  
	     	 
	    <!--- define value and enter record --->	
		
	    <CF_DateConvert Value="#date#">
			
	    <cfset dtes = dateValue>
				
	    <cfif IsDate(dtes)>
			
			<cfquery name="Check" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM   ProgramEvent
				WHERE  ProgramCode  = '#url.ProgramCode#'
				AND    ProgramEvent = '#Code#' 
			</cfquery>	
			
			<cfset dte = DateFormat(Check.DateEvent,CLIENT.DateFormatShow)>
			
			<cfif dte neq "">
		   	   <CF_DateConvert Value="#DateFormat(Check.DateEvent, '#CLIENT.DateFormatShow#')#">
		       <cfset dte = dateValue>
			</cfif>
						
			<cfif dtes neq dte and Check.recordCount eq "1">
			
			 <!--- we detected it just changed the date in the edit mode but only if the workflow is still pending --->
												
		     <cfquery name="Update" 
		      datasource="AppsProgram" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
			      UPDATE ProgramEvent
				  SET    DateEvent        = #dtes#, 
				         Remarks          = '#Remarks#',
						 EntityClass      = '#EntityClass#', 
					     OfficerUserId    = '#SESSION.acc#',
					     OfficerLastName  = '#SESSION.last#',
					     OfficerFirstName = '#SESSION.first#',
			    	     Created          = getDate() 
				  WHERE  ProgramCode  = '#url.ProgramCode#' 
				  AND    ProgramEvent = '#Code#'
		     </cfquery>	
			 
			<cfelseif dtes eq dte>
			
				 <!--- change the remarks --->
						
				 <cfquery name="Update" 
			      datasource="AppsProgram" 
			      username="#SESSION.login#" 
			      password="#SESSION.dbpw#">
			      UPDATE ProgramEvent
				  SET    Remarks      = '#Remarks#',
				         EntityClass  = '#EntityClass#' 
				  WHERE  ProgramCode  = '#url.ProgramCode#'
				    AND  ProgramEvent = '#Code#'
			     </cfquery>	
				
			<cfelse>
			
			    <!--- new record so we create an event --->
				
				<cfquery name="Insert" 
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO ProgramEvent  
			         (ProgramCode, 
					  ProgramEvent, 
					  DateEvent,
					  EntityClass,
					  Remarks, 
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName)
			     VALUES ('#url.ProgramCode#', 
				      '#Code#', 
					  #dtes#,
					  '#entityclass#',
			          '#remarks#',
			     	  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
			     </cfquery>		
		
		     </cfif>
			 
		 </cfif>	
		 
	   </cfif>	 
	   
	 </cfif>  

</cfloop>

</cftransaction>

<cfset url.mode = "View">

<cfinclude template="EventsEntryDetail.cfm">

  
	

