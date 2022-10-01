
<cfparam name="url.owner" default="">

<cfif SearchResult.recordcount eq "0">

    <table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	<tr><td class="linedotted"></td></tr>
	<tr><td height="25" class="labelmedium" align="center"><b><font color="red"><cf_tl id="Attention">:</font> <cf_tl id="No background records found"></b></td></tr></table>
	
<cfelse>	

	<table width="98%" border="0">
	
	  <tr>
	  	<td colspan="2" id="ExperienceSummary">			
			<cfset url.ApplicantNo=SearchResult.ApplicantNo>
			<cfinclude template="BackgroundSummary.cfm">
		</td>
	  </tr>
	  <tr>
	  	<td width="100" style="height:40px;padding-left:10px" class="labelit"><cf_tl id="Priority">:</td>
		<td width="90%">
			<select name="PriorityCode" class="regularxl">
			<cfoutput query="Priority">
				<option value="#Code#" <cfif Line.PriorityCode eq "#Code#">selected</cfif>>#Description#</option>
			</cfoutput>	
			</select>	
		</td>
	  
	  </tr>  
	   
	  <cf_tl id="Please Select relevant PHP information" var="1">
	  <cfset msg1 = lt_text>
	  <cf_tl id="which needs to be verified" var="1">
	  <cfset msg2 = lt_text>
	  
	  <tr><td colspan="2" bgcolor="eaeaea" class="labellarge" style="height:40;padding-left:10px"><cfoutput>#msg1# #msg2#</cfoutput></b> </font></td></tr>
	  
	  <tr>
	    <td width="100%" colspan="2">
		
	    <table width="100%">
		
	    <TR class="line fixlengthlist labelmedium fixrow">
	       <td height="25" width="5%" align="center">
			   <input type="checkbox" class="radiol" name="selected_all" id="selected_all" value="All" onClick="selectexperienceall(this.checked);">
			   </td>
	       <TD><cf_tl id="Organization"></TD>
	       <TD><cf_tl id="Function"></TD>
		   <TD><cf_tl id="From"></TD>
		   <TD><cf_tl id="To"></TD>
	   </TR>
	  
	   <cfset module = "">
	   	  
	   <cfoutput query="SearchResult" group="Source">
	   
	   <tr><td colspan="5" class="labellarge" style="padding-left:10px;height:35px">#Source#</td></tr>
	   
		   <cfoutput>
		      
		   <cfif CurrentAssigned is ''>
		      <tr class="linedotted labelmedium2" bgcolor="f8f8f8" id="line#currentrow#" style="border-top:1px solid silver">
		   <cfelse>
		      <tr class="linedotted labelmedium" class="highLight1" id="line#currentrow#" style="border-top:1px solid silver">
		   </cfif>   
		   <td width="5%" align="center" style="padding:2px">
		      <cfif CurrentAssigned is ''>
			    <input type="checkbox" class="radiol" id="selected_#currentRow#" name="selected" value="#ExperienceId#" onClick="selectexperience(this,this.checked,'#currentrow#')">
		   	  <cfelse>
		        <input type="checkbox" class="radiol" id="selected_#currentRow#" name="selected" value="#ExperienceId#" checked onClick="selectexperience(this,this.checked,'#currentRow#')">
			  </cfif>
		      </TD>
		      <TD>#OrganizationName#</TD>
			  <TD>#ExperienceDescription#</TD>
		      <TD style="padding-right:10px">#DateFormat(ExperienceStart, CLIENT.DateFormatShow)#</td>
			  <TD style="padding-right:10px">#DateFormat(ExperienceEnd, CLIENT.DateFormatShow)#</TD>
		   </TR>
		   
		   <cfif OrganizationTelephone neq "">
		   <tr class="labelmedium2" style="height:20px">
		   		<td></td>
				<td><cf_tl id="Phone">:</td>
			    <td colspan="3"><font color="00A600">#OrganizationTelephone#</td>
		   </tr>
		   </cfif>
		   
		   <cfif supervisorname neq "">
			   <tr class="labelmedium2" style="height:20px">
			   		<td></td>
					<td><cf_tl id="Supervisor">:</td>
					<td colspan="3"><font color="blue">#SupervisorName#</td>    
			   </tr>
		   </cfif>
		   
		   <cfif Organizationemail neq "">
		      <tr class="labelmedium2" style="height:20px">
		   		<td></td>
				<td><cf_tl id="Mail">:</td>
		   		<td colspan="3"><font color="blue">#OrganizationeMail#</td>
		      </tr>
		   </cfif>
		   
		   <tr class="labelmedium2" style="height:20px">
		   		<td></td>
				<td><cf_tl id="Address">:</td>
				<td colspan="3"><font color="00A600">#OrganizationAddress# #OrganizationZIP# #OrganizationCity# #OrganizationCountry#</td>
		   </tr>
		      
		   <cfif ExperienceCategory eq "Employment">
		   
				<cfquery name="Detail" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT D.TopicValue
					FROM   ApplicantBackgroundDetail D
					WHERE  D.ApplicantNo  = '#ApplicantNo#'
					AND    D.ExperienceId = '#ExperienceId#'
					AND    D.Topic = 'BACK_01'    <!--- KRW hard coded for the moment --->
				</cfquery>					
				
				<cfif Detail.topicvalue neq "">	
					<tr><td></td><td colspan="4" class="labelit">#Detail.TopicValue#</td></tr>		
				</cfif>		
				
				<cfif CurrentAssigned eq "">
					<cfset cl = "hide">
				<cfelse>
				    <cfset cl = "regular">
				</cfif>
				
				<tr class="#cl#" id="experience#currentRow#">
				
				       <td></td>
					   <td colspan="4" style="padding-left:0px;border-top:1px dotted silver;border-bottom:1px dotted silver">
					   <cfset url.box       = "box#currentrow#">			   			   
				       <cfset url.owner     = line.owner>  <!--- filter the class to show just relevant classes --->
					   <cfset url.id        = ExperienceId>
				       <cfset url.id1       = ExperienceCategory>
				       <cfset url.candidate = 0>
					   <cfset Group        = "'Experience','Region'">
					   <cfinclude template="../Keyword/KeywordEntry.cfm"> 	
					   	
				</td></tr>						
				   
		   </cfif>
		   	   
		   </CFOUTPUT>
	   
	   </CFOUTPUT>
	   
	    <tr><td colspan="6">
	  
	  	<cf_TopicView 
			ApplicantNo = "#SearchResult.ApplicantNo#"
			Owner       = "#URL.Owner#"
			Mode        = "Edit" >   
			
			</td></tr>
		      
		</TABLE>
	</td>
	</tr>
	
	</table>
	
</cfif>