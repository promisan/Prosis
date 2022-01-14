
<cfset link = "systemmodule=#systemmodule#&alias=#alias#&language=#language#&topicscope=#topicscope#&topicscopetable=#topicscopetable#&topicscopefield=#topicscopefield#&topicfield=#topicfield#">

<cfajaximport tags="cfform,cfinput-autosuggest">

<cf_screentop label="Add Topic field" scroll="Yes" banner="gray" layout="webapp">

<cfoutput>

	<script language="JavaScript">
		
		function addtopic(code) {
		
		   document.newtopic.onsubmit() 
			if( _CF_error_messages.length == 0 ) {
		       return true;
			 }   
		 }	
		 
		function option(sel) {
	  
			   if (sel != 'Text') {
			     document.getElementById("ValueLength").className="hide"
			   } else {
			     document.getElementById("ValueLength").className="regularxxl"
			   }
			   if (sel != 'Lookup') {
			      lookup.className='hide'
				} else {
				  lookup.className='regular'
				}
				
		}
	 
	 </script>
</cfoutput>

<cf_divscroll>

<table width="100%" height="100%">

<tr><td height="4"></td></tr>

<tr><td bgcolor="white" valign="top">

<cfform method="POST" name="newtopic" action="#SESSION.root#/tools/topic/TopicListingSubmit.cfm?#link#&id2=new" onsubmit="return addtopic()">

<table width="93%" align="center" class="formpadding formspacing">  	

		<tr>
		
			<cfif systemmodule neq "Roster">
			
				<td class="labelmedium"><cf_tl id="Entity">:</td>
				
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
							<cfoutput query="Mis">
							<option value="#Mission#">#Mission#</option>
							</cfoutput>
						</select>
					
				  </TD>		
		 <cfelse>
		 		<td colspan="2"></td>
		  </cfif>
		  
		</tr>
		
		<tr>
		<td width="140" class="labelmedium"><cf_tl id="Class">:</td>	
		<td width="80%">		  	 
			 
			 <select name="topicclass" id="topicclass" class="regularxxl">
			 
				  <cfloop index="itm" from="1" to="5">
				  <cfif evaluate("topictable#itm#name") neq "">
				        <cfset nm = evaluate("topictable#itm#name")>
						<cfoutput>  
				        <option value="#nm#">#nm#</option>
						</cfoutput>
				  </cfif>			  
				  </cfloop>
			  			 
			 </select>
		  
		</td>
		
		</tr>	

		<cfif systemmodule eq "Roster">
		<tr>
		<td width="140" class="labelmedium"><cf_tl id="Source">:</td>	
		<td width="80%">		  
		
			<cfquery name="Source" 
			datasource="#alias#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_Source			  
			 </cfquery>	 
			 
			 <select name="source" id="source" class="regularxxl">
			 
				  <cfoutput query="Source">
				  	 <option value="#Source#"><cfif Description neq "">#Description#<cfelse>#Source#</cfif></option>
				  </cfoutput>
			  			 
			 </select>
		  
		</td>
		
		</tr>	
		</cfif>
		
		<tr>
		
			<td class="labelmedium"><cf_tl id="Code">:</td>		
			<td height="25">
			
			    <cfinput type="Text" 
			         value="" 
					 name="code" 
					 id="code" 
					 message="You must enter a code" 
					 required="Yes" 
					 size="2" 
					 style="width:80;text-align:left" 
					 maxlength="20" 
					 class="regularxxl">
						 
	        </td>			
		</tr>
		
		<TR>
				
			<td class="labelmedium"><cf_tl id="Sort">:</td>			
			<td><cfinput type="Text" 
			         value="1" 
					 validate="integer"
					 name="ListingOrder" 
					 message="You must enter a sort" 
					 required="Yes" 				 
					 style="width:30;text-align:center" 
					 maxlength="3" 
					 class="regularxxl">
			</td>
		
		</tr>
		
		<cfif systemmodule eq "Roster">		
			<cfset tablecode = "Ref_Topic">		
		<cfelse>		
			<cfset tablecode = "topic#systemmodule#">
		</cfif>
		
		<tr>
		
			<td valign="top" style="padding-top:3px" class="labelmedium"><cf_tl id="Label">:</td>		
			<td>
			
			
				<cfif language eq "yes">
							
					<cf_LanguageInput
						TableCode       = "#tablecode#" 
						Mode            = "Edit"
						Name            = "topiclabel"
						Id              = "topiclabel"
						Type            = "Input"
						Required        = "Yes"
						Message         = "Please enter a topic label"						
						MaxLength       = "20"
						Size            = "20"
						Class           = "regularxxl">
				
				<cfelse>
				
				   	<cfinput type="Text" 
				         name   = "topiclabel" 
						 Id     = "topiclabel"
						 message="You must enter a name" 
						 required="Yes" 
						 size="20" 	
						 style="text-align:left" 					 
						 maxlength="20" 
						 class="regularxxl">		
					 
				</cfif>	 	 			 
					 
			</td>
		
		</tr>
		
		<tr>
		
			<td valign="top" style="padding-top:3px" class="labelmedium"><cf_tl id="Description">:</td>				 
			<td>
			
				<cfif language eq "yes">
			
					<cf_LanguageInput
						TableCode       = "#tablecode#" 
						Mode            = "Edit"
						Name            = "description"
						Id              = "description"
						Type            = "Input"
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
						 size="50" 										 
						 maxlength="60" 
						 class="regularxxl">		
					 
				</cfif>	 	 			 
					 
			</td>
		
		</tr>
		
		<tr>
			<td class="labelmedium"> <cf_tl id="Tooltip">:</td>
			<td>
				 	<cfif language eq "yes">
			
						<cf_LanguageInput
							TableCode       = "#tablecode#" 
							Mode            = "Edit"
							Name            = "Tooltip"
							Id			    = "Tooltip"
							Type            = "TextArea"
							Required        = "No"
							Value           = ""
							MaxLength       = "200"
							style           = "height:19px"
							Size            = "40"
							Rows            = "3"
							Class           = "regular">
				
					<cfelse>
						<textarea name="Tooltip" onkeyup="return ismaxlength(this)"  style="width:100%" id="Tooltip" maxlength="200" class="regular"></textarea>
					</cfif>
			</td>
		</tr>
				
		<tr>
		
			<td class="labelmedium"><cf_tl id="Field Type">:</td>  		
			<td>
			
		       <table cellspacing="0" cellpadding="0">
			   <tr>
				   <td>
				   
					   <select name="ValueClass" id="ValueClass" class="regularxxl" onchange="option(this.value)">					      
						  <option value="Lookup" selected>Lookup</option>
						  <option value="List">List</option>						 				 
					   	  <option value="Text">Text</option>
						  <option value="Numeric">Numeric</option>
						  <option value="Date">Date</option>	
						  <option value="DateTime">DateTime</option>	
						  <option value="Time">Time</option>	
						  <option value="Map">Location (Maps)</option>
						  <option value="Boolean">Boolean Y/N</option>		
						  <option value="Memo">Memo</option>					  	
						  <option value="ZIP">ZIP</option>										  	   
					   </select>
				   
				   </td>			   
				   <td style="padding-left:4px">
			   			   	
					<cfinput type="Text" 
				         name="ValueLength" 
						 message="You must enter a name" 
						 required="Yes" 
						 size="1" 						 
						 value="60"					 
						 maxlength="3"				 
						 style="width:40px;text-align:center" 
						 validate="integer"				 
						 class="hide">					
								 
				   </td>
				</tr>
				</table>
			   
			</td>
		
		</tr>
		
		<cfset cl = "regular">
		
		<tr class="<cfoutput>#cl#</cfoutput>" id="lookup">
			
			<td colspan="2" style="padding-left:40px">
			<table cellspacing="0" cellpadding="0" class="formpadding">
						
					<tr>
					<TD width="120" style="padding-right:6px" class="labelmedium"><cf_tl id="Datasource">:</TD>
					<TD>
					
						<cfset ds = "AppsSystem">
						
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
						
					    <select name="listdatasource" id="listdatasource" class="regularxl" onchange="ColdFusion.navigate('#SESSION.root#/tools/topic/RecordField.cfm?#link#&id=&ID2='+document.getElementById('listtable').value+'&multiple=0&ds='+this.value,'showfields')">
							<cfloop INDEX="i" FROM="1" TO="#ArrayLen(dsNames)#">
								<cfoutput>
									<option value="#dsNames[i]#" <cfif #ds# eq "#dsNames[i]#">selected</cfif>>#dsNames[i]#</option>
								</cfoutput>
							</cfloop>
						</select>
					
					</TD>
				    </TR>
													
					<tr>
					
						<TD width="120" style="padding-right:6px" class="labelmedium"><cf_tl id="Table">:</TD>
						<TD>
						
						  <cfinput type="Text"
						       name="listtable"		
							   id="setlist"				      
						       autosuggest="cfc:service.reporting.presentation.gettable({listdatasource},{cfautosuggestvalue})"
						       maxresultsdisplayed="7"
							   showautosuggestloadingicon="No"
							   onchange="ptoken.navigate('#SESSION.root#/tools/topic/RecordField.cfm?#link#&id=&ID2='+this.value+'&multiple=0&ds='+document.getElementById('listdatasource').value,'showfields')"
						       typeahead="No"
						       required="No"
						       visible="Yes"
							   style="padding-left:1px"
						       enabled="Yes"      
						       size="50"
						       maxlength="50"
						       class="regularxl">		
							   			
					 	</TD>
						
				    </TR>
				
					<tr>	   
					    <td></td>						
						<td>
												
						   <cfdiv id="showfields" 
							       bind="url:#SESSION.root#/tools/topic/RecordField.cfm?#link#&id=&ID2={listtable}&multiple=0&ds={listdatasource}">		
											
						 </td>
					</TR>
													
			</table>
			</td>
		</tr>		
		
		<!---
		<tr>
		    <td></td>			
			<td><cfdiv id="showclass" bind="url:#SESSION.root#/Tools/Topic/TopicListingClass.cfm?#link#&code=&class={topicclass}&mission={mission}"></td>
		</tr>
		--->		
		
		<tr>		
			<td class="labelmedium"><cf_tl id="Obligatory"></td>		   
		    <td><input type="Checkbox" class="radiol" name="ValueObligatory" id="ValueObligatory" value="1" checked></td> 			   			
		</tr>
		
		<tr>		
			<td class="labelmedium"><cf_tl id="Attachment">:</td>		   
		    <td><input type="Checkbox" class="radiol" name="Attachment" id="Attachment" value="1"></td> 			   			
		</tr>
		
		<tr>
			<td class="labelmedium"><cf_tl id="Operational"></td>	
			<td><input type="Checkbox" class="radiol" name="Operational" id="Operational" value="1" checked></td>		
		</tr>
		
		<tr><td colspan="2" class="linedotted"></td></tr>												   
		
		<tr>	
		<td colspan="2" height="35" align="center">
		
			<cfoutput>
			
				<input type="submit" 
						value="Save" 
						style="width:130px"
						onclick="addtopic('new')"
						class="button10g">
						
			</cfoutput>
		
		</td>			    
		</TR>		
</table>			

</cfform>
												
</td></tr>

</table>

</cf_divscroll>
		  