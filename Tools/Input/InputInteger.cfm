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
<cfoutput>
<table bgcolor="EaEaEa">
	<tr><td style="border:1px solid silver">					
	<img src="#SESSION.root#/images/up6.png" 
			 id="#attributes.id#_up" 
			 width="#attributes.width#" 
			 height="#attributes.height#" 
			 style="cursor:pointer" 
			 onclick="var num= $('###attributes.id#').val() - 1 + 2; $('###attributes.id#').val(num);;$('###attributes.id#').change();"
			 border="0"></td></tr>	
	<tr><td style="border:1px solid silver">
	<img src="#SESSION.root#/images/down6.png" 
			id="#attributes.id#_down" 
			width="#attributes.width#" 
			onclick="var num= $('###attributes.id#').val() - 1; $('###attributes.id#').val(num);$('###attributes.id#').change()"
			height="#attributes.height#" 	
			style="cursor:pointer" 		
			border="0">						
	</td></tr>	
</table>	
</cfoutput>	