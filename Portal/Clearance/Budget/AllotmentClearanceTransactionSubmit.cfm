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
<cfset st = "0">

<cf_busy message="Updating....">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="URL.Status" default="0">

<cftransaction>

<cfset program     = Evaluate("FORM.Program")>
<cfset edition      = Evaluate("FORM.Edition")>
<cfset fund        = Evaluate("FORM.Fund")>

<!--- delete any headers and detail with status = '0' --->

<cfquery name="DeleteOldHeader" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE from ProgramAllotment
	WHERE      ProgramCode = '#program#'
	AND 	   Status = '0'
 </cfquery>

<cfquery name="DeleteOldDetail" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE from ProgramAllotmentDetail
	WHERE      ProgramCode = '#program#'
	AND 	   Status = '0'
 </cfquery>

<!--- now create headers status = 1 if header doesn't exist --->
 
  <cfquery name="Check" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM       ProgramAllotment
	WHERE      ProgramCode = '#program#'	   
	AND        EditionId = '#edition#'
  </cfquery>
  
<cfif Check.recordcount eq "0">

	  <cfquery name="Insert" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ProgramAllotment
			(ProgramCode, 
			EditionId,
			Status,
			OfficerUserId, 
			OfficerLastName, 
			OfficerFirstName, 
			Created)
		Values 
			('#Program#', 
			'#Edition#', 
			'1',
			'#SESSION.acc#', 
			'#SESSION.last#', 
			'#SESSION.first#', 
			getDate())
	  </cfquery>

 </cfif>
 

<!--- loop through all the potentially changed fields in the entry screen --->
<cfloop index="rec" from="1" to="#CLIENT.ObjectNo#" step="1">

	<!--- evaluate the value --->
	<cfif IsDefined("FORM.Check_"&#Rec#)>
		
		<cfset object  = Evaluate("FORM.Object_" & #Rec#)>
		<cfset amount  = Evaluate("FORM.Amount_" & #Rec#)>
		
   	<!--- insert transaction --->
		<cfquery name="InsertTransactiond" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO ProgramAllotmentDetail
			(ProgramCode, 
			 EditionId,
			 TransactionDate, 
			 Amount,
			 ObjectCode,
			 Status,
			 OfficerUserId, 
			 OfficerLastName, 
			 OfficerFirstName, 
			 Created)
			Values ('#program#', 
			        '#edition#', 
					getDate(), 
					#amount#*1000,
					'#Object#',
					'1',
					'#SESSION.acc#', 
					'#SESSION.last#', 
					'#SESSION.first#', 
					getDate()
	    			)
		  </cfquery>  

	</cfif> 
  
</cfloop> 

</cftransaction>

<cfoutput>

	<script language="JavaScript">
	
	    window.close();
		<cfif st eq "1">
		    opener.history.go()
		</cfif>
		
	</script>


</cfoutput>
