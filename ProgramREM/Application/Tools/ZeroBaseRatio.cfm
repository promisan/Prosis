
<cfparam name="URL.ID" default="">

<cfquery name="AuditPeriod" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    *
FROM      Ref_Period
WHERE Period = '#URL.ID#'
</cfquery>

<cfquery name="Audit" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    *
FROM      Ref_Audit
WHERE     Period = '#URL.ID#'
ORDER BY AuditDate
</cfquery>

<cfquery name="AuditSub" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    *
FROM      Ref_SubPeriod
</cfquery>

<cfset per = DateDiff("d", "#AuditPeriod.DateEffective#", "#AuditPeriod.DateExpiration#")+1>

<cfloop query="Audit">

	<cfquery name="Current" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_SubPeriod
	WHERE SubPeriod <= '#SubPeriod#'
	</cfquery>
	
	<cfset ela = DateDiff("d", "#AuditPeriod.DateEffective#", "#AuditDate#")+1>	
	<cfset sub = #AuditSub.recordcount# / #Current.recordcount#>
		
	<cfif #per# gt 0>
   		<cfset ratio = (#ela#)/(#per#)>
		<cfset ratio = #ratio#*#sub#>
	<cfelse> 
    	<cfset ratio = 1>
	</cfif>	
	
	<cfif ratio gt "0.97">
	  <cfset ratio = 1>
	</cfif>
		
	<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
	UPDATE Ref_Audit
	SET    ZeroBaseRatio = #ratio#, 
	       DaysIntoPeriod = #ela#
	WHERE  AuditId = '#AuditId#'
	</cfquery>
	
</cfloop>
