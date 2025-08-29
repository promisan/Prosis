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
<cf_tl id="Add selected elements" var="1">

<cf_screentop height="100%"
     scroll="No" 
	 layout="webapp" 
	 label="#lt_text#" 
	 banner="blue" 
	 user="yes" 
	 close="ColdFusion.Window.hide('addElements')">	
	
<cfparam name="form.ListSelect" default="">

<cf_tl id="No elements selected" var="1">

<cfif form.ListSelect eq "">

	<script>
		alert("<cfoutput>#lt_text#</cfoutput>")
	</script>

<cfelse>

	<cfquery name="Topic" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	    SELECT Code
		FROM   Ref_TopicElementClass 
		WHERE  ElementClass = 'Document' 
		AND    PresentationMode = '6'		
	</cfquery>		
			
	<cfform method="POST" name="claimelement" onsubmit="return false">
	
	<table width="97%" cellspacing="0" cellpadding="0" bgcolor="FFFFFF" align="center" class="formpadding">

	<tr>
		<td width="90%" valign="top" style="padding-top:4px"><font face="Verdana" size="2">
		  <cf_tl id="Please select supporting documents accordingly">:
		</font><br><br>
		</td>
	</tr>

	<cfset i=0>
	
    <cfloop index="id" list="#Form.ListSelect#">
	
	 <cfset i=i+1>

	 <!--- Check if it is associated to the CaseFile already ---->
	 <cfquery name="check" 
			  datasource="AppsCaseFile" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  
			  SELECT *
			  FROM   ClaimElement
			  WHERE  ElementId = '#id#'
			  AND    ClaimId   = '#url.claimid#'
			  
	 </cfquery>
	 
	 <!--- check if the element is an association source ---->
	<cfquery name="AssociationSource" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  EC.AssociationSource Value
		FROM    Element E
		INNER   JOIN    Ref_ElementClass EC
	            ON      E.ElementClass = EC.Code
		WHERE   ElementId = '#id#'
	</cfquery>
	 
	 <tr>
	   <td>	
		
			<table width="100%">
				<tr>
				<td>
					<cfif check.recordcount eq 0>
						<cfoutput><input type="hidden" value="#id#" name="element_#i#"></cfoutput>
					<cfelse>
						<cfset i = i-1> <!--- Do not count it in the submit if already exist in this case file--->
					</cfif>
					
			   	    <cfset key = "#id#">
				    <cfinclude template="ElementView.cfm">
				</td>
				</tr>
				
				<tr height="2px" ><td></td></tr>
				<tr><td colspan="2" height="1" class="linedotted"></td></tr>
				<tr height="2px" ><td></td></tr>
								
				<tr>
				<td align="right">
					
					
				 <cfif check.recordcount eq 0 and AssociationSource.Value eq 0>
					
					<!--- Get all supporting documents of the element --->
					<cfquery name="document" 
						datasource="AppsCaseFile" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
						SELECT ET.ElementId, E.Reference, ET.TopicValue as Name
						FROM   ElementTopic ET
						INNER  JOIN
							   (
							  		SELECT DISTINCT SourceElementId
									FROM   ClaimElement
									WHERE  ElementId = '#id#'
							   ) D
						ON     ET.ElementId = D.SourceElementId
					    AND 
						ET.Topic = '#topic.Code#'
						INNER JOIN  Element E
							  ON    E.ElementId = ET.ElementId
						
					</cfquery>
					
					<!--- Get default supporting document --->
					<cfquery name="default" 
						datasource="AppsCaseFile" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
						SELECT TOP 1 SourceElementId
						FROM   ClaimElement
						WHERE  ElementId = '#id#'
						AND    SourceElementId IS NOT NULL
						ORDER  BY CREATED ASC
						
					</cfquery>
					
					<cf_tl id="Supporting document">: &nbsp;&nbsp;
				
					<select name="document_<cfoutput>#i#</cfoutput>" class="regularxl">
					<cfoutput query="document">
						<option value="#document.ElementId#" <cfif default.SourceElementId eq document.ElementId>selected</cfif>>(#document.reference#) #document.Name#</option>	
					</cfoutput>
					</select>
					
				 <cfelseif check.recordcount gt 0>
					<font color="red"><cf_tl id="Element is already associated to this CaseFile."></font>
				 <cfelse>
				 	<!--- element is association source --->
				 </cfif>
					
				</td>
				</tr>
				
				<tr height="3px"><td></td></tr>
				
			</table>		
		
		</td>
	  </tr>	
	  
	  <tr height="7px"><td></td></tr>

	</cfloop>
	
	  <tr>
	  <td align="center">
	  	<cf_tl id="Save" var="1">
		<cfoutput>
			<input type="button" 
			   name="Save" 
			   value="#lt_text#" 
			   class="button10s" 					   
			   onclick="javascript:ColdFusion.navigate('ElementMatchedSubmit.cfm?claimid=#url.claimid#&elements=#i#','detailsubmit','','','POST','claimelement')" 					  
			   style="height:25;width:140px">	
		</cfoutput>
		
			<cfdiv id="detailsubmit" class="hide" >
	  </td>
	  </tr>
		
	</table>	
		
	</cfform>
		
</cfif>		


<cf_screenbottom layout="webdialog">