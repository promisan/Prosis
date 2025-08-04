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
<!--- To be called from 1) the init, 2)the onchange method and 3)from the submission --->

<cfparam name="URL.rid"            default="">
<cfparam name="URL.Operation"      default="Calculate">
<cfparam name="URL.ItemMaster"     default="">

<cfoutput>

<cfif NOT ISDEFINED("FORM.CostElement_#URL.ROW#")>
	<cfset vCostList = Evaluate("vCostElement_#URL.ROW#")>
	<cfparam name="FORM.CostElement_#URL.ROW#" default="#vCostList#">
	<cfset prefix = "v">
<cfelse>
	<cfset prefix = "FORM.">
</cfif>

<cfset value = 0>

<cfif URL.rid neq "" and Operation eq "Write">

	  <cfquery name="qInsert" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE ProgramAllotmentRequestPrice
			WHERE  RequirementId = '#URL.rid#'
	  </cfquery>	
	  
</cfif>

<!--- summing up all float values --->
<cfset vList = Evaluate("FORM.CostElement_#URL.ROW#")>

<cfloop list="#vList#" index="element">

	<cfset element = replace(element," ","_","all")>
	
	<cfset mode   = Evaluate("#prefix##Element#_Mode")>
	<cfset number = Evaluate("#prefix##Element#_Number")>
	<cfset number = replace(number,",","","all")>	
	<cfset order = "1">
			
	<cfif URL.Operation eq "Calculate">
	
		<cfif mode eq "2">
			<cfset value += number>
		</cfif>
		
	<cfelse>
		
		  <cfset element = replace(element,"_#URL.Row#","","all")>
		  <cfset element = replace(element,"_"," ","all")>
			  
		  <cfquery name="qInsert" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO ProgramAllotmentRequestPrice
					           (RequirementId
					           ,CostElement
							   ,CostOrder
					           ,Calculation
					           ,CalculationQuantity
					           ,CalculationBase
					           ,CostElementAmount
					           ,CostMemo
					           ,OfficerUserId
					           ,OfficerLastName
					           ,OfficerFirstName)
					     VALUES
					           ('#URL.rid#'
					           ,'#element#'
							   ,'#order#'
					           ,'#mode#'
					           ,'#number#'
					           ,'#number#'
					           ,'#number#'
					           ,''
					           ,'#Session.acc#'
					           ,'#Session.last#'
					           ,'#Session.first#')
			   </cfquery>
				
	</cfif>	
	
</cfloop>

<!---  everything starts with the sum of value --->

<cfif URL.Operation eq "Calculate">

	<cfset qfinal = value>
	
	<cfloop list="#vList#" index="element">
			
		<cfset element = replace(element," ","_","all")>
		<cfset mode    = Evaluate("#prefix##Element#_Mode")>
		<cfset number  = Evaluate("#prefix##Element#_Number")>
		<cfset number  = replace(number,",","","all")>
		<cfset number  = replace(number," ","","all")>
		<cfif number eq "">
			<cfset number = 0>
		</cfif>
		
		<cfif NOT IsNumeric(number)>
			<script>
			alert('Wrong numeric value : #number#');
			</script>
			<cfset number = 0>
		</cfif>	
					
		<cfif mode eq "1">
		    <!--- the percentages will be applied in a cumulative manner --->
			<cfset qfinal = qfinal + (qfinal*number)/100>
		</cfif>		
					
		<cfif mode eq "3">
		    <cfset qfinal = qfinal + number>
		</cfif>

	</cfloop>
				
	<script language="JavaScript">				
		document.getElementById('requestPrice_#URL.row#').value = '#numberformat(qfinal,",.__")#'					
		ptoken.navigate('RequestDialogFormMatrixScript.cfm?row=#url.row#&col=0&rows=20&cols=12','ctotal')									
	</script>
	
</cfif>
	
</cfoutput>
