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

	<cfset final = value>
	
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
			<cfset final = final + (final*number)/100>
		</cfif>		
					
		<cfif mode eq "3">
		    <cfset final = final + number>
		</cfif>

	</cfloop>
				
	<script language="JavaScript">				
		document.getElementById('requestPrice_#URL.row#').value = '#numberformat(final,",.__")#'				
		ptoken.navigate('RequestDialogFormMatrixScript.cfm?row=#url.row#&col=0&rows=20&cols=12','ctotal')							
	</script>
	
</cfif>
	
</cfoutput>
