

<!--- show the total --->

<cftry>

 <cfset amt = url.quantity * url.price>
 <cfoutput>
	 #numberformat(amt,"__,__.__")#
 </cfoutput>
 
 <cfcatch><font color="FF0000">- invalid -</font></cfcatch> 

</cftry>
