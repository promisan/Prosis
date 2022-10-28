
<cfparam name="Attributes.objectid"          default="47939CF6-CF9B-8A52-AFB7-4CBAE9DB7C63">
<cfparam name="Attributes.threadid"          default="47939CF6-CF9B-8A52-AFB7-4CBAE9DB7C63">
<cfparam name="Attributes.serialno"          default="1">

<cfparam name="url.objectid" default="#attributes.Objectid#">
<cfparam name="url.threadid" default="#attributes.threadid#">
<cfparam name="url.serialno" default="#attributes.SerialNo#">
<cfparam name="Attributes.Ajax" default="Yes">
<cfparam name="Attributes.Mail" default="1">

<cf_presentationScript>

<style>
	.clsLastRowHL {
		border: 0px solid #C0C0C0;
	    background-color: #FCEDD4;
	    -webkit-transition: all 800ms linear;
	    -moz-transition: all 800ms linear;
	    -o-transition: all 800ms linear;
	    -ms-transition: all 800ms linear;
	    transition: all 800ms linear;
	}
</style>

<table height="100%" align="center" style="width:100%;background-color:f8f8f8">
	
	<tr class="hide"><td id="process"></td></tr>	
	
	<tr class="line">
	
		<td height="16">

			<cfinvoke component = "Service.Presentation.TableFilter"  
			   method           = "tablefilterfield" 
			   filtermode       = "direct"
			   name             = "filtersearch"
			   label            = "Find"
			   style            = "font:14px;height:25;width:120"
			   rowclass         = "clsFilterRow"
			   rowfields        = "ccontent">

		</td>
	</tr>
				
	<tr><td width="100%" height="100%" align="center" style="padding-left:7px;padding-right:7px">
	
	<cfset vURLObjectId = replace(url.objectId,"-","","ALL")>
			
	<cf_divscroll id="communicatecomment_#vURLObjectId#">
		<cfinclude template="CommentListingContent.cfm">
	</cf_divscroll>
			
	</td></tr>
	
	<cfoutput>
	<!--- container for show of interval check --->	
	<tr class="hide">
		<td style="padding:3px" id="communicatecomment_#url.objectid#"></td>
	</tr>
	</cfoutput>
		
	<cfquery name="getFlyActors" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  DISTINCT 
				OAS.UserAccount, 
				U.FirstName, 
				U.LastName
				
		FROM   	OrganizationObjectActionAccess OAS 
				INNER JOIN System.dbo.UserNames U 
				ON OAS.UserAccount = U.Account
		WHERE 	OAS.ObjectId = '#url.ObjectId#'
		
		<!--- 25/9/2015 we also involve the people that have their 
	     name in the process OrganizationObjectAction recorded --->
		
		UNION 
		
		SELECT  DISTINCT 
				OA.OfficerUserId, 
				U.FirstName, 
				U.LastName
				
		FROM   	OrganizationObjectAction OA 
				INNER JOIN System.dbo.UserNames U 
				ON OA.OfficerUserId = U.Account
		WHERE 	OA.ObjectId = '#url.ObjectId#'
		
		
	</cfquery>	
	
	<tr class="hide"><td id="processchat"></td></tr>
	
	<tr><td width="95%" id="add" valign="bottom">		
	
	     <cfinclude template="CommentEntry.cfm">		 			
		</td>
	</tr>
	
</table>
