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

<!--- show the annotation colors --->

<cfparam name="url.entity"    default="Requisition">
<cfparam name="url.Key1"      default="">	
<cfparam name="url.Key2"      default="">
<cfparam name="url.Key3"      default="">	
<cfparam name="url.Key4"      default="">	
<cfparam name="url.box"       default="">	

<cfparam name="Attributes.entity"      default="#url.entity#">
<cfparam name="Attributes.KeyValue1"   default="#url.Key1#">	
<cfparam name="Attributes.KeyValue2"   default="#url.Key2#">
<cfparam name="Attributes.KeyValue3"   default="#url.Key3#">	
<cfparam name="Attributes.KeyValue4"   default="#url.Key4#">	
<cfparam name="Attributes.docbox"      default="#url.box#">	

<cfset ent    = attributes.entity>
<cfset k1     = attributes.keyvalue1>
<cfset k2     = attributes.keyvalue2>
<cfset k3     = attributes.keyvalue3>
<cfset k4     = attributes.keyvalue4>
<cfset bx     = attributes.docbox>

<cfquery name="Color" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 
	 SELECT DISTINCT U.AnnotationId,Description,Color,A.ListingOrder
	 FROM   UserAnnotationRecord U INNER JOIN UserAnnotation A ON U.Account  = A.Account AND U.AnnotationId = A.AnnotationId
	 WHERE  (U.Account  = '#SESSION.acc#' OR U.Scope = 'Shared')
	 
	 AND    U.EntityCode   = '#ent#'
	 <cfif k1 neq "">
	 AND    U.ObjectKeyValue1 = '#k1#'	
	 </cfif>
	 <cfif k2 neq "">
	 AND    U.ObjectKeyValue2 = '#k2#'	
	 </cfif>
	 <cfif k3 neq "">
	 AND    U.ObjectKeyValue3 = '#k3#'	
	 </cfif>
	 <cfif k4 neq "">
	 AND    U.ObjectKeyValue4 = '#k4#'	
	 </cfif>		 		
	 ORDER BY A.ListingOrder
	 
</cfquery>	
	
<cfoutput>
	
<table style="height:98%;min-width:20px">
<tr onclick="editannotation('#ent#','#k1#','#k2#','#k3#','#k4#','#bx#')">	  		  	
	<cfif color.recordcount eq "0">			
		<td bgcolor="white" height="16" title="Click to annotate" style="min-width:20px;cursor:pointer;border:1px solid silver"></td>				
	<cfelse>		
		<cfloop query="color">				    
			<td height="16"  title="#Description#" width="4" style="background-color:#color#;cursor:pointer;border:1px solid silver"></td>			
		</cfloop>	
	</cfif>
</tr>
<tr>
   <td class="hide" id="annotation#bx#" onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/Tools/Annotation/AnnotationShow.cfm?box=#bx#&entity=#ent#&key1=#k1#&key2=#k2#&key3=#k3#&key4=#k4#','#bx#')"></td>
</tr>
</table>

</cfoutput>
