<head>
	<cf_textareascript>
	<cfajaximport tags="cfform,cfwindow,cfinput-autosuggest,cfdiv">
	<cf_ActionListingScript>
	<cf_FileLibraryScript>
	<cf_DetailsScript>
	<cf_MenuScript>	
	<cf_LedgerTransactionScript>	
</head>

<table class="hide"><tr><td><cf_textarea name="FieldDocument" height="2" init="Yes"></cf_textarea></td></tr></table>

<cfparam name="URL.Process" default="">
<cfparam name="url.id"  default="{00000000-0000-0000-0000-000000000000}">
<cfparam name="URL.Mode" default="View">

<cfoutput>

<input type="hidden" 
       name="workflowlink_#url.ajaxid#" 
	   id="workflowlink_#url.ajaxid#"
       value="ProcessAction8Step.cfm">		

<input type="hidden"
       name="workflowcondition_#url.ajaxid#"
	   id="workflowcondition_#url.ajaxid#"
       value="?process=#URL.process#&id=#url.id#&ajaxid=#url.ajaxid#"
       size="100">
	 
</cfoutput>	 
	
<cfquery name="CheckCustom" 
     datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_EntityDocument R INNER JOIN
		          Ref_EntityActionDocument A ON R.DocumentId = A.DocumentId
		WHERE     A.ActionCode = '#Action.ActionCode#' 
		 AND      R.DocumentType = 'field'
		 AND      R.Operational = 1
		 AND      R.DocumentMode = 'Step' 
</cfquery>		 
 
<cfif checkCustom.recordcount gte "1">
    
	<cfif Client.googlemapid neq "">	  
		  <cfinclude template="GoogleMAPId.cfm"> 	   	   
	</cfif>	
		
</cfif>

<script language="JavaScript">
	
	<cfif URL.Process neq "">
	
		 alert("Problem, document may not be processed for the following reason:\n\n"+
		 "- <cfoutput>#URL.Process#</cfoutput>")
		 
	</cfif>	

</script>

<cfquery name="Action" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT *
	   FROM   OrganizationObjectAction OA, 
	          Ref_EntityActionPublish P,
			  Ref_EntityAction A				
	   WHERE  ActionId = '#URL.ID#' 
	   AND OA.ActionPublishNo = P.ActionPublishNo
	   AND OA.ActionCode = P.ActionCode 
	   AND A.ActionCode = P.ActionCode
	</cfquery>
	
<cfsavecontent variable="option">
	<cfoutput>	
		
			<table cellspacing="0" cellpadding="0">			   
				<tr class="labelit">
				    <td id="workflowcustomlabel"></td>										
					<td style="padding-top:3px;padding-left:20px"><font color="FFFFFF"><cf_tl id="Date">:</b></td>
					<td style="padding-top:3px;padding-left:7px"><font color="FFFFFF">#DateFormat(now(), CLIENT.DateFormatShow)#</td>					
				</tr>
			</table>
				
	</cfoutput>
	</cfsavecontent>	

<cf_screentop scroll="yes"	   
	   option="#option#" 
	   band="No" 
	   layout="webapp" 
	   height="100%" 		   	  
	   banner="gray" 	
	   bannerforce="Yes"
	   line="no" 	  
	   jquery="Yes"	   
	   label="#Object.ObjectReference#: #Action.ActionDescription#">
		
<cfinclude template="ProcessActionScript.cfm">

<cf_divscroll>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">
	
	<tr><td colspan="2" style="padding-left:15px;padding-right:15px;">
   	
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		
	<cfparam name="URL.Mode" default="">	
	<cfparam name="url.id"  default="{00000000-0000-0000-0000-000000000000}">
		
	<cfif Action.recordcount eq "0">
		<cf_message text="Problem, please contact your administrator">
		<cfabort>
	</cfif>
	
	<cfoutput query="action">	
			
	  <cfif ActionReferenceShow eq "1"> 
				   
		  <tr class="fixrow"><td colspan="2" valign="top">
		
		  <table width="100%" cellspacing="0" cellpadding="0" align="center">
			  
		    <!--- Element 1b of 3 about --->	
								   
			    <tr class="labelmedium line">
			    <td height="34" width="24%" style="font-size:16px;padding-left:10px">#Object.EntityDescription#:</td>
				<td>
				<table width="100%">
					<tr class="labelmedium">
					<td style="font-size:16px">
					#Object.ObjectReference# <cfif Object.ObjectReference2 neq "">(#Object.ObjectReference2#)</cfif>
					</td>					
					<td align="right">
					
							<img src="#SESSION.root#/Images/Workflow-Methods.png"
								 alt="Show Workflow"
								 border="0"
								 width="32"
								 height="32"
								 align="absmiddle"
								 valign="center"
								 style="cursor: pointer;"
							     onClick="workflowshow('#Object.ActionPublishNo#','#Object.EntityCode#','#Object.EntityClass#','#ActionCode#','#Object.ObjectId#')">
					 </td>
					</tr>
				</table>
				</td>
			   </tr>	
			   
		  </table>
		  </td></tr> 	
			  
	   </cfif>	
	
	</cfoutput>
	
	<cfset processhide = "No">
	<cfset showProcess = "1">
	<cfset def         = "0">
	
			
	<tr class="line"><td valign="top" colspan="2" height="30">
	
		<table width="100%"><tr>
		
		<cfset menumode = "menu">
		<cfinclude template="ProcessAction8Tabs.cfm">
		<td width="10%"></td>			
	    </tr>
		</table>
	
	</td>
	</tr>
		
	<tr><td height="100%" valign="top" style="border:0px solid silver">
		<table width="100%" height="100%">				
		<cfset menumode = "content">
		<cfinclude template="ProcessAction8Tabs.cfm">
		</table>		
	</td></tr>
	
</table>

</td></tr>

</table>

</cf_divscroll>

<!--- load the initial document by default --->

<cf_screenbottom layout="webapp">
