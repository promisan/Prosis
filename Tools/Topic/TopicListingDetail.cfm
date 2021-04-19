		
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

<table width="100%" class="navigation_table" class="formpadding">
		   	
	 <TR class="fixrow labelmedium2 line">
		<td width="10"></td>
		<td width="20">S</td>
		<td width="5%">Code</td>
		<td width="18%">Label</td>	  
		<td width="28%">Description</td>
		<td width="10%">
			<cfif systemmodule neq "Roster">
				Entity
			</cfif>
		</td>	
		<td width="10%">Type</td>
		<td width="40">Oblig.</td>
		<td width="30">Ena.</td>
		<!---
		<td width="15%" class="labelit">Officer</td>
		--->
		<td width="80"  align="right">Created</td>		
		<td width="30"></td>			  	  
    </TR>			
			
	<cfoutput query="Listing" group="TopicClass">
	
	<tr><td colspan="12" style="height:40px" class="labellarge line"><font size="2">Topic:</font>&nbsp;#TopicClass#</font></td></tr>
	
	  <!--- Nery : determine the number --->
		
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
								
			<TR class="navigation_row line labelmedium2">			
			  			   
			   <td align="center" style="height:21px" width="30"> 
			   
				   <table cellspacing="0" cellpadding="0">
				    <tr>				 	
					  
					  <cfif topicscopetable neq "">								  
					 	<cfif alias neq "appsemployee">
						<!---- This is hardcoded as TopicListingClass does not show anything if it is AppsEmployee, so there is no point to show expand for employee 
							Copying exactly the same condition as in TopicListingClass
						--->					
						  <td style="padding-left:8px;padding-top:8px;">	
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

