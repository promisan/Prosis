
<cf_tl id="Receipt and Inspection" var="1">

<cfparam name="url.id" default="RI">
<cfparam name="url.mid" default="">

<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   OrganizationObject
	WHERE  ObjectKeyValue1 = '#url.id#'
	AND    Operational = 1
</cfquery>
		
    <cfif Object.recordcount gte "1">
	
		<cf_screentop height="100%"   
			label         = "#lt_text# #url.id#" 
			title         = "#url.id#"
			banner        = "gray" 
			scroll        = "No"
			bannerforce   = "Yes" 
			layout        = "webapp" 
			line          = "no" 
			html          = "no"
			jquery		  = "yes"
			menuAccess    = "Context"
			systemmodule  = "Procurement"
			FunctionClass = "Window"
			FunctionName  = "Receipt Document">
		
		<cf_layoutscript>
		<cf_textareascript>
		
		<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	  

		<cfparam name="url.summary" default="1">
		
					
		
		<cf_layout attributeCollection="#attrib#">

			<cf_layoutarea 
		          position="header"
				  size="50"
		          name="controltop">	
				  				  
				<cf_ViewTopMenu label="#lt_text# #url.id#" menuaccess="context" background="blue">
						
			</cf_layoutarea>		 
		
		    			
			<cf_layoutarea  position="center" name="box">
			
				<table width="100%" height="100%"><tr><td>	
										
					<cfoutput>		
					<iframe src="ReceiptEditContent.cfm?id=#url.id#&mode=#url.mode#&idmenu=&mid=#url.mid#&header=0" width="100%" height="100%" frameborder="0"></iframe> 
					</cfoutput>
				
					</td>
				</tr>
				</table>
		
			</cf_layoutarea>	
						
			<cf_layoutarea 
				    position="right" 
					name="commentbox" 
					minsize="20%" 
					maxsize="30%" 
					size="380" 
					overflow="yes" 
					initcollapsed="yes"
					collapsible="true" 
					splitter="true">
				
					<cf_divscroll style="height:100%">
						<cf_commentlisting objectid="#Object.ObjectId#"  ajax="No">		
					</cf_divscroll>
					
			</cf_layoutarea>	
			
							
		</cf_layout>	
							
		
	<cfelse>
			
		<cf_screentop height="100%"   
			label         = "#lt_text# #url.id#" 
			title         = "#url.id#"
			banner        = "gray" 
			scroll        = "No"
			bannerforce   = "Yes" 
			layout        = "webapp" 
			line          = "no" 
			html          = "Yes" 
			menuAccess    = "Context"
			systemmodule  = "Procurement"
			FunctionClass = "Window"
			FunctionName  = "Receipt Document">
				
		<!--- #cgi.query_string# --->		
		
		<table width="100%" height="100%"><tr><td>	
			
			<cfoutput>		
			<iframe src="ReceiptEditContent.cfm?id=#url.id#&mode=#url.mode#&idmenu=&mid=#url.mid#&header=0" width="100%" height="100%" frameborder="0"></iframe> 
			</cfoutput>
		
			</td>
		</tr>
		</table>
	
	</cfif>

<cf_screenbottom layout="webapp">
 