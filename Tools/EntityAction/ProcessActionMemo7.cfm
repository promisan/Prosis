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
<cfoutput>
  
   <cfif Action.EnableHTMLEdit eq "0">
	 	 
		<tr class="labelmedium"><td style="padding-left:10px"><cf_tl id="Comments">:</td></tr>
		   	     	  
		   <tr id="memoblock">
		  
		   <td width="80%" colspan="2">
		   
		   		<table width="100%" cellspacing="0" cellpadding="0" class="formpadding"><tr><td style="padding-left:15px;padding-right:15px">
			      <textarea class="regular" 			            
						name="ActionMemo" 
						style="border:1px solid silver;height:100;padding:4px;font-size:15px;width:98%">#Action.ActionMemo#</textarea>
				</td></tr>
				</table>		
		   </td>
		   		   
		</tr>		   
		   
   <cfelse>
		   
		   <tr><td colspan="2" class="linedotted"></td></tr>
		   	     	  
		   <tr>
		   <td valign="top" style="padding-top:3px" height="27" class="labelmedium">&nbsp;&nbsp;<cf_tl id="Memo">:</b></td>
		   <td colspan="1" align="right">
		  	    		  
			  &nbsp; | &nbsp;
			  <button name="Mail" id="Mail" type="submit" type="button" class="button3" ><img src="#SESSION.root#/Images/email_send.gif" alt="Send eMail" border="0"></button>
			  &nbsp; | &nbsp;			 
			  <input type="submit" name="Print" id="Print" type="button" value="" class="button3" style="background-image: url(#SESSION.root#/Images/print_small.jpg); height: 18px; width: 20px; border: 0px;">
			  &nbsp; | &nbsp;
				
		   </td>
		   </tr>
		  	  	   	  	   
		   <tr id="memoblock">
				  
		   <td colspan="2" align="center">
		   
		   <table width="98%" cellspacing="0" cellpadding="0" align="center">
		   
		   <tr><td>
		 	 		
			<cfif CGI.HTTPS eq "off">
	    	  <cfset protocol = "http">
			<cfelse> 
			  <cfset protocol = "https">
			</cfif>
					
			<cfset thisDir = protocol & "://" & CGI.HTTP_HOST & Replace(CGI.SCRIPT_NAME, "ProcessAction.cfm","")>
		   			   
			<cfif CLIENT.width lte "1024">
				<cfparam name="attributes.height"  default="350">
			<cfelse>
				<cfparam name="attributes.height"  default="440">
			</cfif>
			
			<cfif Action.EnableAttachment eq "0">
				<cfset Attributes.height = "#Attributes.height+60#">
			</cfif>
			
			<cfif Embed.DocumentTemplate neq "">
				<cfset Attributes.height = "#Attributes.height+80#">
			</cfif>
						
			<cfparam name="attributes.images"  default="exampleimages">
			<cfparam name="attributes.border"  default="0">
			
			<cfset ht = attributes.height>
						
			<cf_textarea name="actionmemo"                 
		           color          = "ffffff"
			       height         = "360"	
				   init           = "Yes"			 			 				          		                   
		           toolbar        = "basic"
				   resize         = "true">	
			   			  				
			   			  				
				<!--- check if text from prior action exists --->
				
				<cfif  Action.ActionViewMemo neq "" 
				   and Action.ActionViewMemoCopy eq "1"
				   and Action.ActionMemo eq ""
				   and Action.ActionType eq "Action">	
				   			 	
				   #Prior.ActionMemo# 	
				   
				<cfelse>   								
					<cfif Action.ActionMemo neq "">	
					
						#Action.ActionMemo#	
						
					<cfelseif Action.ActionType eq "Action">
					
						<!--- take last available text, usually "" --->
						<cfquery name="Doc" 
						 datasource="AppsOrganization"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
							SELECT   *
							FROM     OrganizationObjectAction
							WHERE    ObjectId   = '#Action.ObjectId#'
							AND      ActionCode = '#Action.ActionCode#' 
							AND      ActionStatus != '0'
							ORDER BY Created DESC 
						</cfquery>
																
						#Doc.ActionMemo#
						
					</cfif>	
				
				</cfif>				
				
			</cf_textarea>
							
			</td></tr>
			</table>
	
	</cfif>			
	
</cfoutput> 		