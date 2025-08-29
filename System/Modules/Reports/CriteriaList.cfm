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
<cf_screentop height="100%" html="No" jquery="Yes">

<cfparam name="URL.ID2" default="">

<cfset cnt = 0>

<cfquery name="Criteria" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ReportControlCriteria
	WHERE ControlId = '#URL.ID#'
	AND CriteriaName = '#URL.ID1#' 
</cfquery>

<cfquery name="Detail" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     Ref_ReportControlCriteriaList
	WHERE    ControlId = '#URL.ID#'
	AND      CriteriaName = '#URL.ID1#'
	ORDER BY ListOrder
</cfquery>

<cf_divscroll>

<cfform action="CriteriaListSubmit.cfm?Status=#URL.Status#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#" method="POST" name="fund">

	<table width="95%" align="left">
	    
	  <tr>
	    <td width="100%" class="regular">
	    <table width="100%" class="formpadding navigation_table">
			
	    <TR class="labelmedium2 line fixlengthlist">
		   <td><cf_tl id="Value"></td>
		   <td><cf_tl id="Description"></td>
		   <td><cf_tl id="Sort"></td>
		   <td align="center"><cf_tl id="Enable"></td>
		   <td style="max-width:30px"></td>
		   <td style="max-width:30px"></td>
	    </TR>	
		
		<cfoutput>
		<cfloop query="Detail">
		
		<cfset nm = ListValue>
		<cfset de = ListDisplay>
		<cfset od = ListOrder>
		<cfset op = Operational>
												
		<cfif URL.ID2 eq nm>
		
		    <input type="hidden" name="ListValue" id="ListValue" value="<cfoutput>#nm#</cfoutput>">
												
			<TR class="line labelmedium2 navigation_row fixlengthlist">
			   <td>#nm#</td>
			   <td>
			   	   <cfinput type="Text" value="#de#" name="ListDisplay" message="You must enter a description" required="Yes" size="30" maxlength="30" class="regularxl">
	           </td>
			    <td>
			   	   <cfinput type="Text"
			       name="ListOrder"
			       value="#od#"
			       message="You must enter a valid order"
			       validate="integer"			      	     
			       size="2"
			       maxlength="2"
			       class="regularxl">
	           </td>
			   <td class="regular" align="center">
			      <input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" <cfif "1" eq Operational>checked</cfif>>
				</td>
			   <td colspan="2" style="padding-right:3px" align="right"><input style="width:80px" type="submit" value="Update" class="button10g"></td>
		    </TR>	
					
		<cfelse>
		
			<TR  class="line labelmedium2 navigation_row fixlengthlist">
			   <td>#nm#</td>
			   <td>#de#</td>
			   <td>#od#</td>
			   <td align="center"><cfif op eq "0"><b>No</b><cfelse>Yes</cfif></td>
			   <td align="center">
			     <cfif URL.Status eq "0" or SESSION.isAdministrator eq "Yes">				  
			     <A href="CriteriaList.cfm?Status=#URL.Status#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#nm#">
				 <img src="#SESSION.root#/Images/edit.gif" alt=""  border="0">
				 </a>
				 </cfif>
			   </td>
			   <td align="center">
			    <cfif URL.Status eq "0" or SESSION.isAdministrator eq "Yes">
			    <A href="CriteriaListPurge.cfm?Status=#URL.Status#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#nm#">
				<img src="#SESSION.root#/Images/delete5.gif" alt="" border="0">
				<a>
				</cfif>
			  </td>
			   
		    </TR>	
		
		</cfif>
						
		</cfloop>
		</cfoutput>
						
		<cfif URL.ID2 eq "" and (URL.Status eq "0" or SESSION.isAdministrator eq "Yes")>
					
			<TR  class="line labelmedium fixlengthlist">
			<td>
			   <cfinput type="Text" name="ListValue" message="You must enter a value" required="Yes" size="20" maxlength="20" class="regularxl">			
			</td>
			
			<td>
			   <cfinput type="Text" name="ListDisplay" message="You must enter a description" required="Yes" size="30" maxlength="30" class="regularxl">
			</td>
			
			<td>
			  <cfinput type="Text"
			       name="ListOrder"
			       value="#detail.recordcount+1#"
			       message="You must enter a valid order"
			       validate="integer"			      	     
				   style="text-align:center"
			       size="1"
			       maxlength="2"
			       class="regularxl">
			</td>
			
			<td align="center">
				<input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" checked>
			</td>
								   
			<td colspan="2" align="right" style="padding-right:4px"><input  style="width:80px" type="submit" value=" Add " class="button10g"></td>
			    
			</TR>	
			
			<cfset cnt = cnt + 25>
								
		</cfif>	
		
		</table>
		
		</td>
		</tr>
					
	</table>			

	<cfoutput>
	<script language="JavaScript">
	
	{
	
	frm  = parent.document.getElementById("ilist");
	he = 35+#cnt#+#detail.recordcount*25#;
	frm.height = he
	}
	
	</script>
	</cfoutput>

</cfform>

</cf_divscroll>
