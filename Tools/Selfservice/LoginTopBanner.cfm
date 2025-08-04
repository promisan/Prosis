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

<head>
	<title>Portal</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />	
	<cfoutput>
	<link rel="stylesheet" type="text/css"  href="#SESSION.root#/#client.style#"> 	
	</cfoutput>
</head>

<cfoutput>

<cfset image = "#SESSION.root#/tools/selfservice/LoginImages">

<table border="0" cellpadding="0" cellspacing="0" width="100%">

  <tr>
  
   <td rowspan="2" colspan="1">
     <img name="inside01_r1_c2" src="#image#/#attributes.functionName#.jpg" 
	 width="549" height="56" border="0" id="inside01_r1_c2" alt="" />
   </td>
   <td colspan="1" background="#image#/inside01_r1_c7.jpg"> </td>
    </tr>
    
  <tr>
   <td colspan="1" background="#image#/inside01_r2_c7.jpg" width="100%"></td>     
  </tr>
 
</table> 

</cfoutput>