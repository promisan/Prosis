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
<cfparam name="attributes.datasource" default="AppsCaseFile">
<cfparam name="attributes.tablename"  default="stQuestionaireTopic">
<cfparam name="attributes.keyfield1"  default="">
<cfparam name="attributes.keyvalue1"  default="">
<cfparam name="attributes.keyfield2"  default="">
<cfparam name="attributes.keyvalue2"  default="">
<cfparam name="attributes.name"       default="input">
<cfparam name="attributes.field"      default="">
<cfparam name="attributes.mode"       default="Edit">

<cfoutput>
		
	<cfdiv id="i#attributes.name#">
	
	<table width="99%" align="center" border="1" frame="hsides" rules="none" bordercolor="d5d5d5" cellspacing="0" cellpadding="0">
	
	<cfif attributes.mode eq "read">
	
		<cfquery name="Get" 
			datasource="#attributes.DataSource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			     SELECT #attributes.field#
			     FROM #attributes.TableName# 
				 WHERE #attributes.keyfield1# = '#attributes.keyvalue1#'
				 <cfif attributes.keyfield2 neq "">
				 AND   #attributes.keyfield2# = '#attributes.keyvalue2#' 
				 </cfif>
		</cfquery>
	
		<tr>							
		   <td width="100%" bgcolor="ffffff">#evaluate("get.#attributes.field#")#</td>
		</tr>	
	
	<cfelse>
	
		<tr><td valign="top" height="100%" bgcolor="ffffff" style="border-left: 1px solid Silver;">
						  
			  <button type="button" 
			          name="Save"  id="Save"
			          style="width:21;height:21"
			          class="button3" 
					  onclick="javascript:getformfield('edit','#attributes.datasource#','#attributes.tablename#','#attributes.keyfield1#','#attributes.keyvalue1#','#attributes.keyfield2#','#attributes.keyvalue2#','#attributes.field#','#attributes.name#')">
				  
			 	 <img src="#SESSION.root#/Images/edit.gif" align="absmiddle" alt="Save" border="0">
								
			  </button>		
			  			   
		</td>
		<td style="border-left: 1px solid Silver;">&nbsp;</td>
			
		<td width="100%">
		
		<cfquery name="Get" 
			datasource="#attributes.DataSource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			     SELECT #attributes.field#
			     FROM #attributes.TableName# 
				 WHERE #attributes.keyfield1# = '#attributes.keyvalue1#'
				 <cfif attributes.keyfield2 neq "">
				 AND   #attributes.keyfield2# = '#attributes.keyvalue2#' 
				 </cfif>
		</cfquery>
		
		  #evaluate("get.#attributes.field#")#
			
	    </td>
		
		</tr>	
	
	</cfif>
	
	</table>
	
	</cfdiv>	

</cfoutput>


