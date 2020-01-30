
<!---
<cf_screentop height="100%" scroll="yes"   
   user="yes" 
   html="No"
   close="ColdFusion.Window.hide('dialogrequest')">
   --->

<table width="100%" bgcolor="white" height="100%">

<tr><td valign="top" style="padding:13px">
		
   		<cfform method="POST" name="cartform" onsubmit="return false">

   	   		<cfset url.mode = "dialog">
	   		<cfinclude template="StockRequestAdd.cfm"> 
  
   		</cfform>
  
	 </td>
</tr>

</table>
