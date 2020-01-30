<cfinvoke component="Service.AccessGlobal"  
	      method="global" 
		  role="AdminProgram" 
		  returnvariable="ProgramAccess">
	
<cfif ProgramAccess eq "EDIT" or ProgramAccess eq "ALL">

	<cfset ProgramAccess = "ALL">
	
<cfelse>
	<cfinvoke component="Service.Access"  <!--- get access levels based on top Program--->
		Method="program"
		ProgramCode="#URL.ProgramCode#"
		Period="#URL.Period#"
		ReturnVariable="ProgramAccess">	
</cfif>

<cfif ProgramAccess neq "ALL" AND ProgramAccess neq "EDIT">

	<cfquery name="Progress" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT ProgressId
		FROM ProgramActivityOutput PO INNER JOIN ProgramActivityProgress PA
			ON PO.OutputID = PA.OutputID AND (PA.RecordStatus != 9 or PA.RecordStatus is NULL)
		WHERE (PO.RecordStatus != 9 OR PO.RecordStatus is NULL)
		AND    PO.OutputID = '#URL.OutputId#'		  		
	</cfquery>		

	<cfif Progress.RecordCount neq 0>
	
		<table width="100%" cellspacing="0" cellpadding="0">
		<tr><td>
		<font color="FF0000">DELETION DENIED:  Must have Manager Access to delete Outputs that contain active progress reports</font>
		</td></tr>
		
		</table>		
			
	</cfif>	

<cfelse>

	<cfquery name="DeleteOutput" 
	datasource="AppsProgram" 
	username=#SESSION.login# 
	password=#SESSION.dbpw#>
	UPDATE ProgramActivityOutput 
	SET    RecordStatus = 9
	WHERE  OutputId = '#URL.OutputId#'		  
	</cfquery>	
		
</cfif>

<cfquery name="get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   ProgramActivityOutput 	
	WHERE  OutputId = '#URL.OutputId#'		  
</cfquery>	

<cfset url.outputId = "">	
<cfset url.id = get.ActivityId>
<cfset completed = 0>
<cfinclude template="OutputEntry.cfm">	
