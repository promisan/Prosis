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
    <cfparam name="Attributes.Size" default="93%"> 
	<cfparam name="Attributes.Margin" default="10">
	 <cfparam name="Attributes.bgcolor" default="ffffff">
<cfoutput>
    <!--- </table>  --->
     	
        </TD>
        <TD width="<cfoutput>#Attributes.Margin#</cfoutput>" BGCOLOR="#Attributes.bgcolor#" style="padding:0px"></TD>
        <TD bgcolor="CCCCCC" width="1" style="padding:0px"></TD>
      </TR>
    </TABLE>
	<TABLE WIDTH="<cfoutput>#Attributes.Size#</cfoutput>" ALIGN="CENTER" BORDER="0" CELLSPACING="0" CELLPADDING="0">
      <TR BGCOLOR="#Attributes.bgcolor#">
	    
        <TD width="6" style="padding:0px" class="noprint"><img src="#SESSION.root#/Images/tableblhs.gif" WIDTH="6" HEIGHT="6"></TD>
        <TD width="100%" style="padding:0px" ><img src="#SESSION.root#/images/TableMidBottom.gif" WIDTH="100%" HEIGHT="6"></TD>
        <TD width="6" style="padding:0px" class="noprint"><img src="#SESSION.root#/Images/tablebrhs.gif" WIDTH="6" HEIGHT="6"></TD>
		
      </TR>
      <TR><TD colspan="3" BGCOLOR="#Attributes.bgcolor#" height="10" style="padding:0px"></TD></TR>
    </TABLE>	
	
</cfoutput>					   