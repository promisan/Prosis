
<!--- ---------------------------------------- --->
<!--- verify if the assignments are consistent --->

<!---
<cftry>
--->

<cfparam name="URL.Mode"               default="Silent">
<cfparam name="attributes.Mission"     default="">
<cfparam name="attributes.MandateNo"   default="P001">
<cfparam name="attributes.PersonNo"    default="">

<!--- select indexNo with two or more record with the same DateEffective --->

<!--- verify assignments from an employee perspective with more than one active assignment, this will limit
the number of cases with an approx 90% --->

<cfquery name="ResultList" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   A.*
	FROM     PersonAssignment A 			 
    WHERE    A.AssignmentStatus IN ('0', '1') 
	<cfif attributes.personNo neq "">
	AND      Personno = '#attributes.personNo#'
	</cfif>			
    AND      A.PositionNo IN
                          (SELECT  PositionNo
                           FROM    Position
                           WHERE   Mission   = '#attributes.Mission#' 
							AND    MandateNo = '#attributes.MandateNo#')
    ORDER BY A.AssignmentClass, A.PersonNo, A.DateEffective, A.DateExpiration
</cfquery>

<cfoutput query="ResultList" group="AssignmentClass">

	<cfoutput group="PersonNo">

    	<cfset init = "0">

		<cfoutput>
				
			<!--- loop through the records startdate = date expiration + 1
				if date expiration = date effective delete record --->
			
			<cfif init eq "1">
						
				<cfset dateValue = "">
				<CF_DateConvert Value="#DateFormat(DateEffective,CLIENT.DateFormatShow)#">
				<cfset eff = dateValue>
				
				<cfset dateValue = "">
				<CF_DateConvert Value="#DateFormat(DateExpiration,CLIENT.DateFormatShow)#">
				<cfset exp = dateValue>
				
				<cfif def gt eff>
				
					<cfif def lt exp>
					
						<cfquery name="Update" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							UPDATE  PersonAssignment
							SET     DateEffective = #def#,
							        Remarks = 'Effective date correction by system'
							WHERE   AssignmentNo = '#AssignmentNo#'
						</cfquery>
					
					<cfelse>
					
						<cfquery name="Delete" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							DELETE FROM PersonAssignment
							WHERE  AssignmentNo = '#AssignmentNo#'
						</cfquery>
							
					</cfif>
					
				</cfif>	
				
		</cfif>
					
		<cfset dateValue = "">
		<CF_DateConvert Value="#DateFormat(DateExpiration,CLIENT.DateFormatShow)#">
		<cfset def = DateAdd("d", "1", "#dateValue#")>
		<cfset init = "1">
			
		</cfoutput>
			
	</cfoutput>

</cfoutput>

