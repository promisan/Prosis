

<cf_tl id="Personnel Event" var="1">

<cfparam name="url.ajaxid" default="">
<cfparam name="url.id" default="#url.ajaxid#">

<cfquery name="Object" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
    	SELECT *
	    FROM   OrganizationObject
		WHERE  ObjectId = '#URL.id#'
		AND    Operational = 1
</cfquery>


<cfif Object.recordcount eq "1">

	<cfset url.ajaxid = Object.ObjectId>
	
	<cfif Object.ObjectKeyValue4 neq "">
		
		<cfquery name="Get" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
		    	SELECT   *
			    FROM     PersonEvent E LEFT OUTER JOIN Ref_PersonEvent O ON O.Code = E.EventCode
				WHERE    EventId = '#Object.ObjectKeyValue4#' 
		</cfquery>
		
		<cfset eventid = Object.ObjectKeyValue4>
	
	<cfelse>
	
		<cfquery name="Get" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
		    	SELECT   *
			    FROM     PersonEvent E LEFT OUTER JOIN Ref_PersonEvent O ON O.Code = E.EventCode
				WHERE    EventId = '#Object.ObjectId#' 
		</cfquery>
		
		<cfset eventid = Object.ObjectId>
	
	</cfif>
				
<cfelse>
	
	<cfquery name="Object" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
    	SELECT *
	    FROM   OrganizationObject
		WHERE  ObjectKeyValue4 = '#URL.id#'
		AND    Operational = 1
	</cfquery>
		
	<cfset url.ajaxid = Object.ObjectId>
		
	<cfquery name="Get" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
	    	SELECT  *
		    FROM    PersonEvent E LEFT OUTER JOIN Ref_PersonEvent O ON  O.Code = E.EventCode
			WHERE   EventId = '#URL.id#'
	</cfquery>
	
	<cfset eventid = url.id>	

</cfif>

<cf_screenTop jQuery="Yes" height="100%" border="0" html="No" title="#lt_text#  #get.Mission#" scroll="no" MenuAccess="Context"> 

<cfoutput>

<cf_textareascript>
<cfajaximport tags="cfdiv,cfform">
<cf_ActionListingScript>
<cf_FileLibraryScript mode="standard">
<cf_PresentationScript>

<cf_layoutscript>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea 
          position="header"
		  size="50"
          name="controltop">	
		  
		<cf_ViewTopMenu label="Personnel Event" menuaccess="context" background="blue" systemModule="Accounting">
				
	</cf_layoutarea>		 

	<cf_layoutarea  position="center" name="box">
		
	     <cf_divscroll style="height:99%">
		 						
			<cfset wflnk = "#session.root#/Staffing/Application/Employee/Events/EventWorkflow.cfm">
   
 			   <input type="hidden" 
		          id="workflowlink_#url.ajaxid#" 
        		  value="#wflnk#">  
			
			<table width="97%" align="center">
				<tr><td style="padding-top:5px;padding-left:5px;padding-right:5px"><cfinclude template="EventDialogView.cfm"></td></tr>
				<tr><td style="padding-left:10px;padding-right:10px" id="#url.ajaxid#"><cfinclude template="EventWorkFlow.cfm"></td></tr>			
			</table>
			
		</cf_divscroll>	
		
	</cf_layoutarea>	
	
	<cf_layoutarea 
	    position="right" name="commentbox" minsize="20%" maxsize="30%" size="370" overflow="yes" collapsible="true" splitter="true">
	
		<cf_divscroll style="height:99%">
			<cf_commentlisting objectid="#eventid#"  ajax="No">		
		</cf_divscroll>
		
	</cf_layoutarea>		
		
</cf_layout>
	
</cfoutput>
