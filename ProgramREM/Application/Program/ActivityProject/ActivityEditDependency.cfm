
<cfinvoke component="Service.AccessGlobal"  
	      method="global" 
		  role="AdminProgram" 
		  returnvariable="AdminAccess">
	
<cfif AdminAccess eq "EDIT" or AdminAccess eq "ALL">

	<cfset ProgramAccess = "ALL">
	
<cfelse>

	<cfinvoke component="Service.Access"  <!--- get access levels based on top Program--->
		Method="program"
		ProgramCode="#URL.ProgramCode#"
		Period="#URL.Period#"
		ReturnVariable="ProgramAccess">	
		
</cfif>

<cf_ActivityRelation 
		    ProgramCode="#URL.ProgramCode#" 
		    ActivityId="#URL.ActivityId#">

<cfquery name="ActionParent" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT *	
		FROM   ProgramActivity
		WHERE  ProgramCode = '#url.ProgramCode#'
		<!--- exclude the activities for which it is a parent directly or indirectly --->
		AND   ActivityId NOT IN (SELECT ActivityId
							     FROM   UserQuery.dbo.#SESSION.acc#ParentActivity
							     WHERE  ActivityParent = '#URL.ActivityID#') 
		<!--- exclude the parents of the parents --->	
		AND   ActivityId NOT IN (SELECT ActivityParent
							     FROM   UserQuery.dbo.#SESSION.acc#ParentActivity
							     WHERE  ActivityId = '#URL.ActivityID#'
							     AND    DepOrder > '1') 					
		AND   ActivityId   != '#URL.ActivityId#'	
		AND   RecordStatus != '9'
		ORDER BY ActivityDateStart 
		
</cfquery>

<!---
<cfform name="activitydependency" method="post" style="height:100%" onsubmit="return false"> 
--->
		
<cfif ActionParent.recordcount gt "0">
	
		<table width="97%" border="0" cellspacing="0" cellpadding="0">
			<tr><td height="2"></td></tr>		
			<tr><td style="height:40px" class="labelmedium"><cf_tl id="Start activity after completion of">:</font></td></tr>					
			<tr>
			<td id="dep">							
				<cfinclude template="ActivityEditDependencyDetail.cfm">  
			 </td>
			</TR>
			<tr><td height="6"></td></tr>	
		</table>	
	
<cfelse>
	
		<table width="97%" border="0" cellspacing="0" cellpadding="0">			
			<tr>
			<td class="labelit" style="width:20px;padding-left:4px">
			<img src="<cfoutput>#session.root#</cfoutput>/images/join.gif" alt="" border="0">
			</td>
			<td class="labelit">
			<font color="red">There are no activities that can be made a parent for this activity</td></tr>											
		</table>	
																					
</cfif>

<!---
</cfform>
--->