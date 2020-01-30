<!--- check for external fields --->

<cfparam name="attributes.EntityId" default="{00000000-0000-0000-0000-000000000000}">
<cfparam name="attributes.Mode" default="'header'">
<cfparam name="attributes.EntityCode" default="">

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
	 AND       R.EntityCode = '#Object.EntityCode#'
	 AND       R.DocumentMode IN (#preserveSinglequotes(attributes.mode)#)
	 <!---
	 AND       R.DocumentId IN (SELECT DocumentId 
	                            FROM   Ref_EntityActionPublishDocument 
								WHERE  ActionPublishNo = '#Object.ActionPublishNo#' and Operational = 1)	
	 --->							
	ORDER BY DocumentOrder								
  </cfquery>

<cfform action="#SESSION.root#/tools/entityAction/HeaderFields/ObjectHeaderFieldsSubmit.cfm?objectid=#object.objectid#&caller=#attributes.caller#" 
   method="POST">
  
  <table width="98%" cellspacing="0" cellpadding="0" class="formpadding">
  
  <tr><td height="3"></td></tr>
   
  <cfoutput query="fields">   
      
     <tr>
	    <td width="18%" 
		   height="25">&nbsp;&nbsp;&nbsp;&nbsp;#DocumentDescription#:<cfif fieldrequired eq "1"><font color="FF0000">*</font></cfif></td>
				
		<td style="z-index:#20-currentrow#; position:relative;padding:0px">
			
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
			  WHERE ObjectId    = '#Object.ObjectId#'
			  AND   DocumentId  = '#DocumentId#'
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
								
				<select name="f_#DocumentCode#" id="f_#DocumentCode#" required="No">
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
						class="amountH"
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
						class="regularH"
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
							   tooltip     = "#DocumentDescription#"
						       size        = "#fieldlength#"						   
						       maxlength   = "#fieldlength#"
						       class       = "regularH">	
		       
				    <cfelse>
	      
					      <cfquery name="List" 
					       datasource="#LookUpDataSource#" 
					       username="#SESSION.login#" 
					       password="#SESSION.dbpw#"> 
					         SELECT  #LookUpFieldKey# as code,#LookUpFieldName# as name
					           FROM  #LookUpTable#
					        ORDER BY #LookUpFieldKey#
					      </cfquery> 
					        
					      <select name="f_#DocumentCode#" id="f_#DocumentCode#" required="Yes"> 
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
							class   ="regularH"
							size    ="#fieldlength#"
							tooltip = "#DocumentDescription#"
					        maxlength="#fieldlength#"
							message="Please enter a correct #DocumentDescription#">							
														
				 </cfif>		
										
			  </cfcase>			  
			  
			  <cfcase value="date">
			  
			  		<cf_intelliCalendarDate8
					FieldName="f_#documentcode#" 
					Default="#Topic.documentItemValue#"
					Class="regularH"
					AllowBlank="True">					
															
			  </cfcase>		
			  
			   <cfcase value="map">
			   
			   		<table cellspacing="0" cellpadding="0"><tr><td>
			 
			  		<cfinput type="Text"					       
					       name        = "f_#documentcode#"
					       value       = "#Topic.documentItemValue#"
					       message     = "Please enter correct Google MAP coordinates latitude:longitude"
						   required    = "#req#"	
						   tooltip     = "#DocumentDescription#"
					       size        = "50"						   
					       maxlength   = "50"
					       class       = "regularH">		
						   
					</td>
					
					<cfset jvlink = "ColdFusion.Window.create('map_#documentcode#', '#DocumentDescription#', '',{x:100,y:100,height:625,width:620,modal:true,center:true});ColdFusion.navigate('#SESSION.root#/Tools/EntityAction/HeaderFields/ObjectHeaderMAP.cfm?name=#DocumentDescription#&coordinates='+document.getElementById('f_#documentcode#').value,'map_#documentcode#')">		
		
					<td>&nbsp;<a href="javascript:#jvlink#"><font color="0080FF">See MAP</font></a></td>
					</tr>
					</table>	   
															
			  </cfcase>										 			 
			
			</cfswitch>			
			
		</td>
	   </tr>
	   
	   <tr><td colspan="2" class="linedotted"></td></tr>		
   
   </cfoutput>	 
  	
	 <tr><td colspan="2" align="center"><input value="Save" type="submit" class="button10g" name="Save" id="Save"></td></tr>
	 
	 <tr><td height="10"></td></tr>
   
   </table>
   
</cfform>    
	   
   