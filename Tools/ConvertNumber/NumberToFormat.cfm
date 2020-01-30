
<cfparam name="Attributes.Amount" Default="0">
<cfparam name="Attributes.Present" Default="1">
<cfparam name="Attributes.Format" Default="Number">

<cfif attributes.amount eq "">

  <cfset myval = 0>  
  
<cfelse>
 
    <cfset myval = Attributes.amount>
	
	<cfset myval = ceiling(myval)>
	<!--- expression --->
	<cfset myval = myval/attributes.present>
	
	<!--- format --->
	<cfswitch expression="#Attributes.format#">
	 <cfcase value="Number">
	   <cfset myval = "#numberformat(myval,",__")#.00">
	   <!---
	   <cfset val = "#numberformat(val,"__,__.__")#">
	   --->
	 </cfcase>
	 <cfcase value="Number1">	 
	   <cfset myval = "#numberformat(myval,",__._")#">
	 </cfcase>
	 <cfcase value="Number0">	
	   <cfset myval = "#numberformat(myval,",__")#">
	 </cfcase>
	</cfswitch>
	
</cfif>	

<cfset caller.val = myval>

 