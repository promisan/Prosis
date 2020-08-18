
<cf_screentop height="100%" scroll="No" html="No" jquery="Yes" title="Miscellaneous entry" menuaccess="context">

<cfquery name="Object" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
    	SELECT *
	    FROM   OrganizationObject
		WHERE  ObjectKeyValue4 = '#URL.id1#'
		AND    ObjectKeyValue1 = '#url.id#'		
		AND    Operational = 1
</cfquery>
	
<cf_layoutscript>

<cfif Object.recordcount eq "1">
	<cf_textareascript>
</cfif>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea 
          position="header"
		  size="50"
          name="controltop">	
		  
		<cf_ViewTopMenu label="Miscellaneous Cost" menuaccess="context" background="blue">
				
	</cf_layoutarea>		 

	<cf_layoutarea  position="center" name="box">
					
	     <cf_divscroll style="height:98%">		
		 		<cfset url.header = "0"> 
			     <cfinclude template="MiscellaneousEdit.cfm">	
		 </cf_divscroll>

	</cf_layoutarea>	
	
	<cfif Object.recordcount eq "1">
	
		<cf_layoutarea 
		    position="right" name="commentbox" minsize="20%" maxsize="30%" size="380" overflow="yes" collapsible="true" splitter="true">
		
			<cf_divscroll style="height:100%">
				<cf_commentlisting objectid="#Object.ObjectId#"  ajax="No">		
			</cf_divscroll>
			
		</cf_layoutarea>	
	
	</cfif>	
		
</cf_layout>			  