<cfparam name="URL.ajaxid" default="">
	
 <!--- make sure -fields- are always made visible by default based on the action --->
   
   <cfquery name="Insert" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 INSERT INTO Ref_EntityActionPublishDocument
	 (ActionPublishNo, ActionCode,DocumentId)	   
	 SELECT   '#Object.ActionPublishNo#','#ActionCode#',R.DocumentId
	 FROM      Ref_EntityDocument R INNER JOIN
	                 Ref_EntityActionDocument A ON R.DocumentId = A.DocumentId
	 WHERE     A.ActionCode = '#ActionCode#' 
	 AND       R.DocumentType = 'field'
	 AND       R.Operational = 1
	 AND       R.DocumentMode = 'Step'
	 AND       R.DocumentId NOT IN (SELECT DocumentId 
	                                FROM   Ref_EntityActionPublishDocument 
								    WHERE  ActionCode = '#ActionCode#'
								     AND   ActionPublishNo = '#Object.ActionPublishNo#')
  </cfquery>			
   
  <cfquery name="Fields" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	   
	    SELECT R.*
	 FROM      Ref_EntityDocument R INNER JOIN
	           Ref_EntityActionDocument A ON R.DocumentId = A.DocumentId
	 WHERE     A.ActionCode = '#ActionCode#' 
	 AND       R.DocumentType = 'field'
	 AND       R.Operational = 1
	 AND       R.DocumentMode = 'Step'
	 
	 <!--- limit the fields to be shown only for designated objects --->
	 
	 AND       R.DocumentId IN (SELECT DocumentId 
	                            FROM   Ref_EntityActionPublishDocument 
								WHERE  ActionCode = '#ActionCode#'
								AND    ActionPublishNo = '#Object.ActionPublishNo#' 
								AND    Operational = 1
								AND   (
								       ObjectFilter = ''
								       OR ObjectFilter is NULL
									   OR ObjectFilter IN (SELECT ObjectFilter 
									                       FROM   OrganizationObject 
														   WHERE  ObjectId = '#Object.Objectid#')
									  )
								)	  
	ORDER BY DocumentOrder							
</cfquery>
 			
<cfset setCalendar = 0> 			
 			
<cfif fields.recordcount gte "1">
				
	<table width="100%" cellspacing="0" cellpadding="0">
	
	<cf_tl id="Additionally required Information" var="1">		
	
	<tr class="line"><td style="height:46px;padding-left:10px;padding-top:5px;font-size:19px" colspan="2" class="labellarge"><cfoutput>#lt_text#</cfoutput>:</td></tr>
	
	<tr id="fld0" class="regular">
	
	<td></td>
	<td>
					
	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">			  
		  
	<cfset i = 0>

	<cfoutput>
				
		<cfloop query="fields">		
						 
		     <tr class="line">
			    <td height="100%" width="318" valign="top" class="labelmedium" style="font-size:15px;border-right:1px solid silver;padding-top:8px;padding-left:20px;background-color:ffffff">#DocumentDescription#:<cfif fieldrequired eq "1"><font color="FF0000">*</font></cfif></td>

				<td style="padding-left:3px">
				<table width="100%" cellspacing="0" cellpadding="0">
				
					<tr>
					<td>
					
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
						  FROM   OrganizationObjectInformation
						  WHERE  ObjectId    = '#Object.ObjectId#'
						  AND    DocumentId  = '#DocumentId#' 
				    </cfquery>	
					
				    <cfset topiclist = ValueList(Topic.DocumentItem)>
					
					<cfswitch expression="#fieldtype#">		
					
						 <cfcase value="list">
						 
						 	<cfquery name="List" 
							   datasource="AppsOrganization" 
							   username="#SESSION.login#" 
							   password="#SESSION.dbpw#">
								  SELECT   *
								  FROM     Ref_EntityDocumentItem
								  WHERE    DocumentId = '#DocumentId#'
								  AND      Operational = 1
								  ORDER BY ListingOrder 
							</cfquery>	
						 
						 	<cfif fieldSelectMultiple eq "0">
																
								<cfselect name="f_#DocumentCode#" id="f_#DocumentCode#"  class="regularxxl" required="#req#" message="Provide input for : #DocumentDescription#">
									<cfif fieldrequired eq 1>
										<option value="">--<cf_tl id="Select">--</option>
									</cfif>
									<cfloop query="List">
									<option value="'#DocumentItem#'" <cfif Topic.DocumentItem eq DocumentItem>selected</cfif>>#DocumentItemName#</option>
									</cfloop>
								</cfselect>
								
							<cfelse>	
								
							<cf_UIselect name="f_#DocumentCode#" id="f_#DocumentCode#"			
									size           = "1"
									class          = "regularXXL"									
									multiple       = "Yes"													
									style          = "width:100%"	
									required       = "#req#"		
									message        = "Provide input for: #DocumentDescription#"								
									query          = "#List#"
									queryPosition  = "below"
									selected       = "#topiclist#"
									value          = "DocumentItem"
									display        = "DocumentItemName"/>
									
								<!---	
														
								<cfselect name="f_#DocumentCode#" id="f_#DocumentCode#" class="regularxl" style="height:140" multiple required="#req#" message="Provide input for: #DocumentDescription#">
									<cfloop query="List">
									<option value="'#DocumentItem#'" <cfif ListContains(topiclist, DocumentItem)>selected</cfif>>#DocumentItemName#</option>
									</cfloop>
								</cfselect>		
								
								--->
								
							</cfif>			  
						  
						  </cfcase>
						  
						   <cfcase value="checkbox">						 
						 				
								<cfif Topic.documentItemValue eq "Yes">
								<input type="checkbox" class="radiol" name="f_#documentcode#" id="f_#DocumentCode#" value="Yes" checked>
								<cfelse>
								<input type="checkbox" class="radiol" name="f_#documentcode#" id="f_#DocumentCode#" value="Yes">
								</cfif>									
									  
						  
						  </cfcase>
						  
						  <cfcase value="area">			
						  
						    <cfif DocumentLayout eq "htm"> 				
							
							<cf_textarea height="130"  color="ffffff" 
							   resize     = "Yes"  
							   value      = "#Topic.documentItemValue#" 
							   name       = "f_#documentcode#" 
							   init       = "Yes"
							   id         = "f_#DocumentCode#" 
							   toolbar="mini">#Topic.documentItemValue#</cf_textarea>													 						
							   
							 <cfelse>
							 
							 <textarea style="background-color:ffffcf;min-height:50px;max-height:100px;max-width:98%;width:98%;padding:3px;font-size:13px" 
							    name = "f_#documentcode#" id = "f_#DocumentCode#" >#Topic.documentItemValue#</textarea>
							 
							 
							 </cfif>
							     
																				
						  </cfcase>
						
						  <cfcase value="amount">
							
							<cfinput type = "Text" 
							   value      = "#Topic.documentItemValue#" 
							   name       = "f_#documentcode#" 
							   id         = "f_#DocumentCode#"
							   required   = "#req#" 							
							   class      = "regularxxl"
							   size       = "10"
						       maxlength  = "20"
							   message    = "Please enter a correct amount"
							   validate   = "float">
													
						  </cfcase>
						  
						  <cfcase value="email">
						
						    <cfinput type ="Text" 
						        value     = "#Topic.documentItemValue#" 
								name      = "f_#documentcode#" 
								id        = "f_#DocumentCode#" 
								required  = "#req#" 							
								class     = "regularxxl"
								size      = "40"
					            maxlength = "40"
								message   = "Please enter a correct email address"
								validate  = "email">
												
					      </cfcase>
						  
						  <cfcase value="text">							   
						    				  
						  	<cfif lookuptable neq "" and lookupfieldkey neq "">
							
								<cfif lookupselect eq "0">		
																		
								<cfinput type="Text"
								       name                 = "f_#documentcode#"
									   id                   = "f_#DocumentCode#"
								       value                = "#Topic.documentItemValue#"
								       message              = "Please enter #fieldvalidation#"
									   autosuggest          = "cfc:service.reporting.presentation.getfield('#DocumentId#',{cfautosuggestvalue})"							
							           maxresultsdisplayed  = "8"							  			      				      
								       showautosuggestloadingicon="Yes"
								       typeahead            = "No"
									   required             = "#req#"	
									   tooltip              = "#DocumentDescription#"
								       size                 = "#fieldlength#"						   
								       maxlength            = "#fieldlength#"
								       class                = "regularxxl">	
								   
								 <cfelse>
								 								 					 
									 <cfquery name="List" 
										datasource="#lookupdatasource#" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT  DISTINCT #LookupFieldKey#, #LookupFieldName#
										FROM    #lookuptable#		
										WHERE   #LookupFieldKey#!='#fieldDefault#'				
									 </cfquery>	
									 
									  <cfselect name="f_#documentcode#"
									      id       = "f_#DocumentCode#"
							              message  = "Please enter #fieldvalidation#"
							              query    = "List"
							              value    = "#LookupFieldKey#"
							              display  = "#LookupFieldName#"
							              selected = "#Topic.documentItemValue#"
							              tooltip  = "#DocumentDescription#"				            		              
							              required = "#req#"
										  class    = "regularxxl"
							              queryposition="below">
							         		<option value = "#fieldDefault#">#fieldDefault#</option>
							        </cfselect>
							 							 
								 </cfif>  											 		
							
							<cfelse>
																	
								<cfif topic.documentitemvalue eq "">
								   <cftry>
									   <cfset val   = fielddefault>							
									   <cfcatch>
										   <cfset val = "">
									   </cfcatch>
								   </cftry>
								<cfelse>
									<cfset val = Topic.documentItemValue>
								</cfif>		
								
																											
								<cfinput type     = "Text" 
								        value     = "#val#" 
										name      = "f_#documentcode#" 
										id        = "f_#DocumentCode#"
										required  = "#req#" 	
										validate  = "#fieldvalidation#"						
										class     = "regularxxl"
										mask      = "#fieldmask#"
										size      = "#fieldlength#"
										tooltip   = "#DocumentDescription#"
								        maxlength = "#fieldlength#"
										message   = "Please enter #fieldvalidation#">											
																	
							 </cfif>	
																		
						  </cfcase>				  
						  
						  <cfcase value="date">
						  	
								<cfif Topic.documentItemValue eq "">
									<cfif fieldDefault eq "">
									   <cfset val = "">						
									<cfelseif fieldDefault eq "now()">
										<cfset val = "#dateformat(now(),CLIENT.DateFormatShow)#">	
									<cfelse>
										<cfset val = "#dateformat(fielddefault,CLIENT.DateFormatShow)#">	
									</cfif>
								<cfelse>						
									<cfset val = "#Topic.documentItemValue#">	
								</cfif>
		
								<cfif req eq "true">
									<cfset vAllowBlank = "false">
								<cfelse>
									<cfset vAllowBlank = "true">
								</cfif>	
								
								<cfset setCalendar = 1>
								
						  		<cf_intelliCalendarDate9
									FieldName="f_#documentcode#" 
									Default="#val#"
									class="regularxxl"									
									AllowBlank="#vAllowBlank#">				
									
						  </cfcase>
						  
						  <cfcase value="map">
						  
						    <table cellspacing="0" cellpadding="0">
							
								  <tr>
							
							      <td id="map_f_#documentcode#" style="padding-top:2px;padding-bottom:2px">					 								    
								    <cf_getAddress coordinates="#Topic.documentItemValue#">									
								  </td>							
							      <td>			
							  
					  			  <input type="hidden"
								       name        = "f_#documentcode#"
									   id          = "f_#documentcode#"
								       value       = "#Topic.documentItemValue#"						 
								       size        = "50"						   
								       maxlength   = "50">	
								   
								   </td>
								   
								   <td style="width:2px"></td>
								   
								   <td>
								  
								   <img src="#SESSION.root#/Images/map.png" alt="Google MAP : [Latitude:Longitude]" name="img0" 
									  onMouseOver="document.img0.src='#SESSION.root#/Images/button.jpg'" 
									  onMouseOut="document.img0.src='#SESSION.root#/Images/map.png'"
									  style="cursor: pointer;" alt="" width="20" height="23" border="0" align="absmiddle" 
									  onClick="openmap('f_#documentcode#')">
								  						   
								   </td>
								   </tr>
								   
							   </table>	
								   															
					        </cfcase>									 			 
						
					</cfswitch>
					
					</td>
					</tr>
					
				</table>
				</td>
			   </tr>
		   		   
		    </cfloop>			   
		
			 
	 </cfoutput>	
		  	   
   </table>
   
   </td>
   </tr>
   		
	</table>
		  
     
</cfif>    

<cfif setCalendar eq 1  and URL.ajaxid neq "">
	<cfset ajaxOnLoad("doCalendar")>
</cfif>