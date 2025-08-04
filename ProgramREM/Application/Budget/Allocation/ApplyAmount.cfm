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

<!--- pass selected fund as a url instead --->

<cfparam name="url.date" default="#dateformat(now(),CLIENT.DateFormatShow)#">

<CF_DateConvert Value="#url.date#">
<cfset DTE = dateValue>

<cfset fdlist = replaceNoCase(url.fdlist,":","'","ALL")> 

<cfoutput>

<cfquery name="Check"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT ObjectCode
	FROM   ProgramAllotmentAllocation
	WHERE  ProgramCode = '#url.programcode#'
	AND    Period      = '#url.period#'
	AND    EditionId   = '#url.editionid#'	
	AND    Fund        = '#url.fund#'	
	AND    ObjectCode  = '#url.ObjectCode#'
</cfquery>

<cfset amount = replace(val,",","","ALL")> 

<cfif isNumeric(amount)>
	
	<cfif check.recordcount eq "0">
	
	    <cftransaction>
		
		
		<cftry>
		
			<cfquery name="insert"
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO ProgramAllotment
				(ProgramCode,
				 Period,
				 EditionId,			
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
				VALUES
				('#url.programcode#',
				 '#url.period#',
				 '#url.editionid#',			
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')
			</cfquery>
		
		<cfcatch></cfcatch>
		
		</cftry>
		
		
		<cfquery name="update"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    INSERT INTO ProgramAllotmentAllocation
			(ProgramCode,
			 Period,
			 EditionId,
			 Fund,
			 ObjectCode,
			 Amount,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
			VALUES
			('#url.programcode#',
			 '#url.period#',
			 '#url.editionid#',
			 '#url.fund#',
			 '#url.ObjectCode#',
			 '#amount#',
			 '#SESSION.acc#',
			 '#SESSION.last#',
			 '#SESSION.first#')
		</cfquery>
		
			
		<!--- detail --->
		
		<cfquery name="update"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    INSERT INTO ProgramAllotmentAllocationDetail
			(ProgramCode,
			 Period,
			 EditionId,
			 Fund,
			 ObjectCode,
			 DateAllocation,
			 Amount,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
			VALUES
			('#url.programcode#',
			 '#url.period#',
			 '#url.editionid#',
			 '#url.fund#',
			 '#url.ObjectCode#',
			 #dte#,
			 '#amount#',
			 '#SESSION.acc#',
			 '#SESSION.last#',
			 '#SESSION.first#')
		</cfquery>
				
		</cftransaction>
	
	<cfelse>
	
	    <cftransaction>
		
		<!---
		
		<cfquery name="CleanSame"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    DELETE FROM ProgramAllotmentAllocationDetail			
			WHERE  ProgramCode    = '#url.programcode#'
			AND    Period         = '#url.period#'
			AND    EditionId      = '#url.editionid#'	
			AND    Fund           = '#url.fund#'	
			AND    ObjectCode     = '#url.ObjectCode#'
			AND    Created        = #dte#
		</cfquery>
		
		--->
		
		
		
		<cfquery name="Total"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT SUM(Amount) as Amount
			FROM   ProgramAllotmentAllocationDetail			
			WHERE  ProgramCode = '#url.programcode#'
			AND    Period      = '#url.period#'
			AND    EditionId   = '#url.editionid#'	
			AND    Fund        = '#url.fund#'	
			AND    ObjectCode  = '#url.ObjectCode#'			
		</cfquery>
		
		<cfif total.amount eq "">
		    <cfset diff = amount>
		<cfelse>
			<cfset diff = amount - total.amount>
		</cfif>	
							
		<cfquery name="UpdateHeader"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE ProgramAllotmentAllocation
			SET    Amount      = '#amount#'
			WHERE  ProgramCode = '#url.programcode#'
			AND    Period      = '#url.period#'
			AND    EditionId   = '#url.editionid#'	
			AND    Fund        = '#url.fund#'	
			AND    ObjectCode  = '#url.ObjectCode#'
		</cfquery>
		
		<!--- detail --->
		
		<cfif diff neq "0">
		
			<cfquery name="update"
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO ProgramAllotmentAllocationDetail
				(ProgramCode,
				 Period,
				 EditionId,
				 Fund,
				 ObjectCode,
				 DateAllocation,
				 Amount,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
				VALUES
				('#url.programcode#',
				 '#url.period#',
				 '#url.editionid#',
				 '#url.fund#',
				 '#url.ObjectCode#',
				 #dte#,
				 '#diff#',
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')
			</cfquery>
			
		</cfif>		
		
		</cftransaction>
		
	</cfif>
		
	<script>		
		document.getElementById('amt_#url.programcode#_#url.fund#_#url.ObjectCode#').value = "#numberformat(amount,',__')#" 
	</script>
	
	<!--- column --->	
	<cfquery name="SubTotal"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT SUM(Amount) as Total
		FROM   ProgramAllotmentAllocation
		WHERE  ProgramCode = '#url.programcode#'
		AND    Period      = '#url.period#'
		AND    EditionId   = '#url.editionid#'	
		AND    Fund        = '#url.fund#'	
		AND    Fund IN (#preservesingleQuotes(fdlist)#)
		<!--- AND    ObjectCode  = '#url.ObjectCode#' --->
	</cfquery>
		
	<script>		
		 document.getElementById('tot_#url.programcode#_#url.fund#').innerHTML = "#numberformat(subtotal.total,'__,__')#"
	</script>
		
	<!--- column --->	
	<cfquery name="SubTotal"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT SUM(Amount) as Total
		FROM   ProgramAllotmentAllocation
		WHERE  Period      = '#url.period#'
		AND    EditionId   = '#url.editionid#'	
		AND    Fund        = '#url.fund#'	
		AND    Fund IN (#preservesingleQuotes(fdlist)#)
		<!--- AND    ObjectCode  = '#url.ObjectCode#' --->
	</cfquery>
	

	<script>		
		 document.getElementById('tot__#url.fund#').innerHTML = "#numberformat(subtotal.total,'__,__')#"
	</script>
	
	<!--- row --->	
	<cfquery name="SubTotal"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT SUM(Amount) as Total
		FROM   ProgramAllotmentAllocation
		WHERE  ProgramCode = '#url.programcode#'
		AND    Period      = '#url.period#'
		AND    EditionId   = '#url.editionid#'	
		AND    ObjectCode  = '#url.ObjectCode#' 
		AND    Fund IN (#preservesingleQuotes(fdlist)#)
	</cfquery>
	
	<script>	
	      try {	
		 document.getElementById('tot_#url.programcode#__#url.objectcode#').innerHTML = "#numberformat(subtotal.total,'__,__')#"
		 } catch(e) {}
	</script>
	
	<!--- program --->	
	<cfquery name="SubTotal"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT SUM(Amount) as Total
		FROM   ProgramAllotmentAllocation
		WHERE  ProgramCode = '#url.programcode#'
		AND    Period      = '#url.period#'
		AND    EditionId   = '#url.editionid#'		
		AND    Fund IN (#preservesingleQuotes(fdlist)#)	
	</cfquery>
	
	<script>	
	     try {	
		 document.getElementById('tot_#url.programcode#').innerHTML = "#numberformat(subtotal.total,'__,__')#"
		 } catch(e) {}
	</script>
	
	<!--- program --->	
	<cfquery name="SubTotal"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT SUM(Amount) as Total
		FROM   ProgramAllotmentAllocation
		WHERE  Period      = '#url.period#'
		AND    EditionId   = '#url.editionid#'		
		AND    Fund IN (#preservesingleQuotes(fdlist)#)	
	</cfquery>
	
	<script>	
	     try {	
		 document.getElementById('tot').innerHTML = "<b>#numberformat(subtotal.total,'__,__')#"
		 } catch(e) {}
	</script>
	
	<!--- update the screen --->
	
<cfelse>
	
	<script>
	alert("Invalid amount")
	</script>

</cfif>	

</cfoutput>
