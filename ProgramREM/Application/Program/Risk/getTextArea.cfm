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
<cfparam name="url.mode" default="fly">

<cfquery name="get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *				 
	  FROM   Ref_ProgramCategory		 
	  WHERE  Code = '#url.code#'		  
</cfquery>	

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
			
<cfquery name="StatusList" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  F.Code, 
	        F.Description, 					   
			F.StatusClass,					    							   							    	
		    S.Created,
			S.OfficerFirstName, 
		    S.OfficerLastName, 
		    S.ProgramStatus as Selected
	FROM    ProgramCategoryStatus S RIGHT OUTER JOIN
            Ref_ProgramStatus F ON S.ProgramStatus = F.Code AND S.ProgramCode = '#URL.ProgramCode#'
	WHERE   F.Code IN (SELECT ProgramStatus
	                   FROM   Ref_ProgramCategoryStatus	   
				 	   WHERE  Code = '#url.Code#') 				 
    ORDER By Description
</cfquery>	
						
<cfquery name="statusclasslist" dbtype="query">
	SELECT DISTINCT StatusClass
	FROM   StatusList
</cfquery>	
			
<cfif statusclasslist.recordcount gte "1">	
	<tr><td height="4"></td></tr>
</cfif>		
				    		
<cfif url.mode eq "fly">
	<cfset sc = "categorysave('1','#url.programcode#','#url.code#')">
<cfelse>
	<cfset sc = "">	
</cfif>
				 
<cfloop query="statusclasslist">			
 
	<tr>
    <td width="20%"  style="padding-left:26px;padding-right:5px" class="labelmedium"><cf_tl id="#StatusClass#">:</td>
	<td colspan="1" class="labelit">
		
		<cfquery name="StatusSelect" dbtype="query">
	       SELECT *
	       FROM   StatusList
		   WHERE  StatusClass = '#StatusClass#'					
	    </cfquery>
		
		<cfoutput>													 							 																								
			<select name="Status#url.code#_#StatusClass#" style="width:200px" class="regularxl enterastab" 
			   onchange="#sc#">				
			 	
				 <option value="">n/a</option>				
				 <cfloop query="StatusSelect">
				  <option value="#Code#" <cfif Selected eq Code> selected</cfif>>#Description#</option>
				 </cfloop>
			
			</select>
		</cfoutput>
		
	</td>
	</tr>
				
</cfloop>				

<cfif statusclasslist.recordcount gte "1">			
	<tr><td height="4"></td></tr>
</cfif>		
								
<cfquery name="getCodes" 
   datasource="AppsProgram" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT *
    FROM   Ref_ProgramCategoryProfile R, Ref_TextArea T
	WHERE  T.Code = R.TextAreaCode
    AND    R.Code = '#url.Code#'			  
</cfquery>		

<cfset format = "Text">	

<cfif getCodes.recordcount gte "1">

	<tr><td colspan="2" style="padding-right:20px">
	
	<cfif getCodes.entrymode eq "regular">
	   <cfset format = "Text">	   
	<cfelse>
	   <cfset format = "HTML">	  
	</cfif>
												
	<cf_ProgramTextArea
		Table           = "ProgramCategoryProfile" 
		Domain          = "Category"
		TextAreaCode    = "#quotedvalueList(getCodes.TextAreaCode)#"
		Field           = "#url.code#"
		OnChange        = "#sc#"		
		Format          = "#format#"
		FieldOutput     = "ProfileNotes"
		Join            = "RIGHT OUTER JOIN"
		Mode            = "EDIT"
		Key01           = "ProgramCode"
		Key01Value      = "#URL.ProgramCode#"
		Key02           = "ProgramCategory"
		Key02Value      = "#code#">
		
	</td></tr>	
	
</cfif>	

</table>

<cfif format eq "HTML">
	<cfset ajaxonload("initTextArea")>
</cfif>	
