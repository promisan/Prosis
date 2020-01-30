<cfparam name="url.editreference" default="0">

<cfquery name="AllotmentAction"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     P.ProgramCode, 
	           Pe.Reference,
			   PA.Reference as DocumentReference,
			   Pe.Period,
			   P.ProgramClass, 
			   P.ProgramName, 
			   R.EditionId,
			   R.Description AS EditionDescription, 
			   RA.Description AS ActionDescription, 
			   PA.ActionType, 
               PA.ActionMemo, 
			   PA.Status, 
			   PA.ActionDate,
			   PA.OfficerUserId, 
			   PA.OfficerLastName, 
			   PA.OfficerFirstName, 
			   PA.Created
	FROM       ProgramAllotmentAction PA INNER JOIN
               Ref_AllotmentEdition R ON PA.EditionId = R.EditionId INNER JOIN
               Program P ON PA.ProgramCode = P.ProgramCode INNER JOIN
               ProgramPeriod Pe ON PA.ProgramCode = Pe.ProgramCode AND PA.Period = Pe.Period LEFT OUTER JOIN
               Ref_AllotmentAction RA ON PA.ActionClass = RA.Code
	WHERE      PA.ActionId = '#url.id#'
</cfquery>	
	
<cfoutput>	

<cfif url.editreference eq 0>

	 <cfinvoke component="Service.Access"  
				Method         = "budget"
				ProgramCode    = "#AllotmentAction.ProgramCode#"
				Period         = "#AllotmentAction.Period#"	
				EditionId      = "'#AllotmentAction.EditionID#'"  
				Role           = "'BudgetManager'"
				ReturnVariable = "BudgetAccess">			
		
			 <cfif (BudgetAccess eq "EDIT" or BudgetAccess eq "ALL")>
				<a href="##" onclick="javascript:changeReference('#url.id#')">
					<font color="0080FF">
					#AllotmentAction.DocumentReference#
					</font>
				</a>
			<cfelse>
				#AllotmentAction.DocumentReference#	
			</cfif>		
<cfelse>	

	<CFFORM action="AllotmentActionReferenceEditSubmit.cfm" method="post" name="editreference" onsubmit="return false">
		<input type="text" id="tReference" name="tReference" class="regularxl" value="#AllotmentAction.DocumentReference#">
		<a href="##" onclick="javascript:submitActionReference('#URL.ID#')" title="Click to save reference">
				&nbsp;<font color="0080FF">Save</font>
		</a>
	</CFFORM>	

</cfif>
</cfoutput>	