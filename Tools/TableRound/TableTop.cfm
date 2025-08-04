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

   <cfparam name="Attributes.Size" default="97%"> 
   <cfparam name="Attributes.Margin" default="4">
   <cfparam name="Attributes.Omit" default="false">
   <cfparam name="Attributes.Space" default="true">
   <cfparam name="Attributes.Height" default="5%">
   <cfparam name="Attributes.bgcolor" default="">
   <cfparam name="Attributes.id" default=""> 

   <cfoutput>
   
   <cfif Attributes.Omit eq "false">
    <TABLE WIDTH="#Attributes.Size#" ALIGN="CENTER" BORDER="0" CELLSPACING="0" CELLPADDING="0">
      <TR BGCOLOR="#Attributes.bgcolor#">
   	    
        <TD width="6" class="noprint"><img src="#SESSION.root#/Images/tabletlhs.gif" WIDTH="6" HEIGHT="6"></TD>
        <TD width="100%"><img src="#SESSION.root#/images/TableMidTop.gif" WIDTH="100%" HEIGHT="6"></TD>
        <TD width="6" class="noprint"><img src="#SESSION.root#/images/tabletrhs.gif" WIDTH="6" HEIGHT="6"></TD>
		
      </TR>
    </TABLE>  
	</cfif>
		
	<TABLE BGCOLOR="#Attributes.bgcolor#" WIDTH="<cfoutput>#Attributes.Size#</cfoutput>" height="<cfoutput>#Attributes.Height#</cfoutput>" ALIGN="CENTER" BORDER="0" CELLSPACING="0" CELLPADDING="0" BGCOLOR="FFFFFF">
	
	<cfif Attributes.Space eq "True">
	
		<cfif Attributes.Omit eq "true">
		<TR>
	        <TD bgcolor="CCCCCC" width="1" style="padding:0px"></TD>
	        <TD colspan="3" height="7" style="padding:0px"></TD>
	        <TD bgcolor="CCCCCC" width="1" style="padding:0px"></TD>
	      </TR>
	    </cfif>	  
		  
	  <TR>
        <TD bgcolor="CCCCCC" width="1" style="padding:0px"></TD>
        <TD colspan="3" height="1" style="padding:0px"></TD>
        <TD bgcolor="CCCCCC" width="1" style="padding:0px"></TD>
      </TR>
	
	</cfif>  
	  
	<TR>
        <TD bgcolor="CCCCCC" width="1" style="padding:0px"></TD>
        <TD width="<cfoutput>#Attributes.Margin#</cfoutput>" bgcolor="#Attributes.bgcolor#" style="padding:0px"></TD>
        <TD VALIGN="top" class="regular" id="#attributes.id#" style="padding:0px">	
		
	</cfoutput>
     	  
     <!--- YOUR STUFF GOES HERE --->
	 
	  