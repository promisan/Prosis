
 <cf_assignid>
  
 <cfoutput>
 <input type="hidden" name="submissionid" value="#rowguid#">

<table width="100%" border="0">
  
<tr id="applicationbox" class="hide"><td class="line"></td></tr>

 <table width="100%" class="formpadding">
	 
	 	<tr>
		<td class="labelmedium" width="250"><cf_tl id="Source">:</td>
		<td id="sourcebox">
		
		<select name="Source" id="Source" class="regularx enterastab" onchange="ColdFusion.navigate('ApplicantEntrySubmissionTopic.cfm?rowguid=#rowguid#&source='+this.value,'submission_topic')">
				<cfloop query="Source">
					<option value="#Source#" <cfif source eq url.source>selected</cfif>>#Description#</option>
				</cfloop>
		</select>
		
		</td>

	 	<cfif url.next eq "Bucket">
					
		    <input type="hidden" name="SubmissionEdition" id="SubmissionEdition" value="Generic" class="hidden">		
			<cfset url.submissionedition = "Generic">	 
		  					
		<cfelseif url.submissionedition neq "" and url.submissionedition neq "All">
		
			<input type="hidden" name="SubmissionEdition" id="SubmissionEdition" value="#url.submissionedition#" class="hidden">			
			
		<cfelse>
					
		    <TD class="labelmedium" style="padding-left:3px" width="10%"><cf_tl id="Edition">:</TD>
		    <TD>
			
				<cfquery name="edition" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  	SELECT   *
					FROM     Ref_SubmissionEdition
				    WHERE    SubmissionEdition = 'Generic' OR					
					    (							
						 Operational = 1 AND (dateexpiration > getDate() or DateExpiration is NULL)						
						)					  
				</cfquery>
						
				<select name="SubmissionEdition" id="SubmissionEdition" style="width:200" class="regularx enterastab">
					<cfloop query="edition">
						<option value="#SubmissionEdition#" <cfif submissionedition eq url.submissionedition>selected</cfif>
						onclick="ptoken.navigate('ApplicantEntrySubmissionAttachment.cfm?rowguid=#rowguid#&submissionedition='+this.value,'submission_attachment')">#EditionDescription#</option>
					</cfloop>
				</select>
		     	 			 
		    </TD>
							
		</cfif>		
		
		</tr>
		
		<!--- custom fields --->
		
		<tr>
		<td colspan="2">
				
		<cfif url.source neq "">
			<cf_securediv bind="url:ApplicantEntrySubmissionTopic.cfm?rowguid=#rowguid#&source=#url.source#"    id="submission_topic">
		<cfelse>
			<cf_securediv bind="url:ApplicantEntrySubmissionTopic.cfm?rowguid=#rowguid#&source=#source.source#" id="submission_topic">
		</cfif>
			
		</td>
		</tr>
				
		<cfquery name="Parameter" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Parameter
			WHERE  Identifier = 'A'
		</cfquery>
		
		<tr><td colspan="2" style="padding-left:0px">
		 		 
		<cf_securediv id="submission_attachment" 
			   name="submission_attachment" 
			   bind="url:ApplicantEntrySubmissionAttachment.cfm?rowguid=#rowguid#&submissionedition=#url.submissionedition#"
			   bindOnLoad="true">
		
		</td></tr>
		
		<tr><td colspan="2" style="padding-left:10px">
	
		  <table width="100%">
		  
		  <tr><td colspan="2"  class="line"></td></tr>
		  <tr>
		  
		  	  <cf_tl id="Submit" var="text">
		  			 
			  <td colspan="2" id="savemode" style="padding-top:3px" align="center">	 	
			  		  			  
				 <input type="button" style="font-size:14;width:200;height:30" value="#text#" class="button10g" onClick="save()">	
			   </td>
		  </tr>
		  </table>
	   
	      </td>
		</tr>
		
	</table>
	
 </cfoutput>	
 
 </td>
 </tr>
 </table>