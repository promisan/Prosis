
<cfset rows = ceiling((url.height-110)/17)>

<cfparam name="url.mde" default="default">

<cfset pages   = Ceiling(total/rows)>
<cfif pages lt "1">
     <cfset pages = '1'>
</cfif>

<cfoutput>
	
	<input type="hidden" name="pages" id="pages" value="#pages#">
	<input type="hidden" name="total" id="total" value="#rows#">
	
	<cfif pages gte "2" or url.mde neq "pending">
	
	  	<select name="page" id="page" size="1" class="regularxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver" onChange="stocktransfer('n','#url.systemfunctionid#')">
	    <cfloop index="Item" from="1" to="#pages#" step="1">
	        <cfoutput><option value="#Item#"><cf_tl id="Page"> #Item# <cf_tl id="of"> #pages#</option></cfoutput>
	   	</cfloop>	 
	   </select>   
	
	 <cfelse>
	
		<input type="hidden" name="page" id="page" value="1">					 
				
	 </cfif>	
	 
</cfoutput>	