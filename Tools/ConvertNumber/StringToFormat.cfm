
<cfparam name="Attributes.Value"   Default="">
<cfparam name="Attributes.Format"  Default="">
<cfparam name="Attributes.Prefix"  Default="">

<cfset format = attributes.format>
<cfset myval  = attributes.Value>

<cfif format eq "">

  <cfset myval = "#attributes.Value#">  
  
<cfelse>
			
	<cfloop index="pos" from="1" to="#len(format)#">
			
	<cfset char = mid(format,  pos,  1)>
	
	<cfif char eq "X">
	
	 <!--- do nothing --->
	
	<cfelse>
	
		<cfif len(myval) gte pos>
	
		<cfset myval = insert(char, myval, pos-1)> 
		
		</cfif>
	
	</cfif>
	
	</cfloop>
 	
</cfif>	

<cfset caller.val = "#attributes.prefix##myval#">

 