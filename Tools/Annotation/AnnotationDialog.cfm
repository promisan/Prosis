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

<!--- my dialog for entering stuff for this document line --->

<cfquery name="Color" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   UserAnnotation
	 WHERE  Account = '#SESSION.acc#'	
	 AND    Operational = 1
	 ORDER BY ListingOrder
</cfquery>

<!---	
<cf_screentop height="100%" scroll="no" html="yes" layout="webapp" blur="Yes" bannerheight="55" banner="blue" label="Internal Memo" option="Annotate and prioritise this document">
--->

<cfoutput>
	
<form action="#session.root#/tools/annotation/AnnotationSubmit.cfm?box=#url.box#&entity=#url.entity#&key1=#url.key1#&key2=#url.key2#&key3=#url.key3#&key4=#url.key4#" 
    method="POST" target="annotationprocess" style="height:97.5%">
				
	<table width="95%" height="100%" align="center">
			
	<cfset ann = "">  	
		
	<tr><td colspan="3" style="padding-top:4px">
	
		<cfquery name="Other" 
				 datasource="AppsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT R.Description, 
				        R.Color,
						U.OfficerLastName, 
						U.OfficerFirstName, 
						U.Annotation,
						U.Created
				 FROM   UserAnnotationRecord U, UserAnnotation R
				 WHERE  U.Account      = R.Account
				 AND    U.AnnotationId = R.AnnotationId
				 -- AND    U.Account      != '#SESSION.acc#'
				 AND    U.EntityCode   = '#url.entity#'			 
				 AND    U.Scope        = 'Shared'
				 <cfif key1 neq "">
				 AND    U.ObjectKeyValue1 = '#url.key1#'	
				 </cfif>
				 <cfif key2 neq "">
				 AND    U.ObjectKeyValue2 = '#url.key2#'	
				 </cfif>
				 <cfif key3 neq "">
				 AND    U.ObjectKeyValue3 = '#url.key3#'	
				 </cfif>
				 <cfif key4 neq "">
				 AND    U.ObjectKeyValue4 = '#url.key4#'	
				 </cfif>
				 ORDER BY U.OfficerUserId	 		
	    </cfquery>	
		
		<table width="100%" class="formpadding navigation_table">
		
		<tr class="line labelmedium">
		  <td colspan="4" style="font-size:20px"><cf_tl id="Shared Notes"></td>
		</tr>
		
		<cfloop query="other">
		
			<tr class="labelmedium2 fixlengthlist navigation_row">
				<td height="20" style="padding-right:4px">
					<table>
					 <tr><td bgcolor="#color#" style="width:15px;height:15px;border: 1px solid gray;"></td></tr>
					</table>
				</td>
				<td>#Description#</td>
				<td>#OfficerFirstName# #OfficerLastName#</td>				
				<td align="right">#dateformat(created,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")#</td>				
			</tr>
			
			<cfif Annotation neq "">
				<tr class="labelmedium line navigation_row_child"><td></td><td colspan="3">#Annotation#</td></tr>		
			</cfif>
		
		</cfloop>
	
	</table>
	
	</td>
	</tr>
		
	<tr><td align="center" height="35">
	
		<!--- top menu --->
				
		<table width="100%" border="0" align="center" class="formpadding">	
		
		<tr class="line">
		
			<cfset ht = "38">
			<cfset wd = "38">
		
		    <cf_menutab item       = "1" 
		            iconsrc    = "Memo.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					padding    = "1"
					class      = "highlight1"
					name       = "My Personal Memo">	
					
			<cfset itm = 2>	
				
			<cf_menutab item       = "2" 
		            iconsrc    = "Notes.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 	
					padding    = "1"				
					name       = "My Shared Notes">		
					
			<td width="20%"></td>		
		
		</tr>		
		
		</table>
		
	</tr>							
	
	
	<tr><td height="96%">	
	
			<cf_divscroll style="height:96%"> 		
	
			<table width="100%" height="100%" align="center">	 
					  
				<cf_menucontainer item="1" class="regular">				
					<cfinclude template="AnnotationDialogPersonal.cfm">				
				</cf_menucontainer>
				
				<cf_menucontainer item="2" class="hide">				
					<cfinclude template="AnnotationDialogShared.cfm">				
				</cf_menucontainer>
						
			</table>
			
			</cf_divscroll>
			
			</td>
			
		</tr>		
		
	<tr><td align="center">
		<input type="submit" name="Save" id="Save" value="Save" class="button10g" style="width:200px;font-size:15px;height:27px">	
	</td></tr>
	
	<tr><td class="hide"><iframe width="100%" name="annotationprocess" id="annotationprocess"></iframe></td></tr>	
	
	</table>	
			
</form>

</cfoutput>

<cfset ajaxonload("doHighlight")>

		
	
	


