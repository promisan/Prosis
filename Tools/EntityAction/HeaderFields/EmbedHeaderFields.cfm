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
<!--- check for external fields --->

<cfparam name="attributes.EntityId" default="{00000000-0000-0000-0000-000000000000}">
<cfparam name="attributes.Mode" default="'header'">
<cfparam name="attributes.EntityCode" default="">
<cfparam name="attributes.Style" default="">

<cfquery name="Object" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	   
     SELECT    R.*
	 FROM      OrganizationObject R 
	 WHERE     (ObjectKeyValue4 = '#Attributes.EntityId#' OR Objectid = '#Attributes.EntityId#')
	 <cfif attributes.EntityCode neq "">
	 	AND EntityCode='#attributes.EntityCode#'
	 </cfif>
  </cfquery>
   
  <cfquery name="Fields" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	   
     SELECT    R.*
	 FROM      Ref_EntityDocument R 
	 WHERE     R.DocumentType = 'field'
	 AND       R.Operational = 1
	 <cfif attributes.EntityCode neq "">
	 AND       R.EntityCode = '#attributes.EntityCode#'
	 <cfelse>
	 AND       R.EntityCode = '#Object.EntityCode#'
	 </cfif>
	 AND       R.DocumentMode IN (#preserveSinglequotes(attributes.mode)#)					
	ORDER BY DocumentOrder								
  </cfquery>
    
  <cfoutput query="fields">   
      
     <tr>
	    <td width="18%" style="#attributes.style#"
		   height="25" class="labelmedium">#DocumentDescription#:<cfif fieldrequired eq "1"><font color="FF0000">*</font></cfif></td>
				
		<td class="labelmedium" style="z-index:#20-currentrow#; position:relative;padding:0px">
			
			<cfif fieldrequired eq 1>
			   <cfset req = "Yes">
			<cfelse>
			   <cfset req = "No">
			</cfif>
			
			<cfquery name="Topic" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT *
			  FROM  OrganizationObjectInformation
			  <cfif Object.recordcount eq "0">
			  WHERE 1=0
			  <cfelse>			 
			  WHERE ObjectId    = '#Object.ObjectId#'
			  AND   DocumentId  = '#DocumentId#'
			  </cfif>
		    </cfquery>	
			
		   <cfswitch expression="#fieldtype#">		
		
			 <cfcase value="list">
			
				<cfquery name="List" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  SELECT  *
				     FROM  Ref_EntityDocumentItem
					 WHERE DocumentId = '#DocumentId#'
					 AND   Operational = 1
					 ORDER BY ListingOrder
				</cfquery>	
								
				<select name="f_#DocumentCode#" id="f_#DocumentCode#" required="No" class="regularxl">
					<cfloop query="List">
					<option value="#DocumentItem#" <cfif Topic.DocumentItem eq DocumentItem>selected</cfif>>#DocumentItemName#</option>
					</cfloop>
				</select>
				
			  </cfcase>
			
			  <cfcase value="amount">
				
				<cfinput type="Text" 
				        value="#Topic.documentItemValue#" 
						name="f_#documentcode#" 
						required="#req#" 							
						class="amountxl"
						size="20"
			            maxlength="20"
						message="Please enter a correct amount"
						validate="float">
										
			  </cfcase>
			  
			   <cfcase value="email">
				
				<cfinput type="Text" 
				        value="#Topic.documentItemValue#" 
						name="f_#documentcode#" 
						required="#req#" 							
						class="regularxl"
						size="40"
			            maxlength="40"
						message="Please enter a correct email address"
						validate="email">
										
			  </cfcase>
			  
			  <cfcase value="text">
			  
			  	<cfif lookuptable neq "" and lookupfieldkey neq "">				
				
					 <cfif req eq "No">      					 
	    
							<cfinput type="Text"
						       name        = "f_#documentcode#"
						       value       = "#Topic.documentItemValue#"
						       message     = "Please enter a correct #fieldvalidation#"
							   autosuggest = "cfc:service.reporting.presentation.getfield('#DocumentId#',{cfautosuggestvalue})"							
					           maxresultsdisplayed="5"							  			      				      
						       showautosuggestloadingicon="No"
						       typeahead   = "Yes"
							   required    = "#req#"	
						       size        = "#fieldlength#"
						       maxlength   = "#fieldlength#"
						       class       = "regularxl">	
		       
				    <cfelse>
	      
					      <cfquery name="List" 
					       datasource="#LookUpDataSource#" 
					       username="#SESSION.login#" 
					       password="#SESSION.dbpw#"> 
					         SELECT  #LookUpFieldKey# as code,#LookUpFieldName# as name
					           FROM  #LookUpTable#
					        ORDER BY #LookUpFieldKey#
					      </cfquery> 
					        
					      <select name="f_#DocumentCode#" id="f_#DocumentCode#" required="Yes" class="regularxl"> 
					       <cfloop query="List">				       
						       <option value="#code#" <cfif #Topic.documentItemValue# eq #code#>selected</cfif>>#name#</option>
					       </cfloop> 
					      </select>  
						        
	      			 </cfif>
				 
				 <cfelse>
								
					<cfinput type   = "Text" 
					        value   = "#Topic.documentItemValue#" 
							name    = "f_#documentcode#" 
							required="#req#" 	
							validate="#fieldvalidation#"						
							class   ="regularxl"
							size    ="#fieldlength#"
					        maxlength="#fieldlength#"
							message="Please enter a correct #DocumentDescription#">							
														
				 </cfif>		
										
			  </cfcase>			  
			  
			  <cfcase value="date">
			  
			  		<cf_intelliCalendarDate8
					FieldName="f_#documentcode#" 
					Default="#Topic.documentItemValue#"
					Class="regularxl"
					AllowBlank="True">					
															
			  </cfcase>		
			  
			   <cfcase value="map">
			   
			   		<table cellspacing="0" cellpadding="0"><tr><td>
			 
			  		<cfinput type="Text"					       
					       name        = "f_#documentcode#"
					       value       = "#Topic.documentItemValue#"
					       message     = "Please enter correct Google MAP coordinates latitude:longitude"
						   required    = "#req#"	
					       size        = "50"
					       maxlength   = "50"
					       class       = "regularxl">		
						   
					</td>
					
					<cfset jvlink = "ColdFusion.Window.create('map_#documentcode#', '#DocumentDescription#', '',{x:100,y:100,height:625,width:620,modal:true,center:true});ColdFusion.navigate('#SESSION.root#/Tools/EntityAction/HeaderFields/ObjectHeaderMAP.cfm?name=#DocumentDescription#&coordinates='+document.getElementById('f_#documentcode#').value,'map_#documentcode#')">		
		
					<td>&nbsp;<a href="javascript:#jvlink#"><font color="0080FF">See MAP</font></a></td>
					</tr>
					</table>	   
															
			  </cfcase>										 			 
			
			</cfswitch>			
			
		</td>
	   </tr>
	  
   </cfoutput>	 
  	
	   
   