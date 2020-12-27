
<cfparam name="URL.Box" default="">
<cfparam name="URL.AssignmentNo" default="">

<cfset dateValue = "">
	   <CF_DateConvert Value="#Form.DateEffective#">
	<cfset STR = dateValue>
					
	<cfset dateValue = "">
	   <CF_DateConvert Value="#Form.DateExpiration#">
	<cfset END = dateValue>
	
<cfif form.FirstOfficer eq "">

	<script>
		alert("Problem, you need to define a supervisor")
	</script>

</cfif>

<cfquery name="PAS" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT   PA.*, O.Mission, O.MandateNo, P.PostGrade, O.OrgUnitName AS OrgUnitName, O.HierarchyCode, P.SourcePostNumber
	FROM     PersonAssignment PA INNER JOIN
             Position P ON PA.PositionNo = P.PositionNo INNER JOIN
             Organization.dbo.Organization O ON PA.OrgUnit = O.OrgUnit
    WHERE    PA.AssignmentNo = '#URL.AssignmentNo#'	 
</cfquery>	

<cf_assignId>

<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
	
	<cfquery name="Parameter" 
    datasource="appsEPas" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	    SELECT *
	    FROM Parameter
	</cfquery>
		
	<cfset No = Parameter.PASNo+1>
	<cfif No lt 10000>
	     <cfset No = 10000+No>
	</cfif>
		
	<cfquery name="Update" 
	datasource="appsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE Parameter
		SET PasNo = '#No#'
	</cfquery>

</cflock>
		   		
<cfquery name="Insert" 
	datasource="appsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    INSERT INTO Contract
     	(ContractId,
		ContractNo,
		ContractClass,
		Mission,
		PersonNo, 
		Period,
		OrgUnit,
		AssignmentNo,
		OrgUnitName,
		DateEffective,
		DateExpiration,
		LocationCode,
		FunctionNo,
		FunctionDescription,
		ActionStatus, 
		OfficerUserId, 
		OfficerLastName, 
		OfficerFirstName)
	VALUES ('#rowguid#',
	        '#No#',
			'#Form.ContractClass#',
			'#PAS.Mission#',
	        '#PAS.PersonNo#',
			'#Form.Period#',
	        '#PAS.OrgUnit#',
			'#URL.AssignmentNo#',
			'#PAS.OrgUnitName#',
			#STR#,
			#END#,
			'#PAS.LocationCode#',
			'#PAS.FunctionNo#',
			'#PAS.FunctionDescription#',
			'0',
			'#SESSION.acc#', 
			'#SESSION.last#', 
			'#SESSION.first#')
	</cfquery>
	
	<cfloop index="RoleFunction" list="FirstOfficer,SecondOfficer">
	
		<cfparam name="Form.#rolefunction#" default="">
		<cfset per = evaluate("Form.#rolefunction#")>
								
	   <cfquery name="Insert" 
		datasource="appsEPAS" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    INSERT INTO ContractActor
			     	(ContractId, 
					PersonNo,
					Role,
					RoleFunction,
					OfficerUserId, 
					OfficerLastName, 
					OfficerFirstName)
			VALUES ('#rowguid#',
			        '#per#',
			        'Evaluation',
					'#RoleFunction#',
			       	'#SESSION.acc#', 
					'#SESSION.last#', 
					'#SESSION.first#')
		</cfquery>	
		
	 </cfloop>	
	
<cfoutput>	
	<script>
		try {
			parent.pasdialog('#rowguid#');
			parent.document.getElementById("refresh_#url.box#").click();
			parent.ProsisUI.closeWindow('mypasdialog');
		} catch(e) { 
			parent.window.close(); 
			}
	</script>	
</cfoutput>

