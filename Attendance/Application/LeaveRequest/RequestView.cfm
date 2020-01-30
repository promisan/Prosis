<cfparam name="url.mycl"   default="1">


	<cfif url.mycl eq "1">
		<cf_screentop jquery="Yes" banner="gray" height="100%" title="Submitted leave request"  scroll="no" html="No" layout="webapp" menuaccess="context">
	<cfelse>
		<cf_screentop title="Submitted leave request" height="100%" jquery="Yes" scroll="yes" html="Yes" menuaccess="context">
	</cfif>


<cfajaximport tags="cfwindow">

<cfparam name="url.action" default="0">

<cf_dialogPosition>

<cfif url.mycl eq "1">
	
	<cf_layoutscript>
	<cf_textareascript>
	<cf_PresentationScript>
	
	<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>
	
	<cf_layout attributeCollection="#attrib#">
	
		<cf_layoutarea 
	          position="header"			  
	          name="controltop">	
			  
			<cf_ViewTopMenu label="Submitted leave request" menuaccess="context" background="blue" systemModule="Attendance">
					
		</cf_layoutarea>	
		
		<cf_layoutarea 
		    position="right" name="commentbox" minsize="20%" maxsize="30%" size="350" overflow="yes" initcollapsed="false" collapsible="true" splitter="true">
		
			<cf_divscroll style="height:99%">			
				<cf_commentlisting objectid="#url.id#"  ajax="No">		
			</cf_divscroll>
			
		</cf_layoutarea>		 
	
		<cf_layoutarea  position="center" name="box">
			
		     <cf_divscroll style="height:99%">
			 
			 <table style="width:100%;height:99%">
			   <tr>
			   <td style="padding-left:5px" valign="top"><cfinclude template="RequestViewContent.cfm">				   
			  </td></tr>
			  </table> 		
			 					
			</cf_divscroll>	
			
		</cf_layoutarea>			
			
	</cf_layout>

<cfelse>

	    <!--- normal mode --->			
		<cfinclude template="RequestViewContent.cfm">
			
</cfif>

