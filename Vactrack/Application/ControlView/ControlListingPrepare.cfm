<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Doc3b_#CLIENT.FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Doc4_#CLIENT.FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Doc5_#CLIENT.FileNo#">

<cfset vFund       = "">
<cfset vCondition  = "">
<cfset vCondition2 = "">

<cfif URL.Criteria eq "Yes">

	<cfif Form.FunctionNo neq "">
		<cfset vCondition = vCondition & " AND (T.FunctionNo = '#FORM.FunctionNo#')">
	</cfif>	
	<cfif Form.PositionNo neq "">
		<cfset vCondition = vCondition & " AND (T.PostNumber like '%#FORM.PositionNo#%' OR T.PositionNo like '%#FORM.PositionNo#%')">
	</cfif>	
	<cfif Form.Fund neq "">
	
		<cfset vCondition = vCondition= " AND (T.DocumentNo IN ( SELECT DP.DocumentNo FROM Vacancy.dbo.Document AS D INNER JOIN Vacancy.dbo.DocumentPost AS DP INNER JOIN
                      Employee.dbo.Position AS P ON DP.PositionNo = P.PositionNo INNER JOIN
                      Employee.dbo.PositionParent AS PP ON P.PositionParentId = PP.PositionParentId ON D.DocumentNo = DP.DocumentNo
					WHERE     PP.Fund = '#form.fund#' AND D.Mission = '#url.mission#'))">
	</cfif>			
	<cfif Form.PostGrade neq "">
		<cfset vCondition = vCondition & " AND (T.PostGrade like '%#FORM.PostGrade#%')">
	</cfif>			
	<cfif Form.EntityClass neq "">
		<cfset vCondition = vCondition & " AND (T.EntityClass = '#FORM.EntityClass#')">
	</cfif>			
	<cfif Form.EntityCode neq "">
		<cfset vCondition = vCondition & " AND (T.EntityCode = '#FORM.EntityCode#')">
	</cfif>		
	<cfif Form.ReferenceNo neq "">
		<cfset vCondition = vCondition & " AND ( EXISTS (SELECT 'X' FROM Applicant.dbo.FunctionOrganization F WHERE F.ReferenceNo like '%#FORM.ReferenceNo#%' AND F.DocumentNo = T.DocumentNo) OR (T.ReferenceNo = '#FORM.ReferenceNo#' OR CAST(T.DocumentNo as varchar(10)) = '#Form.ReferenceNo#'))">
	</cfif>		
	<cfif Form.DateEffective neq "">
		<cfset vCondition2 = vCondition2 & " AND (F.DateEffective >= '#FORM.DateEffective#')">	
	</cfif>
	<cfif Form.DateExpiration neq "">
		<cfset vCondition2 = vCondition2 & " AND (F.DateExpiration <= '#FORM.DateExpiration#')">	
	</cfif>	
		
</cfif>		

<cfif (URL.Status eq "0" or URL.Status eq "9")>
	 <cfinclude template="ControlListingPreparePending.cfm">	 	 
<cfelse>	
	<cfinclude template="ControlListingPrepareCompleted.cfm">		
</cfif>
	
<cfif CLIENT.width lte "768">
	<cfset topics = "375">
<cfelse>
	<cfset topics = "700">
</cfif>


