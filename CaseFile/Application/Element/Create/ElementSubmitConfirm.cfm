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

<cf_screentop height="100%"
     scroll="No" 
	 layout="webapp" 
	 label="Confirm Amendments" 
	 banner="blue" 
	 user="yes" 
	 close="ColdFusion.Window.hide('dialogconfirm')">

<table width="94%" cellspacing="0" cellpadding="0" bgcolor="FFFFFF" align="center" class="formpadding">
		
	<tr>
	<td width="90%">	
	
		<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
		<tr class="labelit"><td>Field</td><td colspan="2">Value</td></tr>
		<tr><td colspan="3" class="line"></td></tr>								
					
			<cfquery name="getTopics" 
					datasource="AppsCaseFile" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					 SELECT   R.*
				     FROM     Ref_Topic R INNER JOIN Ref_TopicElementClass S ON R.Code = S.Code
					 WHERE    ElementClass = '#url.elementclass#'	
					 AND      Operational = 1			
					 ORDER BY S.ListingOrder,R.ListingOrder
			</cfquery>
			
			<cfset change = "0">
			
			 <!--- retrieve the last value --->
		   	 <cfquery name="Get" 
			   datasource="AppsCaseFile" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				SELECT *, CE.SourceElementId
				FROM   Element P LEFT OUTER JOIN    ClaimElement CE
					   ON P.ElementId = CE.ElementId AND CE.CaseElementId = '#url.caseelementid#'
				WHERE  P.ElementId     = '#URL.elementid#'		  						  		  
	    	</cfquery>	
										   
			<cfloop index="itm" list="Reference,ElementMemo,SourceElementId">
				
				<cfparam name="Form.#itm#" default="">
				
				<cfif itm eq "Reference">
				   <cfset fld = "ElementReference">
				<cfelse>
				   <cfset fld = itm>   
				</cfif>
				
				<cfset new = evaluate("form.#fld#")>
				<cfset old = evaluate("get.#itm#")>		
				
				<cfoutput>
				 <cfif old neq new>
						
						   <cfset change = "1">
						   					
							<tr class="labelit">
							<td width="15%">#itm#</td>
							<td width="60"><b>Was:<b></b></td>
							<td width="80%">
								<font color="808040" style="font-style: italic;">
									<cfif itm eq "SourceElementId" AND old neq "">
										<cfquery name="DocumentInfo" datasource="AppsCaseFile" username="#SESSION.login#" password="#SESSION.dbpw#">
											SELECT TopicValue AS Name FROM ElementTopic ET
											WHERE ElementId = '#old#' 
												  AND 
										          ET.Topic = (SELECT TOP 1 Code FROM Ref_TopicElementClass WHERE  ElementClass = 'Document' AND PresentationMode = '6')
									    </cfquery>	
										#DocumentInfo.Name#
									<cfelse>
										#old#
									</cfif>
								</font>
							</td>		
							</tr>
							
							<tr class="labelit">
							<td></td>
							<td><b>New:</b></td>
							<td>
								<cfif itm eq "SourceElementId">
									<cfquery name="DocumentInfo" datasource="AppsCaseFile" username="#SESSION.login#" password="#SESSION.dbpw#">
										SELECT TopicValue AS Name FROM ElementTopic ET
										WHERE ElementId = '#new#' 
											  AND 
									          ET.Topic = (SELECT TOP 1 Code FROM Ref_TopicElementClass WHERE  ElementClass = 'Document' AND PresentationMode = '6')
								    </cfquery>	
									#DocumentInfo.Name#
								<cfelse>
									#new#
								</cfif>
							</td>		
							</tr>
							
							<tr><td colspan="3" style="border-top:1px dotted silver"></td></tr>
						
					 </cfif>
				</cfoutput>	 
			</cfloop>	   		
			
			<cfoutput query="getTopics">												
				 					 	
				 <!--- retrieve the old value --->
				 				 	
			     <cfif topicclass eq "person">
				 
				    <cfparam name="Form.#TopicLabel#" default="">
				    <cfset new = evaluate("form.#topicLabel#")>
				 
				    <cfquery name="get" 
					   datasource="AppsSelection" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						SELECT * FROM Applicant 		
						WHERE    PersonNo = '#get.PersonNo#'
					</cfquery>
					  
					<cfparam name="get.#TopicLabel#" default="">					
					<cfset old = evaluate("get.#topicLabel#")>		
					
					  
				<cfelse>	
				
					<!---- Modification on August 25th 2011 as per discussion with dev, dev dev ---->
                   <cfif valueclass eq "Time">
                  
                        <cfset new = Evaluate("FORM.Topic_#Code#_hour") & ":" & Evaluate("FORM.Topic_#Code#_minute") >
                        <cfif new eq ":"> <cfset new=""> </cfif>
                                               
                   <cfelseif valueclass eq "DateTime">
                  
                        <cfset new = Evaluate("FORM.Topic_#Code#") & " " & Evaluate("FORM.Topic_#Code#_hour") & ":" & Evaluate("FORM.Topic_#Code#_minute") >
                        <cfif new eq " :"> <cfset new=""> </cfif>
                                               
                   <cfelseif valueclass eq "Boolean">
                                               
                        <cfif isDefined("FORM.Topic_#Code#")>
                                        <cfset new  = Evaluate("FORM.Topic_#Code#")>
                        <cfelse>
                                        <cfset new = "0">
                        </cfif>
                       
                   <cfelse>
				   
                  		<cfif isDefined("FORM.Topic_#Code#")>
					   		<cfset new  = Evaluate("FORM.Topic_#Code#")>
						<cfelse>
							<cfset new = "">
						</cfif>
                                               
                   </cfif>
			
				   <!--- retrieve the last value --->
			   	   <cfquery name="GetOldValue" 
					 datasource="AppsCaseFile" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						SELECT *
						  FROM   ElementTopic P
						  WHERE  P.Topic         = '#Code#'						 
						  AND    P.ElementId     = '#URL.elementid#'		  
						  AND    P.ElementLineNo = '0'		 		  
		    	   </cfquery>	
				   
				  				  				  
				   <cfif ValueClass eq "List" or ValueClass eq "Lookup"> 						   			   				  	
					   <cfset old = getOldValue.ListCode>					  
				   <cfelse>
				       <cfset old = getOldValue.TopicValue>
				   </cfif>
				   				   
				 </cfif>  				   
															
				 <cfif old neq new>
					
					   <cfset change = "1">
					   					
						<tr class="labelit">
						<td width="15%">#Description#</td>
						<td width="60"><b>Was:</td>
						<td width="80%"><font color="808040" style="font-style: italic;"><cfif old eq "">--<cfelse>#old#</cfif></font></td>		
						</tr>
						
						<tr class="labelit">
						<td></td>
						<td><b>New:</td>
						<td>#new#</td>		
						</tr>
						
						<tr><td colspan="3" class="linedotted"></td></tr>
						
					
				 </cfif>
				 			
			</cfoutput>	
					
		</table>
			
	</td>
	
	</tr>
	
	<cfif change eq "0">
			
		<tr>
		   <td colspan="3" height="40" class="labelmedium" align="center">No changes were made to this element</td>
		</tr>
			
	<cfelse>	
	
		<tr><td height="8"></td></tr>
		
		<tr>
		<td colspan="2" style="padding-top:5px" class="labelmedium"><cf_tl id="Justification">:</td></tr>
		<tr>
		<td colspan="2" align="center">
		<textarea style="width:99%; height:60;padding:3px;font-size:13px;border-radius:5px" name="ActionMemo" class="regular"></textarea>	
		</td>
		</tr>
		
		<tr><td colspan="2" align="center" style="padding-left:4px">
		
		<cf_assignid>		
		
		<cfset insert="yes">
		<cfset remove="yes">
		
        <cf_filelibraryN
			DocumentPath="CaseAmendment"
			SubDirectory="#rowguid#" 
			Filter = ""						
			Presentation="all"
			box="box_#rowguid#"
			Insert="#insert#"
			Remove="#remove#"
			loadscript="no"		
			width="100%"									
			border="1">	
			
		</td></tr>	
		
		<tr><td colspan="2" class="linedotted"></td></tr>
		
		<tr><td colspan="2" align="center" height="33">
			
	           <cfoutput>	
			   
			   <cf_tl id="Cancel" var="1">
			   <input type="button" 
					   name="Cancel" 
					   value="#lt_text#" 
					   class="button10s" 					   
					   onclick="ColdFusion.Window.hide('dialogconfirm')" 					  
					   style="height:25;width:140px">	
			          							
				<cf_tl id="Save" var="1">
				<input type="button" 
					   name="Save" 
					   value="#lt_text#" 
					   class="button10s" 					   
					   onclick="validate('#url.submitmode#','#url.caseelementid#','#url.elementid#','1','#rowguid#');ColdFusion.Window.hide('dialogconfirm')" 					  
					   style="height:25;width:140px">							   
				
				</cfoutput>			
									
				</td>
		</tr>	
	
	</cfif>

</table>

<cf_screenbottom layout="webdialog">
