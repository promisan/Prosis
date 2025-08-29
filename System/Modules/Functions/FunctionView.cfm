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
<cf_tl id="Module manager" var="1">


<cf_screenTop height="100%" html="No" label="#lt_text#" jQuery="yes" layout="webapps" banner="gray" bannerforce="Yes" menuAccess="Yes" border="0" scroll="no" validateSession="Yes">

<cfajaximport tags="cfdiv,cfform">
<cf_layoutscript>

<cfinclude template="FunctionViewScript.cfm">

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea 
          position="header"	name="controltop" maxsize="30" size="30">		      					  
			 <cfinclude template="FunctionMenu.cfm">		 			 
	</cf_layoutarea>		 
			  
	<cf_layoutarea position="left" name="tree" maxsize="400" size="290" collapsible="true" splitter="true">
	     <cf_divscroll> 
			<cfinclude template="FunctionTree.cfm">
		 </cf_divscroll>	
	</cf_layoutarea>
	
	<cf_layoutarea  position="center" name="right">
			<cfinclude template="FunctionInit.cfm">
	</cf_layoutarea>			
		
</cf_layout>
