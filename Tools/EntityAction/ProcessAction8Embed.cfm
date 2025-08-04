<!--
    Copyright © 2025 Promisan

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
 <cfset l = len(url.ajaxid)>
 <cfif l eq 37 and mid(url.ajaxId,1,1) eq "c">
 	<cfset url.ajaxid = mid(url.ajaxid, 2, l-1)>	
 </cfif>	
 	 
<cfquery name="Action" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	   SELECT *
	   FROM   OrganizationObjectAction OA, Ref_EntityActionPublish P		
   	   WHERE  ActionId = '#URL.ID#' 
	   AND    OA.ActionPublishNo = P.ActionPublishNo
	   AND    OA.ActionCode = P.ActionCode 
</cfquery>

<cfquery name="Object" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
   SELECT *
   FROM OrganizationObject O, Ref_Entity R		
   WHERE ObjectId = '#Action.ObjectId#' 
   AND O.EntityCode = R.EntityCode
   AND O.Operational  = 1
</cfquery>

<cfquery name="Embed" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
   SELECT D.*
   FROM   Ref_EntityDocument D		
   WHERE  D.DocumentCode   = '#Action.ActionDialog#'
   AND    D.EntityCode     = '#Object.EntityCode#'
   AND    D.DocumentType   = 'dialog'  
</cfquery>

<!--- there are two modes supported. The embedded mode and the ajax mode

I. EMBEDDED FORN (supported in 
    a. tabbed mode and 
	b. single screen mode)

The embedded mode is the easiest and was originally aimed for the single screen mode. 

The development simply defines 

A. one or more field in a template called Document.cfm. The template is very simply to create and does
not need a <cfform></cfform>

<cfinput name=field1> or <input name="field1>

you must define a field

<input name="savecustom" type="hidden"  value="path to the submit template re B below.">

B. Create a template that would save the values in the field of the prior template into the DB. In this template
you would need the following variables of the workflow object in order to determine the correct records in the tables
that you want to update.

#Object.ObjectKeyValue1#
#Object.ObjectKeyValue2#
#Object.ObjectKeyValue3#
#Object.ObjectKeyValue4#

Standard naming

Entryform :  path/Document.cfm
SubmitForm : path/DocumentSubmit.cfm

Note : you may include Javascript for the embedded form.

Users : may save the form independently once used in the tabbed dialog, for signle screen mode the saving 
is done as part of the process action submit. 

Attention : The tabbed mode does not save the embedded form as part of the action submit 

Usage : Use this mode whenever possible but it is not always possible for the purpose that is needed.


II. AJAX FORM (only supported in the tabbed mode)

This mode provides the developer with more flexibility in designing his form. The ajax mode requires the developer
to arrange for saving within his ajax form and the form is not saved as part as part of the submit.

Usage 
- Use this mode in the fields of the dialog are not fixed at the opening of the form. like for the procurement
insurance dialog.
- Use this mode if you need the dialog screen to be refreshed independently from the process dialog (ReviewPanel)

--->

	   <cfset showProcess = "1">
	  	   	   
	   <cfif embed.documentMode neq "Ajax">
	   	      	   	  	  	   				   
		  	<cfform onsubmit="return false" method= "POST" name= "formembed" style="height:99%">		
			
					    		   	   		
				<table style="height:100%;width:100%">
								 	   		
				   <!--- traditional form which can be submitted directly or as part of the submit process --->
				  		 			 
					  <tr><td id="submit_formembed" height="1"></td></tr>
					 					 
					  <tr>
						<td colspan="2" valign="top" style="height:100%">	
							

							<cfdiv id="dialog" style="height:100%">
									
							     <cfset url.WParam = Action.ActionDialogParameter>
								 <cfset tempvaraction = URL.ID>			
								 		 						 
							     	<cfinclude template="../../#Embed.DocumentTemplate#"> 														
									
								 <cfset url.id = tempvaraction>		
								 
							</cfdiv>	  

							
					  	</td>
					 </tr>			
					
					 <cfoutput>	 
					 
						 <tr>
							 <td align="center">	
							 
							    <cf_tl id="Save and Continue" var="mytext">
													 				 										 		 
							    <input type = "button" 
								class       = "button10g" 
								style       = "width:260px;height:35px;font-size:15px;background-color:1A8CFF;color:white;"
								name        = "EmbedSave" 
								id          = "EmbedSave"
								value       = "#mytext#" 
								onclick     = "validateform('formembed','submit_formembed','#url.process#','#url.id#','#url.ajaxid#')">	
												
							 </td>
						 </tr>
						 
					 </cfoutput>	
					 
					 <tr><td height="2"></td></tr>			 
				 	  				    	 
				</table>
							
			 </cfform>
			 		
				 
	  <cfelse>	  
	  	  	  	   
		<!--- completely independent entry form which is handled in a full ajax manner --->
			
		<table width="100%" height="99%">  	
		
			 <tr>
				<td colspan="2" height="99%" valign="top" align="center">	
																			
					<cfdiv id="dialog" style="height:100%">
												
					     <cfset url.WParam = Action.ActionDialogParameter>
						 <cfset t = URL.ID>
						 			 
					     <cfinclude template="../../#Embed.DocumentTemplate#"> 
						 					 						 
						 <cfset url.id = t>		
						 
						 <cfparam name="url.scope" default="">
						 <cfif url.scope eq "portalaction">		
						 <!--- the dialog is shown directly in the portal based on a prvided link --->				 
						 <input type="button" class="button10g" styel="width:200px;height:25px;font:18px" name="Close" value="Close" onclick="parent.window.close()">						 
						 </cfif>
						 												 
					</cfdiv>					
					
					
			  	</td>
			 </tr>
			 
			 <cfoutput>	 
			 
			 <cfparam name="buttonNext" default="1"> <!--- is variable that you can included in the template --->
			 
			     <cfif buttonNext eq "1">
				 		 
					 <tr>
						 <td align="right" height="25" style="padding-top:3px;padding-right:20px">	
						 					 
						 <cfif url.ajaxid eq "">
						   	   <cfset pr = url.id>
						   <cfelse>
						       <cfset pr = url.ajaxid> 		   
						   </cfif>
						   
						   <cfparam name="boxno" default="1">
							
						   <cfset nextbox = boxno+1>
						   					   					   					   					   					 		 
						    <input type = "button" 
							class       = "button10g" 
							style       = "width:260px;height:35px;font-size:15px;background-color:1A8CFF;color:white;"
							name        = "EmbedSave" 
							id          = "EmbedSave"
							value       = "Next" 
							onclick     = "document.getElementById('menu#nextbox#').click()">	
											
						 </td>
					 </tr>
				 
				 </cfif>
				 
			 </cfoutput>	
			 
		 </table>	 		
				  
	  </cfif>	
	  
  
