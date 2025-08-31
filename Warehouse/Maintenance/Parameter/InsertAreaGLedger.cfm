<!--
    Copyright © 2025 Promisan B.V.

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
<cfquery name="Check" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_AreaGLedger
WHERE   Area = '#Attributes.Area#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_AreaGLedger
	       (Area,Description,AccountClass,ListingOrder) 
	VALUES ('#Attributes.Area#',
	        '#Attributes.Description#',
			'#Attributes.AccountClass#',
			'#Attributes.Order#')
	</cfquery>
	
<cfelse>
	
	<cfquery name="Check" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE  Ref_AreaGLedger
	SET     ListingOrder = '#Attributes.Order#',
	        AccountClass = '#Attributes.AccountClass#',
			Description  = '#Attributes.Description#'
	WHERE   Area = '#Attributes.Area#'
	</cfquery>

			
</cfif>

