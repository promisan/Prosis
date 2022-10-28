
	<cf_tl id="Advanced Search" var="1">
	<cfset s = StructNew()> 
	<cfset s.value = "Advanced"> 
	<cfset s.display = "<span class='labelit'>#lt_text#</span>"> 
	<cfset s.parent  = "Special">
	<cfset s.href    = "javascript:listshow('LOC','','#mission#')">
	<cfset s.leafnode=true/>	
	<cfset arrayAppend(result,s)/>			
	
	<cf_tl id="Received" var="1">
	<cfset s = StructNew()> 
	<cfset s.value = "today"> 
	<cfset s.display = "<span class='labelit'>#dateformat(now(), CLIENT.DateFormatShow)# : #lt_text#</span>"> 
	<cfset s.parent  = "Special">
	<cfset s.href    = "javascript:listshow('TOD','','#mission#')">
	<cfset s.img     = "">
	<cfset s.leafnode=true/>	
	<cfset arrayAppend(result,s)/>		
	
	<cf_tl id="Recorded" var="1">
	<cfset s = StructNew()> 
	<cfset s.value = "entered"> 
	<cfset s.display = "<span class='labelit'>#dateformat(now(), CLIENT.DateFormatShow)# : #lt_text#</span>"> 
	<cfset s.parent  = "Special">
	<cfset s.href    = "javascript:listshow('REC','','#mission#')">
	<cfset s.img     = "">
	<cfset s.leafnode=true/>	
	<cfset arrayAppend(result,s)/>		
	