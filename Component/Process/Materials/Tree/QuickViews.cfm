	<cf_tl id="Equipment Class" var="1">	
	<cfset s = StructNew()> 
	<cfset s.value="Class">
    <cfset s.display="<font face='Calibri' size='3' color='gray'>#lt_text#">
	<cfset s.parent="QuickViews">
	<cfset s.leafnode = true/>
	<cfset arrayAppend(result,s)/>
	
	<cf_tl id="Unit" var="1">	
	<cfset s = StructNew()> 
	<cfset s.value="Organization">
    <cfset s.display="<font face='Calibri' size='3' color='gray'>#lt_text#">
	<cfset s.parent="QuickViews">
	<cfset s.leafnode = true/>
	<cfset arrayAppend(result,s)/>	
	
		
	<cf_tl id="Location" var="1">	
	<cfset s = StructNew()> 
	<cfset s.value="Location">
    <cfset s.display="<font face='Calibri' size='3' color='gray'>#lt_text#">
	<cfset s.parent="QuickViews">
	<cfset s.leafnode = true/>
	<cfset arrayAppend(result,s)/>	