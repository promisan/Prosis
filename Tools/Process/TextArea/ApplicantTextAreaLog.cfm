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
<cfquery name="Check" 
    datasource="appsSelection" 
    username="#SESSION.login#" 
  	password="#SESSION.dbpw#">
   	 SELECT *
	 FROM   #Attributes.table#Action
	 WHERE  #attributes.Key01# = '#Attributes.Key01Value#'
			  <cfif Attributes.Key02 neq "">
	  AND   #attributes.Key02# = '#Attributes.Key02Value#'
		  </cfif>
	  <cfif Attributes.Key03 neq "">
	  AND   #attributes.Key03# = '#Attributes.Key03Value#'
	  </cfif>
	  AND    LanguageCode = '#Attributes.languagecode#'
	  AND    TextAreaCode = '#Code#'
	  ORDER BY CREATED DESC 
</cfquery>	 	  

<cfif currentrow eq "1">
	
	<cfquery name="Last" 
	      datasource="appsSelection" 
	      username="#SESSION.login#" 
	  	  password="#SESSION.dbpw#">
	   	  SELECT MAX(SerialNo) as Ser
		  FROM   #Attributes.table#Action
		  WHERE  #attributes.Key01# = '#Attributes.Key01Value#'
				  <cfif Attributes.Key02 neq "">
		  AND    #attributes.Key02# = '#Attributes.Key02Value#'
			     </cfif>
		  <cfif Attributes.Key03 neq "">
		  AND    #attributes.Key03# = '#Attributes.Key03Value#'
		  </cfif>	  
	</cfquery>	 	  
	
	<cfif last.ser eq "">
	   <cfset no = 1>
	<cfelse>
	   <cfset no = last.ser+1>
	</cfif>

</cfif>

<cfquery name="InsertNotesLog" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

	INSERT INTO #Attributes.table#Action
		 (
		  #Attributes.Key01#,	
		  <cfif Attributes.Key02 neq "">#Attributes.Key02#,</cfif>  
		  <cfif Attributes.Key03 neq "">#Attributes.Key03#,</cfif>  
		  <cfif Attributes.Attribute01 neq "">#Attributes.Attribute01#,</cfif>
		  <cfif Attributes.Attribute02 neq "">#Attributes.Attribute02#,</cfif>
		  SerialNo,
		  ActionCode,
		  LanguageCode, 
		  TextAreaCode,
		  #attributes.fieldoutput#, 
		  OfficerUserId, 
		  OfficerLastName,  
		  OfficerFirstName		  
		  )
	  VALUES (
	    	  '#Attributes.Key01Value#',	
			  <cfif Attributes.Key02 neq "">'#Attributes.Key02Value#',</cfif>
			  <cfif Attributes.Key03 neq "">'#Attributes.Key03Value#',</cfif>
	          <cfif Attributes.Attribute01 neq "">'#Attributes.Attribute01Value#',</cfif>
			  <cfif Attributes.Attribute02 neq "">'#Attributes.Attribute02Value#',</cfif>
			  '#no#',	  
			  '#Attributes.ActionCode#',
			  '#languagecode#',
			  '#Code#',
			  '#Text#',					  
			  '#SESSION.acc#', 
			  '#SESSION.last#', 
			  '#SESSION.first#'					 
			   )
</cfquery>
