	<cf_tl id="Request for assignment" var="1">	
	<cfset s = StructNew()> 
	<cfset s.value="req">
    <cfset s.display="<span class='labelmedium'><font color='0080C0'>#lt_text#">
	<cfset s.img="">
	<cfset s.href="javascript:reqlist('','','#mission#')">
	<cfset s.parent="action">	
	<cfset s.leafnode=true/>	
	<cfset arrayAppend(result,s)/>			

	<cf_tl id="Movement Action" var="1">	
	<cfset s = StructNew()> 	
	<cfset s.value="mov">
    <cfset s.display="<span class='labelmedium'><font color='0080C0'>#lt_text#">
	<cfset s.img="">
	<cfset s.parent="action">
	<cfset s.href="javascript:movelist('','','#mission#')">	
	<cfset s.leafnode=true/>	
	<cfset arrayAppend(result,s)/>			
			
	<cf_tl id="Disposal action" var="1">	
	<cfset s = StructNew()> 	
	<cfset s.value="dis">
    <cfset s.display="<span class='labelmedium'><font color='0080C0'>#lt_text#">
	<cfset s.img="">
	<cfset s.parent="action">
	<cfset s.href="javascript:disposallist('','','#mission#')">								
	<cfset s.leafnode=true/>	
	<cfset arrayAppend(result,s)/>		
	
	<cf_tl id="Under Observation" var="1">	
	<cfset s = StructNew()> 	
	<cfset s.value="dis">
    <cfset s.display="<span class='labelmedium'><font color='0080C0'>#lt_text#">
	<cfset s.img="">
	<cfset s.parent="action">
	<cfset s.href="javascript:observationlist('','','#mission#')">								
	<cfset s.leafnode=true/>	
	<cfset arrayAppend(result,s)/>		
		
								
