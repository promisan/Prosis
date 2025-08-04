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

<cfquery name="Param" 
          datasource="AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
	         SELECT * 
             FROM   Parameter
</cfquery>   
	  
<cfquery name="qDetails" DataSource="AppsEmployee">
   	SELECT   PositionNo,
	         PostGrade,
			 LastName,
			 FirstName,
			 FullName,
			 SourcePostNumber,
			 PersonReference,
			 Incumbency,
			 IndexNo,
			 PersonNo
	FROM     vwAssignment v
	WHERE    v.DateEffective  < getdate()
	AND      v.DateExpiration >= getDate()
	<cfif url.tree neq "Administrative">
	AND      OrgUnitOperational='#url.OrgUnit#'
	<cfelse>
	AND      OrgUnitAdministrative='#url.OrgUnit#'
	</cfif>
	AND      AssignmentStatus in ('0','1')
	ORDER BY PostOrder, LastName
 </cfquery>

<!--- show pictures of the people of the unit that is selected --->

<cfquery name="Unit" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Organization
	 WHERE  OrgUnit   = '#url.orgunit#' 
</cfquery>

<table cellspacing="0" cellpadding="0" width="100%" class="formpadding">

<cfoutput query="Unit">
<tr><td class="labelit" align="center" height="22">#Unit.OrgUnitName#</td></tr>
<tr><td height="1" class="linedotted"></td></tr>
<tr><td height="4"></td></tr>
</cfoutput>

<cfif qDetails.recordcount eq "0">
	
		<tr><td height="22" class="labelit" align="center">No records found</td></tr>
	
	</cfif>		

<cfoutput query="qDetails">

<tr><td align="center">

		<cfif FileExists("#SESSION.rootDocumentPath#\EmployeePhoto\#IndexNo#.jpg")>        
						
		   <cfset pict = IndexNo>		
		   
		<cfelseif FileExists("#SESSION.rootDocumentPath#\EmployeePhoto\#PersonReference#.jpg")>
			   
	       <cfset pict = PersonReference>
		   		   
		<cfelse>
		
		   <cfset pict = "">   
		   
		</cfif>
		
		<cfif pict eq "">   
		                              				    
                <table height="#Param.PictureHeight-20#" width="#Param.PictureWidth-20#" style="border:1px dotted silver">
                   <tr>
                      <td align="center" class="labelit">                                          
                            <font color="FF0000">Sorry, picture<br>not available  </font>
                      </td>
                   </tr>   	

                </table>  
		    	
		 <cfelse>
		   						  
			    <img src="#SESSION.rootDocument#\EmployeePhoto\#pict#.jpg" alt="Picture" name="Employee Photo" id="Employee Photo" width="#Param.PictureWidth-20#" height="#Param.PictureHeight-20#" border="1" align="middle">
			 						   
		 </cfif>  				

</td></tr>

<tr><td align="center" class="labelit">
    <a href="javascript:EditPerson('#PersonNo#')">
    <font color="0080C0">#FirstName# #LastName#</font>
	</a>
	</td>
</tr>
<tr><td height="4"></td></tr>

</cfoutput>

</table>