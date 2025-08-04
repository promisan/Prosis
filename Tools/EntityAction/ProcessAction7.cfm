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

<cf_textareascript>
<cfajaximport tags="cfform,cfdiv">

<cf_ajaxRequest>

<cfparam name="URL.Process" default="">

<script language="JavaScript">

<cfif URL.Process neq "">

	 alert("Problem, document may not be processed for the following reason:\n\n"+
	 "- <cfoutput>#URL.Process#</cfoutput>")
	 
</cfif>	

</script>

<cfsavecontent variable="option">
	
	<cfoutput>
		#Object.ObjectReference#
	</cfoutput>

</cfsavecontent>

<cf_screentop scroll="no" 
	   height="100%" 
	   layout="webapp"
	   banner="gray"
	   jQuery="yes"
	   option="#option#"	   
	   label="#Action.ActionDescription#">

<cfif Action.ActionViewMemo eq "Prior">

	<!--- original --->
		
	<cfquery name="Min" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT MIN(ActionFlowOrder) as ActionFlowOrder
	   FROM   OrganizationObjectAction
	   WHERE  ActionCode = '#Action.ActionCode#'
	   AND    ObjectId  = '#Action.ObjectId#' 
	</cfquery>
	
	<cfquery name="Act" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT *
	   FROM   OrganizationObjectAction
	   WHERE  ActionFlowOrder = '#Min.ActionFlowOrder-1#' 
	   AND    ObjectId  = '#Action.ObjectId#' 
	</cfquery>
	
	<cfset act = "#Act.ActionCode#">
	
<cfelse>

	<cfset act = "#Action.ActionViewMemo#">	

</cfif>

	<cfquery name="PriorStep" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT   TOP 1 OA.*, A.ActionDescription
	   FROM     OrganizationObjectAction OA, Ref_EntityAction A
	   WHERE    OA.ActionCode  = '#act#' 
	   AND      OA.ActionCode != '#Action.ActionCode#'
	   AND      OA.ObjectId    = '#Action.ObjectId#'
	   AND      A.ActionCode   = OA.ActionCode
	   AND      OA.ActionStatus >= '2' 
	   ORDER BY OA.Created DESC 
	</cfquery>

<!--- disabled no need
<cf_wait1 Text="Please, wait..." Icon="Clock">
--->

<cfset CLIENT.prepS = now()>
<cfparam name="URL.Mode" default="View">

<cfinclude template="ProcessActionScript.cfm">

<cfquery name="Embed" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
   SELECT D.*
   FROM   Ref_EntityDocument D		
   WHERE  D.DocumentCode   = '#Action.ActionDialog#'
   AND    D.EntityCode     = '#Object.EntityCode#'
   AND    D.DocumentType   = 'dialog'
   AND    D.DocumentMode   = 'Embed'  
</cfquery>

<cfinclude template="../Document/FileLibraryScript.cfm">

<cfparam name="url.id"  default="{00000000-0000-0000-0000-000000000000}">

<cf_divscroll>  

<cfform action="ProcessActionSubmit.cfm?windowmode=#url.windowmode#&wf=1&wfmode=7&process=#URL.Process#&ID=#URL.ID#&ajaxId=#url.ajaxid#" 
  method="post" 
  <!--- removed 25/8 as otherwise the saving of the NY vactrack text would not be supported
  onsubmit="return false" <!--- added --->
  --->
  id="processaction"
  name="processaction">
  
<cfoutput query="Action">
	
	<table width="96%" align="center" border="0" cellspacing="0" cellpadding="0">
								
	<tr><td valign="top" colspan="2">
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="ffffff">
			
	  <cfset wfmode = "7">	
	  
	  <cfif ActionType eq "Action">
	  	   <cfinclude template="ProcessActionAction.cfm"> 
	   <cfelse>
	       <cfinclude template="ProcessActionDecision.cfm">
       </cfif>
	   
	   <tr><td colspan="2" class="line"></td></tr>
	   		
	   <cfif ActionReferenceShow eq "1">
	   
		    <tr>
		    <td width="180" height="25" class="labelmedium" style="padding-left:10px"><cf_tl id="Reference">:</td>
			<td>
			<table width="100%">
				<tr><td class="labelmedium">#Object.ObjectReference# (#Object.ObjectReference2#)</td></tr>
			</table>
			</td>
		   </tr>
		   				    
		   <tr>
		    <td height="25" class="labelmedium" style="min-width:200px;padding-left:10px"><cf_tl id="Action">:</td>
			<td width="80%">
			<table width="100%">
				<tr>
				<td class="labelmedium2" style="font-size:15px">
				
				<cfif ActionSpecification neq "">
				
					<img src="#SESSION.root#/Images/icon_expand.gif" alt="View action instruction" 
						id="textExp" border="0" class="regular" alt="Action details"
						align="absmiddle" style="cursor: pointer;" 
						onClick="more('text','show')">
						
						<img src="#SESSION.root#/Images/icon_collapse.gif" 
						id="textMin" alt="Hide action instruction" border="0" 
						align="absmiddle" class="hide" style="cursor: pointer;" 
						onClick="more('text','hide')">
					&nbsp;							
					<a href="javascript:more('text','show')">#ActionDescription#</a>	
							
				<cfelse>#ActionDescription#	
				</cfif>
				
				<img src="#SESSION.root#/Images/gohere.gif"
						     alt="Show Workflow"
						     border="0"
						     align="absmiddle"
							 valign="center"
						     style="cursor: pointer;"
						     onClick="workflowshow('#Object.ActionPublishNo#','#Object.EntityCode#','#Object.EntityClass#','#ActionCode#','#Object.ObjectId#')">
										
				</td>
				</tr>
			</table>
			</td>
		   </tr>
	   
	   </cfif>	      
	 	   	  		   
	   <cfif ActionSpecification neq "">
	 	      
	   	    <tr><td height="1"></td></tr>
			
		    <tr id="text" class="xhide">
			
			   <td></td>
			  
			   <td height="20" colspan="3">
	            
			   <table width="100%" style="border:1px dotted silver;padding:1px" cellspacing="0" cellpadding="0" align="center">
			    
				   <tr><td height="25" style="padding-left:4px" bgcolor="f4f4f4" class="labelmedium">
				   
	   		   	   <cfswitch expression="#Client.LanguageId#">
					 <cfcase value="ENG">			   
				        The following action(s) will need to be performed before you Decide/Forward
					 </cfcase>
					 <cfcase value="ESP">		
						Las siguiente(s) accion(es) necesitan ser realizadas antes de que usted procese el paso.
					 </cfcase>		 
					</cfswitch>	
					
					</td></tr>
					
					<tr><td class="line"></td></tr>
				  
				   <tr><td style="height:30">
				   
				   <table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
				      <td bgcolor="FdFdFd" class="labelit">
				      #ActionSpecification#
					  </td>
				   </table>
				   </td></tr>
				   
			   </table>
			  			
			   </td>
			</tr>
			<tr><td height="3"></td></tr>
						
       </cfif>		
	   
	   <cfif entityaccess eq "EDIT" or entityaccess eq "ALL">	
		   	
		   <tr><td id="stepflyaccess" colspan="2">
		   
		   	   <cfset url.objectid = action.ObjectId> 	
		   		 
			   <cfinclude template="ActionListingFly.cfm">				 	   
		   
		   </td></tr>
		   
	   </cfif>   
	  
		   
	   <!--- SHOW DIALOG ---> 	 
	     	  
	   <cfif Embed.DocumentTemplate neq "" and Embed.DocumentMode eq "Embed">
	    
		  <tr><td colspan="2" class="line"></td></tr>	
		  <tr><td height="3"></td></tr>		
		  <tr>
			<td colspan="2" id="dialog">	
				
				     <cfset url.WParam = Action.ActionDialogParameter>
					 <!--- in case the ID value is changed in the template (req) --->
					 <cfset t = URL.ID>
				     <cfinclude template="../../#Embed.DocumentTemplate#"> 
					 <cfset url.id = t>
									
		  	</td>
		 </tr>
		 <tr><td height="3"></td></tr>
		   		  	   
	   </cfif>
	  	  
	   <!--- entrycustom defined fields --->	   
	   
	   <tr><td width="100%" colspan="2">
	   
	   <cfform name="formcustomfield" id="formcustomfield" onsubmit="return false"> 
	   
		    <cfinclude template="ProcessActionFields.cfm">	
	   
	   </cfform>
	   </td></tr>    
		
	   	   	   
	   <!--- SHOW PRIOR MEMO ---> 
	   	   	    	  	
	   <cfif Action.ActionViewMemo neq "">	  	   	   		   		   
		 	
				<cfif PriorStep.ActionMemo neq "">
		 
				    <tr><td colspan="2"></td></tr>			  	  
				    <tr>
					   	<td width="97%" colspan="2" align="center">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
							 <tr>
							   <td height="24" class="labelit" width="88%">&nbsp;&nbsp;&nbsp;<b>#PriorStep.ActionDescription# (#PriorStep.OfficerFirstName# #PriorStep.OfficerLastName# #DateFormat(PriorStep.Created, CLIENT.DateFormatShow)#):</td>
							   <td width="12%" align="right">
								    &nbsp; | &nbsp;
								    <button type="button" onClick="javascript:mail('#PriorStep.ActionId#')" class="button3">
								     <img src="#SESSION.root#/Images/email_send.gif" alt="eMail text" border="0" align="absmiddle">
								   </button>&nbsp; | &nbsp;								  
							   </td>
						    </tr>
							
							<tr>
								<td colspan="2" align="center">
								<table width="97%" align="center">
								    <tr><td class="labelit">#PriorStep.ActionMemo#</td></tr>
								</table>
								</td>
							</tr>
						</table>				
						</td>
				    </tr>
				
				</cfif>		 		
				   
	   </cfif>
	   
	   <!--- ATTACHMENT DOCUMENT --->
	  		  
	   <cfinclude template="Report/DocumentAttach.cfm">	  
	   	    	   	   	   	     
	   <cfif Action.EnableAttachment eq "1">
	      	   
		   <tr class="labelmedium">
			   <td style="padding-left:10px"><cf_tl id="Attachment">:</td>
			   <td colspan="1">
			   <table width="98%">
			   <tr><td>
			   <cfset mode = "edit">
			   <cfset EntityCode   = "#Object.EntityCode#">
			   <cfset ActionId     = "#Action.ActionId#">			  
			   <cfinclude template = "ProcessActionAttachment.cfm">		
			   </td></tr></table> 	
			   </td>			  
			</tr>   
				   
	   </cfif>
	     		  
	   <!--- GENERATE DOCUMENT --->
	   	  
	   <!--- custom report embed in action form 17/1/06 Hanno --->
	   	   
	   <cfquery name="Document" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		   SELECT D.*
		   FROM   Ref_EntityDocument D, Ref_EntityActionDocument R		
		   WHERE  R.ActionCode   = '#Action.ActionCode#'
		   AND    R.DocumentId     = D.DocumentId 
		   AND    D.DocumentType   = 'report' 
		   AND    D.Operational = 1
	   </cfquery>
	   	   	  	   
	   <cfif Document.recordcount gte "1">
	   
	    	<tr>
		    	<td colspan="2">			
				  <cfinclude template="Report/Document.cfm"> 				  
			  	</td>
			</tr>
			<tr><td height="3"></td></tr>	
						
	   </cfif>	      
	 	
	   <!--- MAIL MEMO --->
	   
	   <!--- show mail text box in case custom mail is enabled --->
	   
	   		<cfquery name="Mail" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
		   	  SELECT    *
			  FROM      Ref_EntityDocument
			  WHERE     EntityCode = '#Object.EntityCode#' 
			  AND       DocumentType = 'mail' 
			  AND       DocumentMode = 'Edit'
			  AND       DocumentCode IN ('#Action.PersonMailAction#',
			                             '#Action.PersonMailCode#',
										 '#Action.DueMailCode#') 
			</cfquery>
			
			<cfif mail.recordcount gte "1">
			
			   <cfparam name="mailsubject" default="">
			   <cfparam name="mailtext" default="">
			 			   			   
			   <cftry>		   
			   	   <cfinclude template="../../#Mail.DocumentTemplate#">
			   	   <cfcatch></cfcatch>
			   </cftry>
			   
			   <cfif mailsubject eq "">
			        <cfset mailsubject = "#Object.ObjectReference# #Object.ObjectReference2#">
			   </cfif>
			  
			   <tr><td colspan="2" class="linedotted"></td></tr>
			   
			   <tr><td height="4"></td></tr>
			   <tr>
			   
			    <td colspan="1" height="25" valign="top" style="padding-top:3px" class="labelmedium" id="mailblock2">&nbsp;&nbsp;&nbsp;<cf_tl id="EMail">:</td>
				
				<td id="mailblock1">
			   
				   <table width="100%" align="right" class="formpadding" cellspacing="0" cellpadding="0">	
						   	     	  
				   <tr>
					   <td width="80" class="labelit"><cf_tl id="Subject">:</b></td>
					   <td width="85%" colspan="1">
					  	 <input type = "text"
						   name      = "ActionMailSubject"
						   id        = "ActionMailSubject"
						   value     = "#mailsubject#"
						   style     = "width:97%"
						   maxlength = "120"
					       class     = "regularxl">
					   </td>
				   </tr>
				   
				   <tr>
					   <td colspan="1" class="labelit" valign="top" style="padding-top:3px"><cf_tl id="Mail Annotation">:</b></td>
				       <td>
											   
					     <textarea class="regular" 
					            rows="2" 
								name="ActionMail" 
								style="width:97%;font-size:13px;padding:3px"></textarea>
					  							 
				   </td></tr>
				   
				   	   <cftry>
					   
					   <cfparam name="mailatt[1][1]" default="none">
					   
					   <cfif mailatt[1][1] neq "none">
				  			  		   
					   <tr>
						  <td colspan="1"><cf_tl id="Attachment">:</b></td>
						  <td>
					 
						  <!--- show attachment --->
						  <script LANGUAGE = "JavaScript">
							  function view(att) {
							  window.open(att, "Attachment", "width=850, height=660, menubar=yes, status=yes, toolbar=no, scrollbars=yes, resizable=yes"); }
						  </script>
									
						  <cfloop index="att" from="1" to="5" step="1">
						   
							   <cfparam name="mailatt[#Att#][1]" default="none">
							   <cfparam name="mailatt[#Att#][2]" default="none">
							   <cfparam name="mailatt[#Att#][3]" default="none">
							   
							   <cftry>
				
							   <cfif mailatt[att][1] neq "none">
							        <input type="checkbox" name="ActionMailAttachment" id="ActionMailAttachment" value="#mailatt[att][1]#" checked>
									<a href="javascript:view('#mailatt[att][2]#')">#mailatt[att][3]#</a>&nbsp;
							   <cfelse>
							   	<!--- #mailatt[att][3]# --->
							   </cfif>
							   
							   <cfcatch></cfcatch>
							   
							   </cftry>
							  			   
						  </cfloop>											   
					      </td>
					   </tr>
					   
					   </cfif>
					   
					   <cfcatch></cfcatch>
					   
					   </cftry>				 
				   
				   </table>				   
				   </td>			   
			   </tr>			   
			  			   
	   	</cfif>
		
		</cfoutput>		
				
					
	   <!--- GENERATED DOCUMENTS AND MEMO --->
	   
	   <tr><td id="output" colspan="2"></td></tr>
	   				 	   	  	   	  	     
		   <cfif Action.EnableTextArea gte "1">
		   		<cfinclude template="ProcessActionMemo7.cfm">		   
		   <cfelse>
	   	    <tr class="hide" id="memoblock"><td>			
	     		<input type="hidden" name="actionmemo" id="actionmemo" value="#ActionMemo#">
			</td></tr>	 	  	    	   		
	   
		   </cfif>
							   	   
	   </table>
	   	
</table>

<!--- cf7 only --->

<cfoutput>

<script>
	
	<cfif #URL.Mode# eq "Print">
		
	{
	  w = #CLIENT.width# - 100;
	  h = #CLIENT.height# - 140;
	  ptoken.open("ActionPrint.cfm?id=#URL.ID#","_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
  	}
	
	</cfif>
	
	<cfif #URL.Mode# eq "Mail">
		
	{
	  ptoken.open("ActionMail.cfm?id=#URL.ID#","_blank", "left=30, top=30, width=800, height=600 , toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
  	}
		
	</cfif>
	
</script>	
</cfoutput>	

</cfform>	

</cf_divscroll>		

<cf_screenbottom layout="webapp">

