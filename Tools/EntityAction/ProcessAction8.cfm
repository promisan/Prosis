<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<head>
	<cf_textareascript>
	<cfajaximport tags="cfform,cfdiv">
	<cf_ActionListingScript>
	<cf_FileLibraryScript>
	<cf_DetailsScript>
	<cf_MenuScript>	
	<cf_LedgerTransactionScript>	
</head>

<!--- disabled by Dev, maybe this was needed in the past to show
<table class="hide"><tr><td><cf_textarea name="FieldDocument" height="2" init="Yes"></cf_textarea></td></tr></table>
--->

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
		 AND      R.FieldType = 'map'
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
	   SELECT  *
	   FROM    OrganizationObjectAction OA, 
	           Ref_EntityActionPublish P,
			   Ref_EntityAction A				
	   WHERE   ActionId = '#URL.ID#' 
	   AND     OA.ActionPublishNo = P.ActionPublishNo
	   AND     OA.ActionCode = P.ActionCode 
	   AND     A.ActionCode = P.ActionCode
	</cfquery>
	
	<!---
	
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
		
	option="#option#"
	
	--->
	
<cfinclude template="ProcessActionScript.cfm">	

<cfif action.processmode eq "1">

	<cf_screentop scroll="no"	   	    
	   band="No" 
	   layout="webapp" 
	   bootstrap="no"
	   height="100%" 		   	  
	   banner="gray" 	
	   bannerforce="Yes"
	   html="no"	   
	   jquery="Yes"	   
	   label="#Object.ObjectReference#: #Action.ActionDescription#">
		  	   
    <cf_divscroll>		
		
		<cfinclude template="ProcessAction8Content.cfm">	
									
	</cf_divscroll>
	
		
	<cfset AjaxOnLoad("function(){window.parent.ProsisUI.setWindowTitle('#Action.ActionDescription# #Action.ActionReference# [#Action.ActionCode#]','','gray');}")>		
	
<cfelseif action.processmode eq "4">

	<cf_screentop scroll="yes"	   	    
	   band="No" 
	   layout="webapp" 
	   height="100%" 	
	   bootstrap="yes"	   	  
	   banner="gray" 	
	   bannerforce="Yes"
	   line="no" 	  
	   html="no"
	   jquery="Yes"	   
	   label="#Object.ObjectReference#: #Action.ActionDescription#">	   

	<cf_layoutscript>
				
	<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	  

	<cfparam name="url.summary" default="1">
		
		<cf_layout attributeCollection="#attrib#">

			<cf_layoutarea 
		          position="header"
				  size="50"
		          name="controltop">	
				  
				<cf_ViewTopMenu label="#Object.ObjectReference#: #Action.ActionDescription#" menuaccess="context" background="blue">
						
			</cf_layoutarea>		 
		
			<cf_layoutarea  position="center" name="box">
			
				<table style="height:100%;width:100%">
				<tr>
				<td style="padding-left:15px">
				
			     <cf_divscroll>	
					<cfinclude template="ProcessAction8Content.cfm">		
				</cf_divscroll>
				 
				 </td></tr>
				 </table>
		
			</cf_layoutarea>	
						
			<cf_layoutarea 
				    position="right" 
					name="detailbox" 
					minsize="20%" 
					maxsize="30%" 
					size="400" 
					overflow="yes" 
					initcollapsed="yes"
					collapsible="true" 
					splitter="true">
					
					<!---
				
					<cf_divscroll style="height:100%">
						<cf_commentlisting objectid="#Object.ObjectId#"  ajax="No">		
					</cf_divscroll>
					
					--->
					
			</cf_layoutarea>	
							
		</cf_layout>	
		
<cfelse>

	<cfif url.windowmode eq "embed">
		<cfset html = "No">
	<cfelse>
		<cfset html = "Yes">	
	</cfif>
	
	<cf_screentop scroll="yes"	   	    
	   band="No" 
	   layout="webapp" 
	   height="100%" 	
	   bootstrap="yes"	   	  
	   banner="gray" 	
	   bannerforce="Yes"
	   line="no" 	
	   html="#html#"  
	   jquery="Yes"	   
	   label="#Object.ObjectReference#: #Action.ActionDescription#">
	   		
    	<cf_divscroll>	
		
			<cfinclude template="ProcessAction8Content.cfm">						
		
		</cf_divscroll>
		
</cfif>		