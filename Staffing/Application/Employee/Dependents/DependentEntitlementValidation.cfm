<!--- Validation --->
<cfset vError  = FALSE>
<cfset vMsg = "">

<cfquery name="CheckInsurance" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT     *
    FROM       PersonAssignment A, 
	           Position P,
	           Organization.dbo.Organization O, 
		       Organization.dbo.Ref_Mission M,
			   Ref_AssignmentClass C
	WHERE      A.OrgUnit = O.OrgUnit
	  AND      A.PersonNo = '#Form.PersonNo#'
	  AND      M.Mission = O.Mission
	  AND      C.AssignmentClass = A.AssignmentClass 
	  AND      A.PositionNo = P.PositionNo
	  AND      A.AssignmentStatus < '8'
	  ORDER BY M.MissionOwner, 
	           A.AssignmentClass, 
			   A.DateEffective 
</cfquery>

<cfquery name="TriggerGroup" 
    datasource="AppsPayroll" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_TriggerGroup
	WHERE     TriggerGroup NOT IN
                          (SELECT    DISTINCT T.TriggerGroup
                            FROM     Ref_PayrollComponent R INNER JOIN
                                     Ref_PayrollTrigger T ON R.SalaryTrigger = T.SalaryTrigger INNER JOIN
                                     Ref_PayrollItem I ON R.PayrollItem = I.PayrollItem
                            WHERE    T.TriggerGroup IN ('Insurance','Dependent','Allowance','Housing') 
							AND      I.AllowOverlap = 1)
	AND     TriggerGroup IN ('Insurance','Dependent','Allowance','Housing')  						
 </cfquery> 
  
 <!--- we check only trigger groups that have no single record as overlap allowed ---> 
      
<cfloop query="triggergroup">

	<cfset item = left(triggergroup,1)>

	<cfset vDates = ArrayNew(1)>
	
	<cfloop index="line" list="0,1,2,3,4">
	
		<cfparam name="FORM.SalaryTrigger#item#_#line#"   default="">					
		<cfparam name="FORM.DateEffective#item#_#line#"   default="">					
		<cfparam name="FORM.DateExpiration#item#_#line#"  default="">

		<cfset triggerN    = Evaluate("FORM.SalaryTrigger#Item#_#line#")>																				
		<cfset effectiveN  = Evaluate("FORM.DateEffective#Item#_#line#")>
		<cfset expirationN = Evaluate("FORM.DateExpiration#Item#_#line#")>
		
		<cfset dateValue = "">
		<CF_DateConvert Value="#effectiveN#">
		<cfset STR = dateValue>
		
		<cfset dateValue = "">
		<!--- Change from Form.DateExpirationM to expirationN---->
		
		<cfif expirationN neq ''>
		    <CF_DateConvert Value="#expirationN#">
		    <cfset END = dateValue>
		<cfelse>
		    <cfset END = 'NULL'>
		</cfif>			
		
		<cfif triggerN neq "" and effectiveN neq "">
				
			<cfset vDate = StructNew()>
			<cfset vDate[1] = triggerN>
			<cfset vDate[2] = effectiveN>
			<cfset vDate[3] = expirationN>
			<cfset ArrayAppend(vDates, vDate)>
			
		</cfif>	
		
	</cfloop>		
			
	<cfif ArrayLen(vDates) gte "1">
		
	<!--- Looping through the array ---> 
		
		<cfloop index="i" from="1" to="#ArrayLen(vDates)#">	
	
				<cfset vEff = vDates[i][2]>
				<cfset vExp = vDates[i][3]>
	
				<!--- added by Armin on June 2013 --->
				<cfset dateValue = "">
				<CF_DateConvert Value="#vEff#">
				<cfset cEff = dateValue>
				
				<cfset dateValue = "">
			    <CF_DateConvert Value="#vExp#">
			    <cfset cExp = dateValue>
	
				<cfif cEff gt cExp and vExp neq "">
					<cfset vError  = TRUE>
					<cfset vMsg = "#vEff# is greater than #vExp#">
					<cfbreak>
				</cfif>
				
				<!--- Checking for overlapping --->
				
				<cfloop index = "j" from="1" to="#ArrayLen(vDates)#">
				
					<cfif i neq j>
						<cfset vEff2 = vDates[j][2]>
						<cfset vExp2 = vDates[j][3]>
						<cfif (DateFormat(vEff,CLIENT.DateFormatShow) lte DateFormat(vExp2,CLIENT.DateFormatShow) or vExp2 eq "") 
							AND (DateFormat(vEff2,CLIENT.DateFormatShow) lte DateFormat(vExp,CLIENT.DateFormatShow) or vExp eq "")>
							<cfset vError  = TRUE>
							<cfset vMsg = "#vEff2# overlaps with another period.">
							<cfbreak>
						</cfif>
						
					</cfif>
				
				</cfloop>
				
				<cfif vError>
					<cfbreak>
				</cfif>
		</cfloop>	
				
	</cfif>	
		
</cfloop>	

					
<cfif vError>
	<cfoutput>
	<script>
		alert('Error in data field #vMsg#');
	</script>
	</cfoutput>
	
	<cfabort>
</cfif>

<cfset dateValue = "">
<cfif Form.BirthDate neq ''>
	<CF_DateConvert Value="#Form.BirthDate#">
	<cfset DOB = dateValue>
<cfelse>
    <cfset DOB = 'NULL'>
</cfif>	

<cfquery name = "qCheck" datasource = "AppsEmployee">
	SELECT *
	FROM PersonDependent
	WHERE PersonNo     = '#FORM.PersonNo#' 
	AND  DependentId  != '#FORM.DependentId#'
	AND  LastName      = '#Form.LastName#'
	AND  FirstName     = '#Form.FirstName#'
	AND  Gender        = '#Form.Gender#'
	AND  Birthdate     = #DOB#
	AND  ActionStatus != '9'
</cfquery>

<cfif qCheck.recordcount neq 0>

		<cfoutput>
			<script>
				alert('A dependent record was found with the same firstname, lastname, gender and day of birth');
			</script>
		</cfoutput>
		<cfabort>

</cfif>