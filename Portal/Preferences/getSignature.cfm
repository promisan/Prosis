
<!--- get signature --->

<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   UserNames 
	WHERE  PersonNo <> '' and ApplicantNo is NULL
	-- WHERE  Account = '#SESSION.acc#'
</cfquery>

<cfif get.PersonNo neq "">
	
	<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Person
		WHERE  PersonNo = '#get.PersonNo#'
	</cfquery>
		
	<cfquery name="Function" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT      P.FunctionDescription, O.OrgUnitName, O.Mission, M.MissionName
		FROM        PersonAssignment AS PA INNER JOIN
	                Position AS P ON PA.PositionNo = P.PositionNo INNER JOIN
	                Organization.dbo.Organization AS O ON PA.OrgUnit = O.OrgUnit inner join
					Organization.dbo.Ref_Mission M ON O.Mission = M.Mission
		WHERE       PA.PersonNo = '#get.PersonNo#' 
		AND         PA.Incumbency > 0 
		AND         PA.AssignmentStatus IN ('0','1')
		ORDER BY    PA.DateEffective DESC
	</cfquery>	
	
	<cfquery name="Address" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		SELECT        PA.AddressId, A.Address, A.Address2, A.AddressCity, A.AddressRoom, A.eMailAddress, A.Country, A.AddressPostalCode
		FROM          PersonAddress AS PA INNER JOIN
		              System.dbo.Ref_Address AS A ON PA.AddressId = A.AddressId
		WHERE         PA.PersonNo = '#get.PersonNo#' 
		AND           PA.AddressType = 'Office'
		ORDER BY      PA.Created DESC
	</cfquery>
	
	<cfoutput>
	<cfsavecontent variable="block">
	<table border="0" cellpadding="0" cellspacing="0">
		<tbody>
			<tr><td><span style="font-size:12px">#Person.FirstName# #Person.LastName#</span></td></tr>
			<tr><td><span style="font-size:12px">#Function.FunctionDescription#,&nbsp;#Function.MissionName#,&nbsp;#Function.OrgUnitName#</span></td></tr>
			<tr><td><span style="font-size:12px">#Address.Address#, #Address.Address2#,&nbsp;#Address.AddressCity#, #Address.Country#&nbsp;#Address.AddressPostalCode#</span></td></tr>
			<tr><td><span style="font-size:12px">Room:&nbsp;&nbsp;#Address.AddressRoom#</span></td></tr>
			<tr><td><span style="font-size:12px">Tel:&nbsp;&nbsp;999-999-99999</span></td></tr>			
			<tr><td><span style="font-size:12px">Email:&nbsp;&nbsp;#get.eMailAddress#</span></td></tr>
		</tbody>
	</table>	
	</cfsavecontent>	
	
	<cf_textarea height="180"  width="520"  
				color="ffffff"
				toolbar="mini"	
				init="yes"
				resize="false"
				id="block"					
				name="Pref_SignatureBlock">#block#</cf_textarea>
				
	</cfoutput>			

	<cfset ajaxonload("initTextArea")>

</cfif>