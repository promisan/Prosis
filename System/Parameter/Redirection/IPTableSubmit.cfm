
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="Form.IPRangeStart" default="">
<cfparam name="Form.IPRangeEnd" default="">

<cfif Form.IPRangeEnd eq "">
	<cfset Form.IPRangeStart = "#Form.IPRangeStart#">
</cfif>

<cfset sec1 = 1000000000>
<cfset sec2 = 1000000>
<cfset sec3 = 1000>
<cfset sec4 = 1>
<cfset IPStart = "0">
<cfset IPEnd   = "0">
<cfset row = 0>

<cfloop index="itm" list="#Form.IPRangeStart#" delimiters=".">

	<cfset row = row+1>
	<cfset IPStart = #IPStart#+evaluate("sec"&"#row#")*#itm#>
	
</cfloop>

<cfset row = 0>

<cfloop index="itm" list="#Form.IPRangeEnd#" delimiters=".">

	<cfset row = row+1>
	<cfset IPEnd = #IPEnd#+evaluate("sec"&"#row#")*#itm#>
	
</cfloop>

<cfif Form.Redirect eq "URL">
 <cfset dir = "#Form.ServerURL#">
<cfelse>
 <cfset dir = "DISABLED"> 
</cfif>
	
<cfif URL.ID1 eq "{00000000-0000-0000-0000-000000000000}">

	<cfquery name="Insert" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO stRedirection 
	     	  	   (IPRangeStart,
					IPRangeStartNum,
					IPRangeEnd,
					IPRangeEndNum,
					Mission,
					ServerURL,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName,	
					Created)
	      VALUES ('#Form.IPRangeStart#',
	   		   	  '#IPStart#',
				  '#Form.IPRangeEnd#',
				  '#IPEnd#', 
				  '#Form.Mission#',
				  '#dir#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
	</cfquery>
	
<cfelse>
	
	   <cfquery name="Update" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE stRedirection 
		    SET IPRangeStart      = '#Form.IPRangeStart#',
			    IPRangeStartNum   = '#IPStart#',
			    IPRangeEnd        = '#Form.IPRangeEnd#',
			    IPRangeEndNum     = '#IPEnd#',
			    ServerURL         = '#dir#',
			    OfficerUserId     = '#SESSION.acc#',
			    OfficerLastName   = '#SESSION.last#',
			    OfficerFirstName  = '#SESSION.first#'
		 WHERE  IPRangeId         = '#URL.ID1#'
    	</cfquery>
	
</cfif>
  	
<cfoutput>	
<script>	
	 window.location = "IPTable.cfm?idmenu=#url.idmenu#"	
</script>	
</cfoutput>
   
