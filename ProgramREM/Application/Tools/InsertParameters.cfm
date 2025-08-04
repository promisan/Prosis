<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

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