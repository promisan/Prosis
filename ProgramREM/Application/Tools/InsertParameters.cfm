
<cfquery name="SubPeriod" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_SubPeriod
</cfquery>

<cfif SubPeriod.recordcount eq "0">

<cfquery name="Insert" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_SubPeriod
	       (SubPeriod, Description, DescriptionShort)
	VALUES ('01', 'Default', '')
	</cfquery>
</cfif>

<cfquery name="Check" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_IndicatorType
WHERE  Code = '0001' 
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_IndicatorType
	       (Code, 
		    Description, Memo, OfficerUserId, OfficerLastName, OfficerFirstName)
	VALUES ('0001',
	        'Absolute number', 'Absolute number of staff, visits. Amount of money etc.','#SESSION.acc#', '#SESSION.last#','#SESSION.first#')
	</cfquery>
	
</cfif>

<cfquery name="Check" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_IndicatorType
WHERE  Code = '0002' 
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_IndicatorType
	       (Code, 
		    Description, Memo, OfficerUserId, OfficerLastName, OfficerFirstName)
	VALUES ('0002',
	        'Calculated (ratio)', 'Percentage, average, standard deviation etc.', '#SESSION.acc#', '#SESSION.last#','#SESSION.first#')
	</cfquery>
	
</cfif>