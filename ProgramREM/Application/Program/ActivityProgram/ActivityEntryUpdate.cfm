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
<!--- removed updating of record creation information 30/04/2004 krw --->

<cfoutput>
<link href="#SESSION.root#/#client.style#" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="#SESSION.root#/print.css" media="print">
</cfoutput>
<div class="screen">

<cfoutput>

<cfif Len(#Form.ActivityDescription#) gt 300>
	 <cf_message message = "You entered a description that exceeds the allowed size of 300 characters."
	  return = "back">
	  <cfabort>
</cfif>

<cfparam name="Form.LocationCode" default="">

<cftransaction action="BEGIN">

<!--- Convert Date to correct format --->
 <cfset dateValue = "">
 <CF_DateConvert Value="#Form.ActivityDate#">
 <cfset ActDate = #dateValue#>
 
 <cfif Form.ActivityDateStart neq "">
 <cfset dateValue = "">
 <CF_DateConvert Value="#Form.ActivityDateStart#">
    <cfset ActDateStart = #dateValue#>
 <cfelse>
    <cfset ActDateStart = ''>
 </cfif>
 
   <cfquery name="UpdateActivity" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE ProgramActivity
	 
         SET ProgramCode    = '#Form.ProgramCode#',
			 <cfif #Form.ActivityDateStart# neq "">
    		 ActivityDateStart  = #ActDateStart#, 
			 </cfif>
			 ActivityDescription      = '#Form.ActivityDescription#',
			 ActivityDescriptionShort = '#Form.ActivityDescriptionShort#',
		     ActivityDate             = #ActDate#, 
     	     ActivityPeriod           = '#Form.Period#',
		 	 Reference                = '#Form.Reference#',
		     OrgUnit                  = '#Form.OrgUnit#',
		     LocationCode             = '#Form.LocationCode#',
			 ListingOrder             = '#Form.ListingOrder#',
		     OfficerUserId            = '#SESSION.acc#'
		
	  WHERE ActivityID = '#URL.ActivityID#'
	</cfquery>
	
	<cfset vThisActivity = URL.ActivityID>
	<cfinclude template="ActivitySchemaSubmit.cfm">
	
<!--- delete all activitiesclasses for this activity --->

<cfquery name="RemoveClasses"
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	DELETE FROM ProgramActivityClass
		Where ActivityID = '#URL.ActivityID#'
</cfquery>

<!--- If classes to add, loop through Activity class elelments and add to Activity Class table --->

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
		OfficerFirstName,
		Created)
	Values (
        '#Form.ProgramCode#',
     	'#Form.Period#',
		'#URL.ActivityID#',
		'#Item#',
		'#SESSION.acc#',
    	'#SESSION.last#',		  
	  	'#SESSION.first#',
		'#DateFormat(Now(),CLIENT.dateSQL)#')
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
	Key3Value      = "#URL.ActivityID#">
 	 		  	
	<script>	 
	window.location="ActivityView.cfm?ProgramCode=#Form.ProgramCode#&Period=#Form.Period#";		 
	</script>	
	
</cfoutput>	   
	

