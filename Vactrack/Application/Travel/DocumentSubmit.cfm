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
<cfset actionform = 'Travel'>

<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM Parameter 
</cfquery>

<cfquery name="SearchResult" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   stTravel
	WHERE  DocumentNo = '#Object.ObjectKeyValue1#'
	AND    PersonNo   = '#Object.ObjectKeyValue2#'
</cfquery>	

<CF_DateConvert Value="#Form.ArrivalDate#">
<cfset STR = dateValue>
	
<cfset te = DateAdd("h", "#Form.HourArrival#",   "#STR#")> 
<cfset te = DateAdd("m", "#Form.MinuteArrival#", "#te#")>

<cfif form.LumpsumAmount neq "">
	<cfset amt_Lumpsum = replace(Form.LumpsumAmount,',','',"ALL")>
<cfelse>
    <cfset amt_Lumpsum = "0">	
</cfif>

<cfif not IsNumeric(amt_Lumpsum)>

	<cf_message message="Problem, you entered an incorrect amount">
	<cfabort>

</cfif>

<cfif searchresult.recordcount eq 0>

	<cfquery name="Insert" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO stTravel
			 (DocumentNo,
			 PersonNo,
			 ActionForm, 
			 TANumber,
			 ArrivalPlace,
			 ArrivalDateTime,
			 AirlineName,
			 AirlineFlightNo,
			 LumpsumEnabled,
			 LumpsumAmount,
			 EntryUserId,
			 EntryLastName,
			 EntryFirstName,	
			 EntryDate)
	  VALUES ('#Object.ObjectKeyValue1#', 
			  '#Object.ObjectKeyValue2#',			  
			  'Travel',
			  '#Form.TANumber#',
			  '#Form.ArrivalPlace#',
			  #te#,
			  '#Form.AirlineName#',
			  '#Form.AirlineFlightNo#',
			  '#Form.LumpsumEnabled#',
			  '#Form.LumpsumAmount#',
			  '#SESSION.acc#',
			  '#SESSION.last#',		  
			  '#SESSION.first#', 
			  getDate())</cfquery>
	
<cfelse>  

	<cfquery name="Update" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE stTravel
	 SET  	 TANumber         = '#Form.TANumber#',
			 ArrivalPlace     = '#Form.ArrivalPlace#',
			 ArrivalDateTime  = #te#,
			 AirlineName      = '#Form.AirlineName#',
			 AirlineFlightNo  = '#Form.AirlineFlightNo#',
			 LumpsumEnabled   = '#Form.LumpsumEnabled#',
			 LumpsumAmount    = '#Form.LumpsumAmount#'
	WHERE  DocumentNo = '#Object.ObjectKeyValue1#'
	AND    PersonNo   = '#Object.ObjectKeyValue2#'
	</cfquery>
		  
</cfif>	

<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   DISTINCT P.PersonNo
	FROM     Applicant.dbo.Applicant A INNER JOIN
                   Person P ON A.IndexNo = P.IndexNo
	WHERE    A.PersonNo   = '#Object.ObjectKeyValue2#'	
</cfquery>	

<cfif Person.recordcount eq "1">

<cfloop index="itm" list="Passport,UNLP" delimiters=",">

	<cfquery name="Check" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM PersonDocument
	WHERE PersonNo = '#Person.PersonNo#' 
	AND DocumentType  = '#itm#'
	</cfquery>
	
	<cfif #Check.recordcount# gte "1">
		
		 <cfquery name="Edit" 
		   datasource="AppsEmployee" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   DELETE PersonDocument
		   WHERE PersonNo    = '#Person.PersonNo#' 
		   AND DocumentType  = '#itm#' 
		 </cfquery>
		
	</cfif>
	
	<cfset DateEffective     = Evaluate("FORM.#Itm#_DateEffective")>
	<cfset dateValue = "">
	<CF_DateConvert Value="#DateEffective#">
	<cfset STR = #dateValue#>
	
	<cfset DateExpiration    = Evaluate("FORM.#Itm#_DateExpiration")>
	<cfset dateValue = "">
	<CF_DateConvert Value="#DateExpiration#">
	<cfset END = #dateValue#>

	<cfset DocumentReference = Evaluate("FORM.#Itm#_DocumentReference")>
	<cfset Remarks           = Evaluate("FORM.#Itm#_Remarks")>
	<cfset Country     = Evaluate("FORM.#Itm#_Country")>
	
	 <cfquery name="InsertDocument" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO PersonDocument
         (PersonNo,
		 DateEffective,
		 DateExpiration,
		 DocumentType,
		 DocumentReference,
		 IssuedCountry,
		 Remarks,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
      VALUES ('#Person.PersonNo#',
          #STR#,
		  #END#,
		  '#itm#',
		  '#DocumentReference#', 
		  '#Country#',
		  '#Remarks#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#')
	  </cfquery>
	  
</cfloop>

</cfif>