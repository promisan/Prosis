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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfif Len(#Form.ActivityDescription#) gt 300>
	 <cf_message message = "You entered a description that exceeds the allowed size of 300 characters."
	  return = "back">
	  <cfabort>
</cfif>

<cfoutput>

<cfquery name="Parameter" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
	    FROM Parameter
</cfquery>

<cfparam name="Form.LocationCode" default="">

<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
		
	<cfset No = #Parameter.ActivityNo#+1>
	<cfif No lt 10000>
	     <cfset No = 10000+#No#>
	</cfif>
				
	<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE Parameter
		SET ActivityNo = '#No#' 
	</cfquery>
	
</cflock>
	
<cftransaction action="begin">	

<!--- Convert Date to correct format --->
 <cfset dateValue = "">
 <CF_DateConvert Value="#Form.ActivityDate#">
 <cfset ActDate = #dateValue#>

 <cfif #Form.ActivityDateStart# neq "">
 <cfset dateValue = "">
 <CF_DateConvert Value="#Form.ActivityDateStart#">
    <cfset ActDateStart = #dateValue#>
 <cfelse>
    <cfset ActDateStart = ''>
 </cfif>
	 	 
   <cfquery name="InsertActivity" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ProgramActivity
         (ProgramCode,
		 ActivityId,
		 <cfif #ActDateStart# neq "">
		 ActivityDateStart, 
		 </cfif>
		 ActivityDate, 
		 ActivityDescription,
		 ActivityDescriptionShort,
		 ActivityPeriod,
		 Reference,
		 OrgUnit,
		 LocationCode,
		 ListingOrder,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,
		 Created)
      VALUES (
          '#Form.ProgramCode#',
		  '#No#',
		  <cfif ActDateStart neq "">
		  #ActDateStart#,
		  </cfif>
		  #ActDate#,
		  '#Form.ActivityDescription#',
		  '#Form.ActivityDescriptionShort#',
		  '#Form.Period#',
		  '#Form.Reference#',
		  '#Form.OrgUnit#',
		  '#Form.LocationCode#',
		  '#Form.ListingOrder#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  '#DateFormat(Now(),CLIENT.dateSQL)#')
	</cfquery>
	
	<cfset vThisActivity = No>
	<cfinclude template="ActivitySchemaSubmit.cfm">
			
<!--- Loop through Activity class elelments and add to Activity Class table --->

<CFParam Name="Form.ActivityClass" Default=" ">

<cfif Form.ActivityClass neq "">

<cfloop index="Item" 
        list="#Form.ActivityClass#" 
        delimiters="' ,">

  <cfquery name="InsertClass" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ProgramActivityClass
	 	(ProgramCode,
		ActivityPeriod,
		ActivityId,
		ActivityClass,
		OfficerUserId,
		OfficerLastName,
		OfficerFirstName)
	Values (
        '#Form.ProgramCode#',
     	'#Form.Period#',
		#No#,
		'#Item#',
		'#SESSION.acc#',
    	'#SESSION.last#',		  
	  	'#SESSION.first#')
	</cfquery> 
		
</cfloop> 

</cfif>

</cftransaction>

<!--- makes language entry --->

	<cf_LanguageInput
	TableCode      = "ProgramActivity" 
	Mode           = "Save"
	Name1          = "ActivityDescription"
	Key1Value      = "#Form.ProgramCode#"
	Key2Value      = "#Form.Period#"
	Key3Value      = "#No#">
 	
		  	
	<script>
	 
	window.location="../ActivityProgramOutput/ActivityOutputEntry.cfm?ProgramCode=#Form.ProgramCode#&Period=#Form.Period#&ActivityId=#No#";
		 
	</script>
		
</cfoutput>	   
	

