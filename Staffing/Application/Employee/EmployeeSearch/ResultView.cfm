
<cf_screentop html="no" height="100%" jQuery="Yes" label="Employee Inquiry">

<cf_layoutScript>

<cfparam name="URL.Mission" default="All">
<cfparam name="URL.ID" default=""> 
<cfif URL.ID neq "">
  <cfset CLIENT.form = URL.ID>
</cfif>

<cfoutput>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	

<cf_layout attributeCollection="#attrib#">			

	<cf_layoutarea 
	   	position  = "header"
	   	name      = "reqtop">	
			  		
		<cf_ViewTopMenu label="Search results" background="yellow">
			 			  
	</cf_layoutarea>	
	
	<cf_layoutarea  position="left"
	     name="tree" 
		 overflow="hidden" 
		 maxsize="280" 
		 size="280" 
		 collapsible="true" 
		 splitter="true">
	
		<iframe name="left"
	        id="left"
	        width="100%"
	        height="100%"
			src="SearchTree.cfm?ID=1&ID1=#URL.ID#&ID2=B&ID3=GEN&mid=#mid#"
	        scrolling="no"
	        frameborder="0"></iframe>
				
	</cf_layoutarea>
	
	<cf_layoutarea  position="center" name="box">
			
			<iframe name="right" id="right" width="100%" height="100%" scrolling="no"
		         src="ResultListing.cfm?ID=GEN&ID1=#URL.ID#&ID2=B&ID3=GEN&mid=#mid#" frameborder="0"></iframe>
								
	</cf_layoutarea>			
			
</cf_layout>

</cfoutput>


