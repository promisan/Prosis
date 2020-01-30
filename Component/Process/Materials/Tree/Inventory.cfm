	<cf_tl id="Missing Items" var="1">	
	<cfset s = StructNew()> 
	<cfset s.value="mis">
	<cfset s.display="<span class='labelit'>#lt_text#">
	<cfset s.img="">
	<cfset s.parent="barscan">											
	<cfset s.leafnode=true/>
	<cfset arrayAppend(result,s)/>		
	
