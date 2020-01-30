
<cfquery name="Edit" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM       Program
	WHERE      ProgramCode = '#url.Program#'	   
</cfquery>

<cfset url.mission = edit.mission>

<cfquery name="Edition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_AllotmentEdition E, Ref_AllotmentVersion V
	WHERE    E.Version = V.Code
	AND      E.ControlEdit = 1	
	AND      E.Mission     = '#Edit.Mission#'   
	<cfif url.version neq "">
	AND      E.Version     = '#URL.Version#' 
	</cfif>
	AND      (E.Period is NULL 
	              or 
		      E.Period IN (SELECT Period 
			               FROM   Ref_Period 
						   WHERE  DateEffective >= (SELECT DateEffective 
						                            FROM   Ref_Period  
													WHERE  Period = '#URL.Period#')
						  )							
			 )
	
	ORDER BY E.ListingOrder, Period	
		
</cfquery>


<cfset edmode = Edition.BudgetEntryMode>

<cfif Edition.recordcount eq "0">

  <cf_tl id="No Allotment Editions were set for this entity" var="1">
  <cfset vMessage2 = lt_text>
  
  <cf_message message = "<cfoutput>#vMessage2#</cfoutput>" return = "back"> 
  <cfabort>

</cfif>

<cfset objectfilter = "1">

<cfoutput query="Edition">
		 
	 <cfif BudgetEntryMode eq "0">
	 	   <cfset objectfilter = 0>
	 </cfif>	 
	
</cfoutput>

<cfparam name="url.scope" default="default">

<cfif url.scope eq "entry" or url.mode eq "entry">   
   <cfinclude template="AllotmentEntry.cfm">	
<cfelseif objectfilter eq "0" and edit.EnforceAllotmentRequest eq "0">     
	<cfinclude template="AllotmentEntry.cfm">	
<cfelse>
    <cfinclude template="AllotmentInquiry.cfm">
</cfif>