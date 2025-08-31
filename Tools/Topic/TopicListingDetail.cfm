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
<cfparam name="url.id2" default="">	

<cfparam name="form.operational" default="0">	
<cfparam name="link"             default="">	

<!--- passing all variables --->

<cfset link = "systemmodule=#systemmodule#&alias=#alias#&language=#language#">

<cfloop index="lk" from="1" to="5">
	<cfset link = "#link#&topictable#lk#=#evaluate('topictable#lk#')#&topictable#lk#name=#evaluate('topictable#lk#name')#">
	<cfset link = "#link#&topicscope#lk#=#evaluate('topicscope#lk#')#&topicfield#lk#=#evaluate('topicfield#lk#')#&topicscope#lk#table=#evaluate('topicscope#lk#table')#&topicscope#lk#field=#evaluate('topicscope#lk#field')#">
</cfloop>

<cfif systemmodule eq "Roster">
	
	<cfquery name="Listing" 
	datasource="#alias#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT    Topic as Code, P.Description as TopicClass, *
	    FROM      Ref_Topic R, Ref_ExperienceParent P
		WHERE     R.Parent = P.Parent	
		ORDER BY  SearchOrder,R.Parent,ListingOrder, R.Created DESC
	</cfquery>

<cfelse>
	
	<cfquery name="Listing" 
	datasource="#alias#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT    *
	    FROM      Ref_Topic	
		ORDER BY  TopicClass, ListingOrder, Created DESC
	</cfquery>

</cfif>

<table style="width:98%" class="navigation_table" class="formpadding">
		   	
	 <TR class="fixrow labelmedium2 line fixlengthlist">
		<td></td>
		<td>S</td>
		<td><cf_tl id="Code"></td>
		<td><cf_tl id="Label"></td>	  
		<td><cf_tl id="Description"></td>
		<td>
			<cfif systemmodule neq "Roster">
				<cf_tl id="Entity">
			</cfif>
		</td>	
		<td><cf_tl id="Type"></td>
		<td><cf_tl id="Force"></td>
		<td><cf_tl id="Enabled"></td>
		<!---
		<td width="15%" class="labelit">Officer</td>
		--->
		<td align="right"><cf_tl id="Created"></td>		
		<td></td>			  	  
    </TR>			
			
	<cfoutput query="Listing" group="TopicClass">
	
	<tr class="line"><td colspan="12" style="height:40px;font-size:24px" class="labellarge line"><font size="3">Topic:</font>&nbsp;#TopicClass#</font></td></tr>
	
	  <!--- dev : determine the number --->
		
	  <cfset topicscopetable="">
	  <cfset datatable = "">
	  <cfset serialno  = "0">
	  
	  <cfloop index="lk" from="1" to="5">
	  
	       <cfif systemmodule eq "Roster">
		   						   
				<cfset val = evaluate("topictable#lk#name")>		   
						   		
				<cfquery name="get"
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
					FROM Ref_ExperienceParent
					WHERE Area = '#val#' 
				</cfquery>	   		
		   
		   		<cfif get.area neq "">
					 
		   			<cfset serialno  = lk>	
					<cfset datatable = evaluate("topictable#lk#")>									
	 			    <cfset topicscopetable=evaluate("topicscope#lk#table")>
					
			   </cfif>	
		   
		   <cfelse>
	  
			   <cfif topicclass eq evaluate("topictable#lk#name")>
					 
		   			<cfset serialno  = lk>	
					<cfset datatable = evaluate("topictable#lk#")>					
	 			    <cfset topicscopetable=evaluate("topicscope#lk#table")>
					
			   </cfif>	
		   
		   </cfif>
	   
	   </cfloop>
	   		
	    <cfoutput>
								
			<TR class="navigation_row line labelmedium2  fixlengthlist">			
			  			   
			   <td align="center" style="height:21px" width="30"> 
			   
				   <table cellspacing="0" cellpadding="0">
				    <tr>				 	
					  
					  <cfif topicscopetable neq "">								  
					 	<cfif alias neq "appsemployee">
						<!---- This is hardcoded as TopicListingClass does not show anything if it is AppsEmployee, so there is no point to show expand for employee 
							Copying exactly the same condition as in TopicListingClass
						--->					
						  <td style="padding-left:8px;padding-top:10px;">	
						  	<cf_img icon="expand" toggle="yes" onclick="showDetail('#code#','#systemmodule#','#link#','#serialno#','detail_#code#');">
						  </td>
						</cfif>  
					</cfif>  
					
					 <td style="padding-left:2px;padding-top:1px;padding-right:0px;">
					    <cf_img icon="open" navigation="yes" onclick="recordedit('#code#')">
					  </td>		
					 
					 </tr>
				  </table>
			   
			  </td>
			  
			  <td>#ListingOrder#</td>			   
			  <td>#code#</td>			   
			  <td>#topiclabel#</td>			  
			  <td>
				   <a href="javascript:recordedit('#code#')">
				   <cftry>#question#
				   <cfcatch>#description#</cfcatch>
				   </cftry>			   
				   </a>
			  </td>			   
			   
			  <td>
			   		<cfif systemmodule neq "Roster">
				   		<cfif mission eq "">any<cfelse>#Mission#</cfif>
					</cfif>
			   </td>
			  		   
			   <td>#ValueClass# <cfif ValueClass eq "text">(#valueLength#)</cfif></td>
			  
			   <td><cfif ValueObligatory eq "0"><b>No</b><cfelse>Yes</cfif></td>
			   <td><cfif operational eq "0"><b>No</b><cfelse>Yes</cfif></td>
			   <!--- <td class="labelit">#OfficerLastName#</td> --->
			   <td align="right">#dateformat(created,CLIENT.DateFormatShow)#</td>
					
				 <!--- ------------------------------ --->  
				 <!--- ------------------------------ --->
				 <!--- ------------------------------ --->
				   
				 <td align="center" width="40">
				 
				 <cfif datatable neq "">
				 
				   <cfquery name="Check" 
						datasource="#alias#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    	SELECT TOP 1 Topic
						    FROM   #datatable#
							WHERE  Topic = '#Code#'
				   </cfquery>
				 
				   <cfif check.recordcount eq "0">	
				  
				  	<cf_img icon="delete" 
					   onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/tools/topic/TopiclistingPurge.cfm?serialno=#serialno#&#link#&Code=#code#','topiclist')">
				 				
				   </cfif>	  
				  
				  <cfelse>
				  
				    	<cf_img icon="delete" 
					   onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/tools/topic/TopiclistingPurge.cfm?serialno=#serialno#&#link#&Code=#code#','topiclist')">				
				  
				  </cfif> 
					  
				</td>  
			   		   
		   </tr>	
		  
		 <tr class="line"><td style="padding:3px" colspan="13" id="detail_#code#" class="hide" align="center"></td></tr> 
					
	</cfoutput>
	
	</cfoutput>													
				
</table>			

<cfset AjaxOnLoad("doHighlight")>		

<script>
Prosis.busy('no')
</script>		

