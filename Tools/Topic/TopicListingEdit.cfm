
<cfset link = "systemmodule=#systemmodule#&alias=#alias#&language=#language#&topicscope=#topicscope#&topicscopetable=#topicscopetable#&topicscopefield=#topicscopefield#&topicfield=#topicfield#">

<cfajaximport tags="cfform,cfinput-autosuggest">

<cf_screentop label="Edit Topic field" scroll="No" line="no" banner="gray" jquery="Yes" bannerforce="Yes" layout="webapp">

<cfoutput>

	<script language="JavaScript">
		
		function save() {
		
		   document.edittopic.onsubmit() 
			if( _CF_error_messages.length == 0 ) {
		       return true;
			 }   
		 }	
		 
		 function doSubmit(){
			document.edittopic.submit();
		 }
	
		function option(sel) {
		  
		   if (sel != 'Text') {
		     document.getElementById("ValueLength").className="hide"
		   } else {
		     document.getElementById("ValueLength").className="regularxxl"
		   }
		   
		   if (sel != 'Lookup') {
		      lookup.className = 'hide'
			} else {
			  lookup.className = 'regular'
			}
			
			if (sel != 'List') {
			 try {
			  document.getElementById("list1").className = "hide"
			  document.getElementById("list2").className = "hide"	
			  document.getElementById("list3").className = "hide"
			 } catch(e) {}
			} else {
			 try {	 	     
				 document.getElementById("list1").className = "regular"
			     document.getElementById("list2").className = "regular"	
				 document.getElementById("list3").className = "regular"
				} catch(e) {}
			}
		}
				
		function updateList(id,tcode,smodule,alias,action){
		
			order  = document.getElementById('ListOrder').value;
			code   = document.getElementById('ListCode').value;
			value  = document.getElementById('ListValue').value;
			def    = document.getElementById('ListDefault').value;
			op     = document.getElementById('Operational').value
			
			ptoken.navigate('#SESSION.root#/tools/topic/ListSubmit.cfm?systemmodule='+smodule+'&code='+tcode+'&alias='+alias+'&listOrder='+order+'&listCode='+code+'&listValue='+value+'&listDefault='+def+'&operational='+op+'&id2='+action,id,'','','POST','listform');
			
		}
	 
	 </script>
</cfoutput>

<cfquery name="Topic" 
datasource="#alias#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	<cfif systemmodule eq "Roster">
	
		SELECT Topic as Code, Parent as TopicClass, *
		FROM   Ref_Topic
		WHERE  Topic = '#url.code#'
	
	<cfelse>
	
	    SELECT    *
    	FROM      Ref_Topic	
		WHERE     Code = '#url.code#'
	
	</cfif>
	
</cfquery>

<cf_divscroll>

<cfoutput query="Topic">

<table width="100%" height="99%">

<tr><td height="20" bgcolor="white" valign="top">
	
	<cfform method="POST" name="edittopic" action="#SESSION.root#/tools/topic/TopicListingSubmit.cfm?#link#&id2=#Code#" onsubmit="return save()">

		<table width="90%" cellspacing="0" align="center" class="formpadding formspacing">  	
				
				<tr><td height="6"></td></tr>
				<tr class="labelmedium2">
				
					<cfif systemmodule eq "Roster">
					
						<td colspan="2"></td>
						
					<cfelse>
					
						<td><cf_tl id="Entity">:</td>
						
						 <cfquery name="Mis" 
							datasource="#alias#" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT *
								FROM   Ref_ParameterMission
								WHERE  Mission IN (SELECT Mission 
						                           FROM   Organization.dbo.Ref_MissionModule 
										           WHERE  SystemModule = '#systemmodule#')						  
							 </cfquery>
							
						  <TD>
						  
						 		<select name="mission" id="mission" class="regularxxl">
									<option value="" selected>[Any]</option>
									<cfloop query="Mis">
									<option value="#Mission#" <cfif Topic.Mission eq Mis.Mission>selected</cfif>>#Mission#</option>
									</cfloop>
								</select>
							
						  </TD>		
					  
		  			</cfif>
				  
				</tr>
				
				
				<tr class="labelmedium2">
					<td><cf_tl id="Usage Class">:</td>
					<td>#TopicClass#</td>
				</tr>		
								
				<tr>		
					<td class="labelmedium2">
						<input type="hidden" value="#TopicClass#" name="TopicClass" id="TopicClass">
						<cf_tl id="Code">:
					</td>		
					<td class="labelmedium2">#Code#</td>
				</tr>
						
				<cfif systemmodule eq "Roster">
				
					<tr class="labelmedium2">
					<td width="140"><cf_tl id="Source">:</td>	
					<td width="80%">		  
					
						<cfquery name="RSource" 
						datasource="#alias#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
							FROM   Ref_Source	  
						 </cfquery>	 
						 
						 <select name="source" id="source" class="regularxxl">
						 
							  <cfloop query="RSource">
							  	 <option value="#Source#" <cfif Topic.Source eq Source>selected</cfif>><cfif Description neq "">#Description#<cfelse>#Source#</cfif></option>
							  </cfloop>
						  			 
						 </select>
					  
					</td>
					
					</tr>	
				</cfif>
							
				<tr class="labelmedium2">
						
					<td><cf_tl id="Sort">:</td>			
					<td><cfinput type="Text" 
					         value="#ListingOrder#" 
							 validate="integer"
							 name="ListingOrder" 
							 message="You must enter a sort" 
							 required="Yes" 				 
							 style="text-align:center;width:30" 
							 maxlength="3" 
							 class="regularxxl">
					</td>
				
				</tr>
				
				<cfif systemmodule eq "Roster">
		
					<cfset tablecode = "Ref_Topic">
		
				<cfelse>
		
					<cfset tablecode = "topic#systemmodule#">
					
				</cfif>
				
				<tr class="labelmedium2">
				
					<td valign="top" style="padding-top:8px"><cf_tl id="Label">:</td>		
					<td>
					
						<cfif language eq "yes">
											
							<cf_LanguageInput
								TableCode     = "#tablecode#" 
								Mode          = "Edit"
								Name          = "topiclabel"
								Id            = "topiclabel"
								Type          = "Input"
								Required      = "Yes"
								Value		  = "#TopicLabel#"
								Key1Value     = "#Code#"
								Message       = "Please enter a topic label"						
								MaxLength     = "30"
								Size          = "20"
								Class         = "regularxxl">
						
						<cfelse>
						
						   	<cfinput type     = "Text" 
						         name         = "topiclabel" 
								 Id           = "topiclabel"
								 message      = "You must enter a name" 
								 Value	      = "#TopicLabel#"
								 required     = "Yes" 
								 size         = "20" 							 				 
								 maxlength    = "30" 
								 class        = "regularxxl">		
							 
						</cfif>	 	 			 
							 
					</td>
				
				</tr>
				
				<tr class="labelmedium2">
				
					<td valign="top" style="padding-top:8px"><cf_tl id="Description">:</td>				 
					<td>
					
						<cfif language eq "yes">
					
							<cf_LanguageInput
								TableCode       = "#tablecode#" 
								Mode            = "Edit"
								Name            = "description"
								Id              = "description"
								Type            = "Input"
								Value			= "#Description#"
								Key1Value       = "#Code#"
								Required        = "Yes"
								Message         = "Please enter a topic description"
								MaxLength       = "50"						
								Size            = "50"
								Class           = "regularxxl">
						
						<cfelse>
						
						   	<cfinput type="Text" 
						         name="Description" 
								 message="You must enter a name" 
								 required="Yes" 
								 Value	= "#Description#"
								 size="50" 									 
								 maxlength="60" 
								 class="regularxxl">		
							 
						</cfif>	 	 			 
							 
					</td>
				
				</tr>
				
				<tr valign="top" class="labelmedium2">
					<td style="padding-top:8px"><cf_tl id="Tooltip">:</td>
					<td>
						 	<cfif language eq "yes">
					
								<cf_LanguageInput
									TableCode       = "#tablecode#" 
									Mode            = "Edit"
									Name            = "Tooltip"
									Id			    = "Tooltip"
									Type            = "TextArea"
									value			= "#Tooltip#"
									Key1Value       = "#Code#"
									Required        = "No"
									MaxLength       = "200"							
									Size            = "40"
									Rows            = "2"
									Class           = "regularxxl">
						
							<cfelse>
								<textarea name="Tooltip" cols="50" id="Tooltip" maxlength="200" style="font-size:14;padding:3px" class="regular" onkeyup="return ismaxlength(this)" >#Tooltip#</textarea>
							</cfif>
					</td>
				</tr>
								
				<tr class="labelmedium2">
				
					<td style="width:150px;max-width:150px"><cf_tl id="Field Type">:</td>  		
					<td>
					
				       <table>
					   <tr>
						   <td>
						   
							   <select name="ValueClass" id="ValueClass" class="regularxxl" 
								      onchange="option(this.value)">
								      <option value="List" <cfif valueclass eq "List">selected</cfif>>List</option>									  
									  <option value="Lookup" <cfif valueclass eq "Lookup">selected</cfif>>Lookup</option>
								   	  <option value="Text" <cfif valueclass eq "Text">selected</cfif>>Text</option>					
									  <option value="Date" <cfif valueclass eq "Date">selected</cfif>>Date</option>
									  <option value="DateTime" <cfif valueclass eq "DateTime">selected</cfif>>DateTime</option>		
									  <option value="Time" <cfif valueclass eq "Time">selected</cfif>>Time</option>			
									  <option value="Map" <cfif valueclass eq "Map">selected</cfif>>Location (Maps)</option>		 	
									  <option value="Boolean" <cfif valueclass eq "Boolean">selected</cfif>>Boolean Y/N</option>	
									  <option value="ZIP" <cfif valueclass eq "ZIP">selected</cfif>>ZIP</option>		
									  <option value="Memo" <cfif valueclass eq "Memo">selected</cfif>>Memo</option>											 				 					 		   
								   </select>
						   
						   </td>			   
						   <td style="padding-left:4px">
					   			   	
							<cfif valueclass eq "Text">
							   <cfset cl = "regularxl">
							<cfelse>
							   <cfset cl = "hide">
							</cfif>   
									
					     	<cfinput type="Text" 
						         name="ValueLength" 
								 message="You must enter a name" 
								 required="Yes" 
								 size="2" 					
								 value="#ValueLength#"
								 style="text-align:center;width:40;height:28px"					 
								 maxlength="3" 
								 validate="integer"				
								 class="#cl#">	
								 							 	
								 
							<cfif valueclass eq "List">
							   <cfset cl = "regularxl">
							<cfelse>
							   <cfset cl = "hide">
							</cfif>   
							
							<table id="list3" class="#cl#"><tr><td>						
							<input type="Checkbox" class="radiol" name="ValueMultiple" id="ValueMultiple" value="1" <cfif ValueMultiple eq 1>checked</cfif>>	
							</td>
							<td class="labelmedium2">Multiple</td>
							</tr></table>		
															 
							 </td>			 		
							
						</tr>
						</table>
					   
					</td>
				
				</tr>
				
				<cfif ValueClass eq "Lookup">
				  <cfset cl = "Regular">
				<cfelse>
				  <cfset cl = "Hide"> 
				</cfif>
				
				<tr class="<cfoutput>#cl#</cfoutput>" id="lookup">
					
					<td colspan="2" style="padding-left:38px">
					<table class="formpadding">
										
							<tr>
							<TD class="labelmedium2" width="120" style="padding-right:6px">Datasource:</TD>
							<TD>
							
								<cfset ds = "#ListDataSource#">
								<cfif ds eq "">
								     <cfset ds = "AppsSystem">
								</cfif>
								
								<!--- Get "factory" --->
								<CFOBJECT ACTION="CREATE"
								TYPE="JAVA"
								CLASS="coldfusion.server.ServiceFactory"
								NAME="factory">
								
								<!--- Get datasource service --->
								<CFSET dsService=factory.getDataSourceService()>
								<!--- Get datasources --->
						
								<cfset dsNames = dsService.getNames()>
								<cfset ArraySort(dsnames, "textnocase")> 
								
							    <select name="listdatasource" id="listdatasource" class="regularxl">
									<CFLOOP INDEX="i" FROM="1" TO="#ArrayLen(dsNames)#">							
									<option value="#dsNames[i]#" <cfif ds eq "#dsNames[i]#">selected</cfif>>#dsNames[i]#</option>							
									</cfloop>
								</select>
							
							</TD>
						    </TR>
															
							<tr>
							
								<TD class="labelmedium2" width="120" style="padding-right:6px">Table:</TD>
								<TD>
								
							  <cfinput type="Text"
								       name="listtable"
								       value="#ListTable#"
								       autosuggest="cfc:service.reporting.presentation.gettable({listdatasource},{cfautosuggestvalue})"
								       maxresultsdisplayed="7"
									   showautosuggestloadingicon="No"
								       typeahead="No"
								       required="No"
								       visible="Yes"
								       enabled="Yes"      
								       size="60"
								       maxlength="60"
								       class="regularxl">
									   			
							 	</TD>
								
						    </TR>
						
							<tr>	   
							    <td></td>						
								<td>														
								 <cfdiv id="showlookup"  bind="url:#SESSION.root#/tools/topic/RecordField.cfm?#link#&id=#code#&ID2={listtable}&multiple=0&ds={listdatasource}">															
								 </td>
							</TR>
															
					</table>
					</td>
				</tr>				
				
				<tr>		
					<td class="labelmedium2"><cf_tl id="Obligatory">:</td>		   
				    <td><input type="Checkbox" class="radiol" name="ValueObligatory" id="ValueObligatory" value="1" <cfif ValueObligatory eq 1>checked</cfif>></td> 			   			
				</tr>
				
				<tr>		
					<td class="labelmedium2"><cf_tl id="Attachment">:</td>		   
				    <td><input type="Checkbox" class="radiol" name="Attachment" id="Attachment" value="1" <cfif Attachment eq 1>checked</cfif>></td> 			   			
				</tr>
				
				<tr>
					<td class="labelmedium2"><cf_tl id="Operational">:</td>	
					<td><input type="Checkbox" class="radiol" name="Operational" id="Operational" value="1" <cfif Operational eq 1>checked</cfif>></td>		
				</tr>
																   
				
				<tr>	
				<td  class="line" colspan="2" height="30" align="center">				
						<input type = "submit" value = "Save" name = "Save"	onclick = "doSubmit()" class = "button10g">		
				</td>			    
				</tr>		
										
				<cfif ValueClass eq "List" or ValueClass eq "ListMulti">
				   <cfset cl = "regular">
				<cfelse>
				   <cfset cl = "hide">
				</cfif>      	
		
		</table>	
	
	</cfform>		
									
</td></tr>

<tr id="list1" class="#cl#"><td height="1" colspan="2"></td></tr> 
  
<tr id="list2" class="#cl#" height="100%" width="96%" align="center">
				
   <td width="100%" height="100%" valign="top" colspan="2" align="center" style="padding:2px;border:1px dotted silver;" id="#code#_list">
				   	  
   	 <cfset url.code = code>
   	 <cfset url.systemmodule = systemmodule>
     <cfinclude template="List.cfm">			
					 		
	</td>
					
</tr>				

</table>

</cfoutput>

</cf_divscroll>